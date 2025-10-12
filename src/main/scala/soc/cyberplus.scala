// VexRiscv CyberPlus demo
package soc

import periph._
import vexriscv.plugin._
import vexriscv._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.com.jtag.Jtag
import spinal.lib.com.jtag.sim.JtagTcp
import spinal.lib.com.uart.{UartCtrlGenerics}
import spinal.lib.io.{TriStateArray, InOutWrapper}
import spinal.lib.system.debugger.{
  JtagAxi4SharedDebugger,
  JtagBridge,
  SystemDebugger,
  SystemDebuggerConfig
}
import scala.collection.mutable.ArrayBuffer
import scala.collection.Seq

case class CyberPlusConfig(
    axiFrequency: HertzNumber,
    memSize: BigInt,
    memFile: String,
    memFileType: String,
    cpuPlugins: ArrayBuffer[Plugin[VexRiscv]]
)

object CyberPlusConfig {
  def default = {
    val config = CyberPlusConfig(
      axiFrequency = 100 MHz,
      memSize = 64 KiB,
      memFile = null,
      memFileType = "rawhex",
      cpuPlugins = ArrayBuffer(
        new PcManagerSimplePlugin(0x80000000L, false),
        new IBusCachedPlugin(
          resetVector = 0x80000000L,
          prediction = STATIC,
          config = InstructionCacheConfig(
            cacheSize = 4096,
            bytePerLine = 32,
            wayCount = 1,
            addressWidth = 32,
            cpuDataWidth = 32,
            memDataWidth = 32,
            catchIllegalAccess = true,
            catchAccessFault = true,
            asyncTagMemory = false,
            twoCycleRam = true,
            twoCycleCache = true
          )
        ),
        new DBusCachedPlugin(
          config = new DataCacheConfig(
            cacheSize = 4096,
            bytePerLine = 32,
            wayCount = 1,
            addressWidth = 32,
            cpuDataWidth = 32,
            memDataWidth = 32,
            catchAccessError = true,
            catchIllegal = true,
            catchUnaligned = true
          ),
          memoryTranslatorPortConfig = null
        ),
        new StaticMemoryTranslatorPlugin(
          ioRange = _(31 downto 28) === 0xf
        ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.SYNC,
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new FullBarrelShifterPlugin,
        new MulPlugin,
        new DivPlugin,
        new HazardSimplePlugin(
          bypassExecute = true,
          bypassMemory = true,
          bypassWriteBack = true,
          bypassWriteBackBuffer = true,
          pessimisticUseSrc = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new BranchPlugin(
          earlyBranch = false,
          catchAddressMisaligned = true
        ),
        new CsrPlugin(
          config = CsrPluginConfig(
            catchIllegalAccess = false,
            mvendorid = null,
            marchid = null,
            mimpid = null,
            mhartid = null,
            misaExtensionsInit = 66,
            misaAccess = CsrAccess.NONE,
            mtvecAccess = CsrAccess.READ_WRITE,
            mtvecInit = 0x80000020L,
            mepcAccess = CsrAccess.READ_WRITE,
            mscratchGen = false,
            mcauseAccess = CsrAccess.READ_ONLY,
            mbadaddrAccess = CsrAccess.READ_ONLY,
            mcycleAccess = CsrAccess.NONE,
            minstretAccess = CsrAccess.NONE,
            ecallGen = true,
            wfiGenAsWait = false,
            ucycleAccess = CsrAccess.NONE,
            uinstretAccess = CsrAccess.NONE
          )
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
    config
  }
}

class CyberPlus(config: CyberPlusConfig) extends Component {
  // Legacy constructor
  def this(axiFrequency: HertzNumber) {
    this(CyberPlusConfig.default.copy(axiFrequency = axiFrequency))
  }

  import config._
  val debug = true
  val interruptCount = 16

  val io = new Bundle {
    // Clocks / reset
    val rstn = in Bool ()
    val clk = in Bool ()
    // Main components IO
    val jtag = slave(Jtag())
    // Peripherals IO
    val gpio = master(TriStateArray(32 bits))
  }

  val resetCtrlClockDomain = ClockDomain(
    clock = io.clk,
    config = ClockDomainConfig( resetKind = BOOT )
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
    when(BufferCC(~io.rstn)) { axiResetCounter := 0 }
    // When an axiResetOrder happen, the core reset will as well
    when(axiResetUnbuffered) { coreResetUnbuffered := True }
    // Create all reset used later in the design
    val axiReset = RegNext(axiResetUnbuffered)
    val coreReset = RegNext(coreResetUnbuffered)
  }

  val axiClockDomain = ClockDomain(
    clock = io.clk,
    reset = resetCtrl.axiReset,
    frequency = FixedFrequency(axiFrequency)
  )

  val coreClockDomain = ClockDomain(
    clock = io.clk,
    reset = resetCtrl.coreReset
  )

  val jtagClockDomain = ClockDomain(
    clock = io.clk,
    reset = resetCtrl.coreReset,
    frequency = FixedFrequency(axiFrequency)
  )

  val axi = new ClockingArea(axiClockDomain) {
    val ram = Axi4Ram(
      dataWidth = 32,
      byteCount = memSize,
      idWidth = 4,
      memFile = memFile,
      memFileType = memFileType,
      memOffset = 0x80000000L
    )

    /* ------------------------ APB BUS ------------------------ */
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
      groupSpace = 0x1000, // 0x400
      withReadSync = true
    )
    gpioCtrl.io.afio := afioCtrl.io.afio.write
    afioCtrl.io.afio.read := gpioCtrl.io.gpio.read

    val timCtrl = Apb3TimArray(timCnt = 2, timSpace = 0x1000)
    val timerInterrupt = timCtrl.io.interrupt.asBits.orR // 按位“或”
    val wdgCtrl = coreClockDomain(Apb3Wdg(memSize = 0x1000))
    resetCtrl.coreResetUnbuffered.setWhen(wdgCtrl.io.iwdgRst || wdgCtrl.io.wwdgRst)
    val systickCtrl = Apb3SysTick()
    val systickInterrupt = systickCtrl.io.interrupt.asBits.orR // 按位“或”

    val uartCtrl = Apb3UartArray(
      uartCnt = 2,
      uartSpace = 0x1000,
      uartConfig = Apb3UartCtrlConfig(
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

    val i2cCtrl = Apb3I2cArray(i2cCnt = 2, i2cSpace = 0x1000)
    val i2cInterrupt = i2cCtrl.io.interrupt.asBits.orR // 按位“或”

    val spiCtrl = Apb3SpiArray(spiCnt = 2, spiSpace = 0x1000)
    val spiInterrupt = spiCtrl.io.interrupt.asBits.orR // 按位“或”

    afioCtrl.io.device.read :=
      False ## // 31
      spiCtrl.io.spis(1).mosi ## // 30
      spiCtrl.io.spis(1).ss ## // 29
      spiCtrl.io.spis(0).sclk ## // 28
      False ## // 27
      spiCtrl.io.spis(0).mosi ## // 26
      spiCtrl.io.spis(0).ss ## // 25
      spiCtrl.io.spis(0).sclk ## // 24
      i2cCtrl.io.i2cs(1).scl ## // 23
      i2cCtrl.io.i2cs(1).sda.write ## // 22
      i2cCtrl.io.i2cs(0).scl ## // 21
      i2cCtrl.io.i2cs(0).sda.write ## // 20
      // B(0, 4 bits) ##
      False ## // 19
      uartCtrl.io.uarts(1).txd ## // 18
      False ## // 17
      uartCtrl.io.uarts(0).txd ## // 16
      timCtrl.io.ch ## // 8 - 15: 定时器通道
      B(0, 8 bits) // 0 - 7: 保留空位

    uartCtrl.io.uarts(0).rxd := afioCtrl.io.device.write(17)
    uartCtrl.io.uarts(1).rxd := afioCtrl.io.device.write(19)
    spiCtrl.io.spis(0).miso := afioCtrl.io.device.write(27)
    spiCtrl.io.spis(1).miso := afioCtrl.io.device.write(31)
    i2cCtrl.io.i2cs(0).sda.read := afioCtrl.io.device.write(20).asBits
    i2cCtrl.io.i2cs(1).sda.read := afioCtrl.io.device.write(22).asBits

    val apbDecoder = Apb3Decoder(
      master = apbBridge.io.apb,
      slaves = List(
        gpioCtrl.io.apb -> (0x00000, 64 KiB),
        uartCtrl.io.apb -> (0x10000, 64 KiB),
        i2cCtrl.io.apb -> (0x20000, 64 KiB),
        spiCtrl.io.apb -> (0x30000, 64 KiB),
        timCtrl.io.apb -> (0x40000, 64 KiB),
        wdgCtrl.io.apb -> (0x50000, 64 KiB),
        systickCtrl.io.apb -> (0x60000, 64 KiB),
        afioCtrl.io.apb -> (0xd0000, 64 KiB),
        extiCtrl.io.apb -> (0xe0000, 64 KiB)
      )
    )

    val externalInterrupt = Bool()
    if (interruptCount > 0) {
      val externalBits = Reg(Bits(interruptCount bits)) init(0)
      externalBits(0) := uartInterrupt
      externalBits(3) := extiInterrupt
      externalBits(4) := i2cInterrupt
      externalBits(15) := spiInterrupt
      externalInterrupt := externalBits.orR
    } else { externalInterrupt := False }

    /* ------------------------ Vexriscv ------------------------ */
    val core = new Area {
      val config = VexRiscvConfig(plugins = cpuPlugins += new DebugPlugin(jtagClockDomain))
      val cpu = new VexRiscv(config)
      var iBus: Axi4ReadOnly = null
      var dBus: Axi4Shared = null
      for (plugin <- config.plugins) plugin match {
        case plugin: IBusSimplePlugin => iBus = plugin.iBus.toAxi4ReadOnly()
        case plugin: IBusCachedPlugin => iBus = plugin.iBus.toAxi4ReadOnly()
        case plugin: DBusSimplePlugin => dBus = plugin.dBus.toAxi4Shared()
        case plugin: DBusCachedPlugin => dBus = plugin.dBus.toAxi4Shared(true)
        case plugin: CsrPlugin => {
          plugin.externalInterrupt := externalInterrupt
          plugin.timerInterrupt := timerInterrupt | systickInterrupt
        }
        case plugin: DebugPlugin =>
          jtagClockDomain {
            resetCtrl.axiReset setWhen (RegNext(plugin.io.resetOut))
            io.jtag <> plugin.io.bus.fromJtag()
          }
        case _ =>
      }
    }

    /* ------------------------ AXI BUS ------------------------ */
    val axiCrossbar = Axi4CrossbarFactory()

    axiCrossbar.addSlaves(
      ram.io.axi -> (0x80000000L, memSize),
      apbBridge.io.axi -> (0xf0000000L, 1 MB)
    )

    axiCrossbar.addConnections(
      core.iBus -> List(ram.io.axi), 
      core.dBus -> List(ram.io.axi, apbBridge.io.axi)
    )

    axiCrossbar.addPipelining(apbBridge.io.axi)((crossbar, bridge) => {
      crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
      crossbar.writeData.halfPipe() >> bridge.writeData
      crossbar.writeRsp << bridge.writeRsp
      crossbar.readRsp << bridge.readRsp
    })

    axiCrossbar.addPipelining(ram.io.axi)((crossbar, ctrl) => {
      crossbar.sharedCmd.halfPipe() >> ctrl.sharedCmd
      crossbar.writeData >/-> ctrl.writeData
      crossbar.writeRsp << ctrl.writeRsp
      crossbar.readRsp << ctrl.readRsp
    })

    axiCrossbar.addPipelining(core.dBus)((cpu, crossbar) => {
      cpu.sharedCmd >> crossbar.sharedCmd
      cpu.writeData >> crossbar.writeData
      cpu.writeRsp << crossbar.writeRsp
      cpu.readRsp <-< crossbar.readRsp
    })

    axiCrossbar.build()
  }
  io.gpio <> axi.gpioCtrl.io.gpio
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// CyberPlus-SoC with memory init
object CyberPlus {
  def main(args: Array[String]) {
    val config =
      SpinalConfig(verbose = true, targetDirectory = "rtl").dumpWave()
    val report = config.generateVerilog(
      InOutWrapper(
        new CyberPlus(
          CyberPlusConfig.default.copy(
            memFile = "test/software/rt-thread/cyberplus/build/demo.hex",
            memFileType = "rawhex"
            // memFile = "test/software/bare/cyberplus/build/demo.hex",
            // memFileType = "rawhex"
            // memFile = "test/software/bare/cyberplus/build/mem/demo.bin",
            // memFileType = "bin"
            // memFile = "test/software/bare/cyberplus/build/mem/demo.hex",
            // memFileType = "hex"
          )
        )
      )
    )
  }
}
