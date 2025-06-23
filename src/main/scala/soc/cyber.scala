package soc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.com.jtag.Jtag
import spinal.lib.com.uart._
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

import periph.ram._
import periph.gpio._
import periph.afio._
import periph.exti._
// import periph.uart._
import periph.tim._
import periph.wdg._
import periph.systick._

case class cyberConfig(
    axiFrequency: HertzNumber,
    onChipRamSize: BigInt,
    onChipRamHexFile: String,
    cpu: RiscvCoreConfig,
    iCache: InstructionCacheConfig
)

object cyberConfig {
  def default = {
    val config = cyberConfig(
      axiFrequency = 100 MHz,
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

class cyber(config: cyberConfig) extends Component {
  def this(axiFrequency: HertzNumber) {
    this(cyberConfig.default.copy(axiFrequency = axiFrequency))
  }

  import config._
  val debug = true
  val interruptCount = 4

  val io = new Bundle {
    // Clocks / reset
    val asyncReset = in Bool ()
    val axiClk = in Bool ()
    // Main components IO
    val jtag = slave(Jtag())
    // Peripherals IO
    val gpio = master(TriStateArray(32 bits))
    val uart = master(Uart())
  }

  val resetCtrlClockDomain = ClockDomain(
    clock = io.axiClk,
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
    when(BufferCC(io.asyncReset)) {
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
    clock = io.axiClk,
    reset = resetCtrl.axiReset,
    frequency = FixedFrequency(axiFrequency)
  )

  val coreClockDomain = ClockDomain(
    clock = io.axiClk,
    reset = resetCtrl.coreReset
  )

  val jtagClockDomain = ClockDomain(
    clock = io.jtag.tck
  )

  val axi = new ClockingArea(axiClockDomain) {
    val core = coreClockDomain {
      new RiscvAxi4(
        coreConfig = config.cpu,
        iCacheConfig = config.iCache,
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
      addressWidth = 5,
      dataWidth = 32
    )

    val extiCtrl = Apb3Exti(extiWidth = 16)
    val extiInterrupt = extiCtrl.io.interrupt.asBits.orR // 按位“或”
    extiCtrl.io.exti := afioCtrl.io.afioExti

    val gpioCtrl = Apb3GpioArray(
      gpioWidth = 16,
      gpioGroupCnt = 2,
      // groupSpace = 0x400,
      groupSpace = 0x1000,
      withReadSync = true
    )
    // gpioCtrl.io.afio := B(0, 32 bits) // 临时接0，等待外部AFIO模块接入
    gpioCtrl.io.afio := afioCtrl.io.afio.write
    afioCtrl.io.afio.read := gpioCtrl.io.gpio.read

    val timCtrl = Apb3TimArray(timCnt = 2, timSpace = 0x1000)
    val timInterrupt = timCtrl.io.interrupt.asBits.orR // 按位“或”
    afioCtrl.io.device := timCtrl.io.tim_ch.resize(32) // 临时接0，等待外部AFIO模块接入
    val wdgCtrl = coreClockDomain(Apb3Wdg(memSize = 0x1000)) // 看门狗复位信号参与 coreResetUnbuffered 控制
    resetCtrl.coreResetUnbuffered setWhen (wdgCtrl.io.iwdgRst || wdgCtrl.io.wwdgRst)
    val systickCtrl = Apb3SysTick()

    val uartCtrlConfig = UartCtrlMemoryMappedConfig(
      uartCtrlConfig = UartCtrlGenerics(
        dataWidthMax = 8,
        clockDividerWidth = 20,
        preSamplingSize = 1,
        samplingSize = 3,
        postSamplingSize = 1
      ),
      initConfig = UartCtrlInitConfig(
        baudrate = 115200,
        dataLength = 7, // 7 => 8 bits
        parity = UartParityType.NONE,
        stop = UartStopType.ONE
      ),
      txFifoDepth = 16,
      rxFifoDepth = 16
    )
    val uartCtrl = Apb3UartCtrl(uartCtrlConfig)

    val axiCrossbar = Axi4CrossbarFactory()

    axiCrossbar.addSlaves(
      ram.io.axi -> (0x00000000L, onChipRamSize),
      apbBridge.io.axi -> (0xf0000000L, 1 MiB)
    )

    axiCrossbar.addConnections(
      core.io.i -> List(ram.io.axi),
      core.io.d -> List(ram.io.axi, apbBridge.io.axi),
      jtagCtrl.io.axi -> List(ram.io.axi, apbBridge.io.axi)
    )

    axiCrossbar.addPipelining(apbBridge.io.axi)((crossbar, bridge) => {
      crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
      crossbar.writeData.halfPipe() >> bridge.writeData
      crossbar.writeRsp << bridge.writeRsp
      crossbar.readRsp << bridge.readRsp
    })

    axiCrossbar.build()

    val apbDecoder = Apb3Decoder(
      master = apbBridge.io.apb,
      slaves = List(
        gpioCtrl.io.apb -> (0x00000, 64 KiB),
        uartCtrl.io.apb -> (0x10000, 64 KiB),
        timCtrl.io.apb   -> (0x40000, 64 KiB),
        wdgCtrl.io.apb -> (0x50000, 64 KiB),
        systickCtrl.io.apb -> (0x60000, 64 KiB),
        afioCtrl.io.apb -> (0xd0000, 64 KiB),
        extiCtrl.io.apb -> (0xe0000, 64 KiB),
        core.io.debugBus -> (0xf0000, 64 KiB)
      )
    )

    if (interruptCount != 0) {
      core.io.interrupt := (
        (0 -> uartCtrl.io.interrupt),
        (1 -> timInterrupt),
        (2 -> systickCtrl.io.interrupt),
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
  io.uart <> axi.uartCtrl.io.uart
}

object cyber {
  def main(args: Array[String]) {
    val config =
      SpinalConfig(verbose = true, targetDirectory = "rtl").dumpWave()
    val report = config.generateVerilog(
      InOutWrapper(
        new cyber(
          cyberConfig.default.copy(
            onChipRamSize = 32 kB,
            onChipRamHexFile = "test/cyber/demo.hex"
          )
        )
      )
    )
  }
}
