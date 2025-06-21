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
        startAddress = BigInt(0x80000000L),
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
    val timerExternal = in(cyberTimerCtrlExternal())
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

    val gpioCtrl = Apb3GpioArray(
      gpioWidth = 16,
      gpioGroupCnt = 2,
      // groupSpace = 0x400,
      groupSpace = 0x1000,
      withReadSync = true
    )
    gpioCtrl.io.afio := B(0, 32 bits) // 临时接0，等待外部AFIO模块接入

    val wdgCtrl = coreClockDomain(Apb3Wdg(memSize = 0x1000)) // 看门狗复位信号参与 coreResetUnbuffered 控制
    resetCtrl.coreResetUnbuffered setWhen (wdgCtrl.io.iwdgRst || wdgCtrl.io.wwdgRst)
    val systickCtrl = Apb3SysTick()

    val timerCtrl = cyberTimerCtrl()

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
      ram.io.axi -> (0x80000000L, onChipRamSize),
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
        timerCtrl.io.apb -> (0x20000, 64 KiB),
        wdgCtrl.io.apb -> (0x50000, 64 KiB),
        systickCtrl.io.apb -> (0x60000, 64 KiB),
        core.io.debugBus -> (0xf0000, 64 KiB)
      )
    )

    if (interruptCount != 0) {
      core.io.interrupt := (
        (0 -> uartCtrl.io.interrupt),
        (1 -> timerCtrl.io.interrupt),
        (2 -> systickCtrl.io.interrupt),
        (default -> false)
      )
    }

    if (debug) {
      core.io.debugResetIn := resetCtrl.axiReset
      resetCtrl.coreResetUnbuffered setWhen (core.io.debugResetOut)
    }
  }

  io.gpio <> axi.gpioCtrl.io.gpio
  io.timerExternal <> axi.timerCtrl.io.external
  io.jtag <> axi.jtagCtrl.io.jtag
  io.uart <> axi.uartCtrl.io.uart
}

object cyberTimerCtrl {
  def getApb3Config() = new Apb3Config(
    addressWidth = 8,
    dataWidth = 32
  )
}

case class cyberTimerCtrlExternal() extends Bundle {
  val clear = Bool()
  val tick = Bool()
}

case class cyberTimerCtrl() extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(cyberTimerCtrl.getApb3Config()))
    val external = in(cyberTimerCtrlExternal())
    val interrupt = out Bool ()
  }
  val external = BufferCC(io.external)

  val prescaler = Prescaler(16)
  val timerA = Timer(32)
  val timerB, timerC, timerD = Timer(16)

  val busCtrl = Apb3SlaveFactory(io.apb)
  val prescalerBridge = prescaler.driveFrom(busCtrl, 0x00)

  val timerABridge = timerA.driveFrom(busCtrl, 0x40)(
    ticks = List(True, prescaler.io.overflow),
    clears = List(timerA.io.full)
  )

  val timerBBridge = timerB.driveFrom(busCtrl, 0x50)(
    ticks = List(True, prescaler.io.overflow, external.tick),
    clears = List(timerB.io.full, external.clear)
  )

  val timerCBridge = timerC.driveFrom(busCtrl, 0x60)(
    ticks = List(True, prescaler.io.overflow, external.tick),
    clears = List(timerC.io.full, external.clear)
  )

  val timerDBridge = timerD.driveFrom(busCtrl, 0x70)(
    ticks = List(True, prescaler.io.overflow, external.tick),
    clears = List(timerD.io.full, external.clear)
  )

  val interruptCtrl = InterruptCtrl(4)
  val interruptCtrlBridge = interruptCtrl.driveFrom(busCtrl, 0x10)
  interruptCtrl.io.inputs(0) := timerA.io.full
  interruptCtrl.io.inputs(1) := timerB.io.full
  interruptCtrl.io.inputs(2) := timerC.io.full
  interruptCtrl.io.inputs(3) := timerD.io.full
  io.interrupt := interruptCtrl.io.pendings.orR
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
