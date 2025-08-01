package soc.gowin

import periph._
import graphic.hdmi._
import soc.gowin.tangprimer._

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.com.uart.{UartCtrlGenerics}
import spinal.lib.com.jtag.Jtag
import spinal.lib.cpu.riscv.impl.Utils.BR
import spinal.lib.cpu.riscv.impl.build.RiscvAxi4
import spinal.lib.cpu.riscv.impl.extension.{
  BarrelShifterFullExtension,
  DivExtension,
  MulExtension
}
import spinal.lib.cpu.riscv.impl._
import spinal.lib.io.{TriStateArray, InOutWrapper}
import spinal.lib.system.debugger.{JtagAxi4SharedDebugger, SystemDebuggerConfig}
import spinal.lib.misc.{InterruptCtrl, Timer, Prescaler}
import spinal.lib.graphic.RgbConfig
import spinal.lib.graphic.vga.{Axi4VgaCtrl, Axi4VgaCtrlGenerics, Vga}
import spinal.lib.graphic.hdmi.VgaToHdmiEcp5


case class cyberwithddrhdmiConfig(
    axiFrequency: HertzNumber,
    memFrequency: HertzNumber,
    onChipRamSize: BigInt,
    onChipRamHexFile: String,
    cpu: RiscvCoreConfig,
    iCache: InstructionCacheConfig
)

object cyberwithddrhdmiConfig {
  def default = {
    val config = cyberwithddrhdmiConfig(
      axiFrequency = 100 MHz,
      memFrequency = 400 MHz,
      onChipRamSize = 4 KiB,
      onChipRamHexFile = null,
      cpu = RiscvCoreConfig(
        pcWidth = 32,
        addrWidth = 32,
        startAddress = 0x00000000,
        regFileReadyKind = sync,
        branchPrediction = dynamic,
        bypassExecute0 = true,
        bypassExecute1 = true,
        bypassWriteBack = true,
        bypassWriteBackBuffer = true,
        collapseBubble = false,
        fastFetchCmdPcCalculation = true,
        dynamicBranchPredictorCacheSizeLog2 = 7
      ),
      iCache = InstructionCacheConfig(
        cacheSize = 4096,
        bytePerLine = 32,
        wayCount = 1, // Can only be one for the moment
        wrappedMemAccess = true,
        addressWidth = 32,
        cpuDataWidth = 32,
        memDataWidth = 32
      )
    )
    // The CPU has a systems of plugin which allow to add new feature into the core.
    // Those extension are not directly implemented into the core, but are kind of additive logic patch defined in a separated area.
    config.cpu.add(new MulExtension)
    config.cpu.add(new DivExtension)
    config.cpu.add(new BarrelShifterFullExtension)

    config
  }
}

class cyberwithddrhdmi(config: cyberwithddrhdmiConfig) extends Component {
  def this(axiFrequency: HertzNumber) {
    this(cyberwithddrhdmiConfig.default.copy(axiFrequency = axiFrequency))
  }

  import config._
  val debug = true
  val interruptCount = 16
  def vgaRgbConfig = RgbConfig(5, 6, 5)

  val io = new Bundle {
    // Clocks / reset
    val rstn = in Bool ()
    val clk = in Bool ()
    // Main components IO
    val jtag = slave(Jtag())
    val sdram = master(DDR3_Interface())
    // Peripherals IO
    val gpio = master(TriStateArray(32 bits))
    // Graphics IO
    val hdmi = master(Hdmi())
  }

  val sysclk = new syspll
  sysclk.clkin := io.clk
  // sysclk.reset := ~io.rstn
  sysclk.reset := False

  val memclk = new mempll
  memclk.clkin := sysclk.clkout
  // memclk.reset := ~io.rstn
  memclk.reset := False

  val hdmiclk = new hdmipll
  hdmiclk.clkin := io.clk
  // hdmiclk.reset := ~io.rstn
  hdmiclk.reset := False
  val CLKDIV = new CLKDIV
  CLKDIV.RESETN := io.rstn
  CLKDIV.CALIB := True
  CLKDIV.HCLKIN := hdmiclk.clkout

  val resetCtrlClockDomain = ClockDomain(
    clock = sysclk.clkout,
    config = ClockDomainConfig(
      resetKind = BOOT
    )
  )

  val resetCtrl = new ClockingArea(resetCtrlClockDomain) {
    val axiResetUnbuffered = False
    val coreResetUnbuffered = False
    // Implement an counter to keep the reset axiResetOrder high 64 cycles
    // Also this counter will automaticly do a reset when the system boot.
    val axiResetCounter = Reg(UInt(6 bits)) init (0)
    when(axiResetCounter =/= U(axiResetCounter.range -> true)) {
      axiResetCounter := axiResetCounter + 1
      axiResetUnbuffered := True
    }
    when(BufferCC(~io.rstn)) {
      axiResetCounter := 0
    }
    // When an axiResetOrder happen, the core reset will as well
    when(axiResetUnbuffered) {
      coreResetUnbuffered := True
    }
    // Create all reset used later in the design
    val axiReset = RegNext(axiResetUnbuffered)
    val coreReset = RegNext(coreResetUnbuffered)
  }

  val axiClockDomain = ClockDomain(
    clock = sysclk.clkout,
    reset = resetCtrl.axiReset,
    frequency = FixedFrequency(axiFrequency)
  )

  val coreClockDomain = ClockDomain(
    clock = sysclk.clkout,
    reset = resetCtrl.coreReset
  )

  val memClockDomain = ClockDomain(
    clock = memclk.clkout,
    reset = resetCtrl.axiReset,
    frequency = FixedFrequency(memFrequency)
  )

  val hdmiClockDomain = ClockDomain(
    clock = hdmiclk.clkout,
    reset = resetCtrl.axiReset
  )

  val vgaClockDomain = ClockDomain(
    clock = CLKDIV.CLKOUT,
    reset = resetCtrl.axiReset
  )

  val jtagClockDomain = ClockDomain(
    clock = io.jtag.tck
  )

  val axi = new ClockingArea(axiClockDomain) {
    val core = coreClockDomain {
      new RiscvAxi4(
        coreConfig = config.cpu,
        // iCacheConfig = config.iCache, // 目前上板有问题，仿真正常
        iCacheConfig = null,
        dCacheConfig = null,
        debug = debug,
        interruptCount = interruptCount
      )
    }

    val ram = Axi4Ram(
      dataWidth = 32,
      byteCount = onChipRamSize,
      idWidth = 4,
      onChipRamHexFile = onChipRamHexFile
    )

    val sdramCtrl = Axi4Ddr(axiClockDomain, memClockDomain)
    sdramCtrl.io.pll_lock := memclk.lock && sysclk.lock

    val jtagCtrl = JtagAxi4SharedDebugger(
      SystemDebuggerConfig(
        memAddressWidth = 32,
        memDataWidth = 32,
        remoteCmdWidth = 1
      )
    )

    val apbBridge = Axi4SharedToApb3Bridge(
      addressWidth = 20,
      dataWidth = 32,
      idWidth = 4
    )

    val afioCtrl = Apb3Afio(
      gpioWidth = 16,
      gpioGroupCnt = 2,
      // afioConfig = BigInt("0005FFF00", 16),
      addressWidth = 5,
      dataWidth = 32
    )

    val extiCtrl = Apb3Exti(extiWidth = 16)
    val extiInterrupt = extiCtrl.io.interrupt.asBits.orR // 按位“或”
    extiCtrl.io.exti := afioCtrl.io.afioExti

    val gpioCtrl = Apb3GpioArray(
      gpioWidth = 16,
      gpioGroupCnt = 2,
      groupSpace = 0x1000, // 0x400
      withReadSync = true
    )
    gpioCtrl.io.afio := afioCtrl.io.afio.write
    afioCtrl.io.afio.read := gpioCtrl.io.gpio.read

    val timCtrl = Apb3TimArray(timCnt = 2, timSpace = 0x1000)
    val timInterrupt = timCtrl.io.interrupt.asBits.orR // 按位“或”
    val wdgCtrl = coreClockDomain(Apb3Wdg(memSize = 0x1000))
    resetCtrl.coreResetUnbuffered setWhen (wdgCtrl.io.iwdgRst || wdgCtrl.io.wwdgRst)
    val systickCtrl = Apb3SysTick()
    val systickInterrupt = systickCtrl.io.interrupt.asBits.orR // 按位“或”

    val uartCtrl = ApbUartArray(
      uartCount = 2,
      groupSpace = 0x1000,
      uartConfig = ApbUartCtrlConfig(
        uartCtrlGenerics = UartCtrlGenerics(
          dataWidthMax = 9,
          clockDividerWidth = 20,
          preSamplingSize = 1,
          samplingSize = 3,
          postSamplingSize = 1
        ),
        txFifoDepth = 16,
        rxFifoDepth = 16
      )
    )
    val uartInterrupt = uartCtrl.io.interrupt.asBits.orR // 按位“或”

    afioCtrl.io.device.read :=
      B(0, 12 bits) ## // 20 - 31: 保留空位
        False ## // 19
        uartCtrl.io.uarts(1).txd ## // 18
        False ## // 17
        uartCtrl.io.uarts(0).txd ## // 16
        timCtrl.io.tim_ch ## // 8 - 15: 定时器通道
        B(0, 8 bits) // 0 - 7: 保留空位
    uartCtrl.io.uarts(0).rxd := afioCtrl.io.device.write(17)
    uartCtrl.io.uarts(1).rxd := afioCtrl.io.device.write(19)

    val vgaCtrlConfig = Axi4VgaCtrlGenerics(
      axiAddressWidth = 32,
      axiDataWidth = 32,
      burstLength = 8,
      frameSizeMax = 2048 * 1512 * 2,
      fifoSize = 512,
      rgbConfig = vgaRgbConfig,
      vgaClock = vgaClockDomain
    )
    val vgaCtrl = Axi4VgaCtrl(vgaCtrlConfig)

    val vgatohdmi = VgaToHdmiGowin(vgaClockDomain, hdmiClockDomain, vgaRgbConfig)
    vgatohdmi.io.vga <> vgaCtrl.io.vga

    val axiCrossbar = Axi4CrossbarFactory()

    axiCrossbar.addSlaves(
      ram.io.axi -> (0x00000000L, onChipRamSize),
      sdramCtrl.io.axi -> (0x40000000L, 128 MiB),
      apbBridge.io.axi -> (0xf0000000L, 1 MiB)
    )

    axiCrossbar.addConnections(
      core.io.i -> List(ram.io.axi, sdramCtrl.io.axi),
      core.io.d -> List(ram.io.axi, sdramCtrl.io.axi, apbBridge.io.axi),
      jtagCtrl.io.axi -> List(ram.io.axi, sdramCtrl.io.axi, apbBridge.io.axi),
      vgaCtrl.io.axi -> List(sdramCtrl.io.axi)
    )

    axiCrossbar.addPipelining(apbBridge.io.axi)((crossbar, bridge) => {
      crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
      crossbar.writeData.halfPipe() >> bridge.writeData
      crossbar.writeRsp << bridge.writeRsp
      crossbar.readRsp << bridge.readRsp
    })

    axiCrossbar.addPipelining(sdramCtrl.io.axi)((crossbar, ctrl) => {
      crossbar.sharedCmd.halfPipe() >> ctrl.sharedCmd
      crossbar.writeData >/-> ctrl.writeData
      crossbar.writeRsp << ctrl.writeRsp
      crossbar.readRsp << ctrl.readRsp
    })

    axiCrossbar.build()

    val apbDecoder = Apb3Decoder(
      master = apbBridge.io.apb,
      slaves = List(
        gpioCtrl.io.apb -> (0x00000, 64 KiB),
        uartCtrl.io.apb -> (0x10000, 64 KiB),
        timCtrl.io.apb -> (0x40000, 64 KiB),
        wdgCtrl.io.apb -> (0x50000, 64 KiB),
        systickCtrl.io.apb -> (0x60000, 64 KiB),
        vgaCtrl.io.apb -> (0x70000, 64 KiB),
        afioCtrl.io.apb -> (0xd0000, 64 KiB),
        extiCtrl.io.apb -> (0xe0000, 64 KiB),
        core.io.debugBus -> (0xf0000, 64 KiB)
      )
    )

    if (interruptCount != 0) {
      core.io.interrupt := (
        (0 -> uartInterrupt),
        (1 -> timInterrupt),
        (2 -> systickInterrupt),
        (3 -> extiInterrupt),
        (default -> false)
      )
    }

    if (debug) {
      core.io.debugResetIn := resetCtrl.axiReset
      resetCtrl.coreResetUnbuffered setWhen (core.io.debugResetOut)
    }
  }

  io.gpio <> axi.gpioCtrl.io.gpio
  io.jtag <> axi.jtagCtrl.io.jtag
  io.sdram <> axi.sdramCtrl.io.ddr_iface
  io.hdmi <> axi.vgatohdmi.io.hdmi
}

object cyberwithddrhdmi {
  def main(args: Array[String]) {
    val config =
      SpinalConfig(verbose = true, targetDirectory = "rtl").dumpWave()
    val report = config.generateVerilog(
      InOutWrapper(
        new cyberwithddrhdmi(
          cyberwithddrhdmiConfig.default.copy(
            onChipRamSize = 32 kB,
            onChipRamHexFile = "test/cyber/build/mem/demo.bin"
          )
        )
      )
    )
  }
}
