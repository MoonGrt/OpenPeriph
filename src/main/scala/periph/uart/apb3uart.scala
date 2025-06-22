package periph.uart

import spinal.core._
import spinal.lib._
import spinal.lib.eda.altera.QSysify
import spinal.lib.FragmentToBitsStates._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config, Apb3SlaveFactory}
import spinal.lib.bus.misc.{BusSlaveFactoryAddressWrapper, BusSlaveFactory}

object UartParityType extends SpinalEnum(binarySequential) {
  val NONE, EVEN, ODD = newElement()
}

object UartStopType extends SpinalEnum(binarySequential) {
  val ONE, TWO = newElement()
  def toBitCount(that : C) : UInt = (that === ONE) ? U"0" | U"1"
}

case class Uart(ctsGen : Boolean = false, rtsGen : Boolean = false) extends Bundle with IMasterSlave {
  val txd = Bool()
  val rxd = Bool()
  val cts = ctsGen generate Bool()
  val rts = rtsGen generate Bool()
  override def asMaster(): Unit = {
    out(txd)
    in(rxd)
    outWithNull(rts)
    inWithNull(cts)
  }
}

object Apb3Uart{
  def getApb3Config = Apb3Config(
    addressWidth = 5,
    dataWidth = 32
  )
}

case class Apb3Uart(config : UartCtrlMemoryMappedConfig) extends Component{
  val io = new Bundle{
    val apb =  slave(Apb3(Apb3Uart.getApb3Config))
    val uart = master(Uart(ctsGen = config.uartCtrlConfig.ctsGen, rtsGen = config.uartCtrlConfig.rtsGen))
    val interrupt = out Bool()
  }

  val uartCtrl = new UartCtrl(config.uartCtrlConfig)
  io.uart <> uartCtrl.io.uart

  val busCtrl = Apb3SlaveFactory(io.apb)
  val bridge = uartCtrl.driveFrom32(busCtrl,config)
  io.interrupt := bridge.interruptCtrl.interrupt
}

//All construction parameters of the UartCtrl
case class UartCtrlGenerics( dataWidthMax: Int = 8,
                             clockDividerWidth: Int = 20, // !! baudrate = Fclk / (rxSamplePerBit*clockDividerWidth) !!
                             preSamplingSize: Int = 1,
                             samplingSize: Int = 5,
                             postSamplingSize: Int = 2,
                             ctsGen : Boolean = false,
                             rtsGen : Boolean = false) {
  val rxSamplePerBit = preSamplingSize + samplingSize + postSamplingSize
  if ((samplingSize % 2) == 0)
    SpinalWarning(s"It's not nice to have a even samplingSize value at ${ScalaLocated.short} (because of the majority vote)")
}


case class UartCtrlFrameConfig(g: UartCtrlGenerics) extends Bundle {
  val dataLength = UInt(log2Up(g.dataWidthMax) bits) //Bit count = dataLength + 1
  val stop       = UartStopType()
  val parity     = UartParityType()
}

case class UartCtrlConfig(g: UartCtrlGenerics) extends Bundle {
  val frame        = UartCtrlFrameConfig(g)
  val clockDivider = UInt (g.clockDividerWidth bit) //see UartCtrlGenerics.clockDividerWidth for calculation

  def setClockDivider(baudrate : HertzNumber,clkFrequency : HertzNumber = ClockDomain.current.frequency.getValue) : Unit = {
    clockDivider := (clkFrequency / baudrate / g.rxSamplePerBit).setScale(0, BigDecimal.RoundingMode.HALF_DOWN).toBigInt - 1
  }
}

class UartCtrlIo(g : UartCtrlGenerics) extends Bundle {
  val config = in(UartCtrlConfig(g))
  val write  = slave(Stream(Bits(g.dataWidthMax bit)))
  val read   = master(Stream(Bits(g.dataWidthMax bit)))
  val uart   = master(Uart(ctsGen = g.ctsGen, rtsGen = g.rtsGen))
  val readError = out Bool()
  val writeBreak = in Bool()
  val readBreak = out Bool()
}


class UartCtrl(g : UartCtrlGenerics = UartCtrlGenerics()) extends Component {
  val io = new UartCtrlIo(g)
  val tx = new UartCtrlTx(g)
  val rx = new UartCtrlRx(g)

  //Clock divider used by RX and TX
  val clockDivider = new Area {
    val counter = Reg(UInt(g.clockDividerWidth bits)) init(0)
    val tick = counter === 0
    val tickReg = RegNext(tick) init(False)

    counter := counter - 1
    when(tick) {
      counter := io.config.clockDivider
    }
  }

  tx.io.samplingTick := clockDivider.tickReg
  rx.io.samplingTick := clockDivider.tickReg

  tx.io.configFrame := io.config.frame
  rx.io.configFrame := io.config.frame

  tx.io.write << io.write.throwWhen(rx.io.break)
  rx.io.read >> io.read

  io.uart.txd <> tx.io.txd
  io.uart.rxd <> rx.io.rxd

  io.readError := rx.io.error
  tx.io.cts := (if(g.ctsGen) BufferCC.withTag(io.uart.cts) else False)
  if(g.rtsGen) io.uart.rts := rx.io.rts
  io.readBreak := rx.io.break
  tx.io.break := io.writeBreak


  def driveFrom(busCtrl : BusSlaveFactory,config : UartCtrlMemoryMappedConfig,baseAddress : Int = 0) = new Area {
    require(busCtrl.busDataWidth == 16 || busCtrl.busDataWidth == 32)
    val busCtrlWrapped = new BusSlaveFactoryAddressWrapper(busCtrl,baseAddress)
    //Manage config
    val uartConfigReg = Reg(io.config)
    uartConfigReg.clockDivider init(0)
    if(config.initConfig != null)config.initConfig.initReg(uartConfigReg)
    if(config.busCanWriteClockDividerConfig)
      busCtrlWrapped.writeMultiWord(uartConfigReg.clockDivider,address = 8)
    else
      uartConfigReg.clockDivider.allowUnsetRegToAvoidLatch
    if(config.busCanWriteFrameConfig){
      busCtrlWrapped.write(uartConfigReg.frame.dataLength,address = 12,bitOffset = 0)
      busCtrlWrapped.write(uartConfigReg.frame.parity,address = 12,bitOffset = 8)
      busCtrl.busDataWidth match {
        case 16 => busCtrlWrapped.write(uartConfigReg.frame.stop,address = 14,bitOffset = 0)
        case 32 => busCtrlWrapped.write(uartConfigReg.frame.stop,address = 12,bitOffset = 16)
      }
    }else{
      uartConfigReg.frame.allowUnsetRegToAvoidLatch
    }
    io.config := uartConfigReg

    def sat255 (that : UInt) = if(widthOf(that) > 8) that.min(255).resize(8 bits) else that
    //manage TX
    val write = new Area {
      val streamUnbuffered = busCtrlWrapped.createAndDriveFlow(Bits(g.dataWidthMax bits), address = 0).toStream
      val (stream, fifoOccupancy) = streamUnbuffered.queueWithOccupancy(config.txFifoDepth)
      io.write << stream
      busCtrl.busDataWidth match {
        case 16 => busCtrlWrapped.read(sat255(config.txFifoDepth - fifoOccupancy),address = 6,bitOffset = 0)
        case 32 => busCtrlWrapped.read(sat255(config.txFifoDepth - fifoOccupancy),address = 4,bitOffset = 16)
      }

      streamUnbuffered.ready.allowPruning()

      busCtrlWrapped.read(stream.valid, address = 4, 15)
    }

    //manage RX
    val read = new Area {
      val (stream, fifoOccupancy) = io.read.queueWithOccupancy(config.rxFifoDepth)
      val streamBreaked = stream.throwWhen(io.readBreak)
      busCtrl.busDataWidth match {
        case 16 =>
          busCtrlWrapped.readStreamNonBlocking(streamBreaked, address = 0, validBitOffset = 15, payloadBitOffset = 0)
          busCtrlWrapped.read(sat255(fifoOccupancy),address = 6, 8)
        case 32 =>
          busCtrlWrapped.readStreamNonBlocking(streamBreaked, address = 0, validBitOffset = 16, payloadBitOffset = 0)
          busCtrlWrapped.read(sat255(fifoOccupancy),address = 4, 24)
      }
      def genCTS(freeThreshold : Int) = RegNext(fifoOccupancy <= config.rxFifoDepth - freeThreshold) init(False)  // freeThreshold => how many remaining space should be in the fifo before allowing transfer
    }

    //manage interrupts
    val interruptCtrl = new Area {
      val writeIntEnable = busCtrlWrapped.createReadAndWrite(Bool(), address = 4, 0) init(False)
      val readIntEnable  = busCtrlWrapped.createReadAndWrite(Bool(), address = 4, 1) init(False)
      val readInt   = readIntEnable  &  read.streamBreaked.valid
      val writeInt  = writeIntEnable & !write.stream.valid
      val interrupt = readInt || writeInt
      busCtrlWrapped.read(writeInt, address = 4, 8)
      busCtrlWrapped.read(readInt , address = 4, 9)
    }

    val misc = new Area{
      val readError = busCtrlWrapped.createReadAndClearOnSet(Bool(), 0x10, 0) init(False) setWhen(io.readError)
      val readOverflowError = busCtrlWrapped.createReadAndClearOnSet(Bool(), 0x10, 1) init(False) setWhen(io.read.isStall)
      busCtrlWrapped.read(io.readBreak, 0x10, 8)
      val breakDetected = RegInit(False) setWhen(io.readBreak.rise())
      busCtrlWrapped.read(breakDetected, 0x10, 9)
      busCtrlWrapped.clearOnSet(breakDetected, 0x10, 9)
      val doBreak = RegInit(False)
      busCtrlWrapped.setOnSet(doBreak, 0x10, 10)
      busCtrlWrapped.clearOnSet(doBreak, 0x10, 11)
      io.writeBreak := doBreak
    }
  }

  //Legacy wrappers
  def driveFrom16(busCtrl : BusSlaveFactory,config : UartCtrlMemoryMappedConfig,baseAddress : Int = 0) = {
    require(busCtrl.busDataWidth == 16)
    driveFrom(busCtrl,config,baseAddress)
  }
  //Legacy wrappers
  def driveFrom32(busCtrl : BusSlaveFactory,config : UartCtrlMemoryMappedConfig,baseAddress : Int = 0) = {
    require(busCtrl.busDataWidth == 32)
    driveFrom(busCtrl,config,baseAddress)
  }
}

object UartCtrl {
  def apply(config: UartCtrlInitConfig, readonly: Boolean = false): UartCtrl = {
    val uartCtrl = new UartCtrl()
    uartCtrl.io.config.setClockDivider(config.baudrate Hz)
    uartCtrl.io.config.frame.dataLength := config.dataLength  //8 bits
    uartCtrl.io.config.frame.parity := config.parity
    uartCtrl.io.config.frame.stop := config.stop
    uartCtrl.io.writeBreak := False
    if (readonly) {
      uartCtrl.io.write.valid := False
      uartCtrl.io.write.payload := B(0)
    }
    uartCtrl
  }
}

case class UartCtrlInitConfig(
  var baudrate : Int = 0,
  var dataLength : Int = 0,
  var parity : UartParityType.E = null,
  var stop : UartStopType.E = null
){
  def initReg(reg : UartCtrlConfig): Unit ={
    require(reg.isReg)
    if(baudrate != 0) reg.clockDivider init((ClockDomain.current.frequency.getValue / baudrate / reg.g.rxSamplePerBit).toInt-1)
    if(dataLength != 0) reg.frame.dataLength init(dataLength)
    if(parity != null) reg.frame.parity init(parity)
    if(stop != null) reg.frame.stop init(stop)
  }
}

object UartCtrlMemoryMappedConfig{
  def apply(baudrate: Int,
            txFifoDepth: Int,
            rxFifoDepth: Int,
            writeableConfig : Boolean,
            clockDividerWidth : Int) : UartCtrlMemoryMappedConfig = UartCtrlMemoryMappedConfig(
    uartCtrlConfig = UartCtrlGenerics(
      dataWidthMax = 8,
      clockDividerWidth = clockDividerWidth,
      preSamplingSize = 1,
      samplingSize = 3,
      postSamplingSize = 1
    ),
    initConfig = UartCtrlInitConfig(
      baudrate = baudrate,
      dataLength = 7, //7 => 8 bits
      parity = UartParityType.NONE,
      stop = UartStopType.ONE
    ),
    busCanWriteClockDividerConfig = writeableConfig,
    busCanWriteFrameConfig = writeableConfig,
    txFifoDepth = txFifoDepth,
    rxFifoDepth = rxFifoDepth
  )

  def apply(baudrate: Int,
            txFifoDepth: Int,
            rxFifoDepth: Int) : UartCtrlMemoryMappedConfig = apply(
    baudrate = baudrate,
    txFifoDepth = txFifoDepth,
    rxFifoDepth = rxFifoDepth,
    writeableConfig = false,
    clockDividerWidth = 12
  )
}

case class UartCtrlMemoryMappedConfig(
  uartCtrlConfig : UartCtrlGenerics,
  initConfig : UartCtrlInitConfig = null,
  busCanWriteClockDividerConfig : Boolean = true,
  busCanWriteFrameConfig : Boolean = true,
  txFifoDepth : Int = 32,
  rxFifoDepth : Int = 32
){
  require(txFifoDepth >= 1)
  require(rxFifoDepth >= 1)
}

// UART RX
object UartCtrlRxState extends SpinalEnum {
  val IDLE, START, DATA, PARITY, STOP = newElement()
}
class UartCtrlRx(g : UartCtrlGenerics) extends Component {
  import g._
  val io = new Bundle {
    val configFrame  = in(UartCtrlFrameConfig(g))
    val samplingTick = in Bool()
    val read         = master Stream (Bits(dataWidthMax bit))
    val rxd          = in Bool()
    val rts   = out Bool()
    val error = out Bool()
    val break = out Bool()
  }

  io.error := False
  io.rts := RegNext(!io.read.ready) init(False)

  // Implement the rxd sampling with a majority vote over samplingSize bits
  // Provide a new sampler.value each time sampler.tick is high
  val sampler = new Area {
    val synchroniser = BufferCC.withTag(io.rxd,init=False)
    val samples      = History(that=synchroniser,length=samplingSize,when=io.samplingTick,init=True)
    val value        = RegNext(MajorityVote(samples)) init(True)
    val tick         = RegNext(io.samplingTick) init(False)
  }

  // Provide a bitTimer.tick each rxSamplePerBit
  // reset() can be called to recenter the counter over a start bit.
  val bitTimer = new Area {
    val counter = Reg(UInt(log2Up(rxSamplePerBit) bit))
    def reset() = counter := preSamplingSize + (samplingSize - 1) / 2 - 1
    val tick = False
    when(sampler.tick) {
      counter := counter - 1
      when(counter === 0) {
        tick := True
        if(!isPow2(rxSamplePerBit))
          counter := rxSamplePerBit-1
      }
    }
  }

  // Provide bitCounter.value that count up each bitTimer.tick, Used by the state machine to count data bits and stop bits
  // reset() can be called to reset it to zero
  val bitCounter = new Area {
    val value = Reg(UInt(Math.max(log2Up(dataWidthMax), 2) bit))
    def reset() = value := 0

    when(bitTimer.tick) {
      value := value + 1
    }
  }

  val break = new Area{
    val stateCount = g.rxSamplePerBit*(1+8+1+2+1)
    val counter = Reg(UInt(log2Up(stateCount+1) bits)) init(0)
    val valid = counter === stateCount
    when(sampler.value){
      counter := 0
    } otherwise {
      when(io.samplingTick && !valid) {
        counter := counter + 1
      }
    }
  }

  io.break := break.valid

  val stateMachine = new Area {
    import UartCtrlRxState._

    val state   = RegInit(IDLE)
    val parity  = Reg(Bool())
    val shifter = Reg(io.read.payload)
    val validReg = RegNext(False) init(False)
    io.read.valid := validReg

    //Parity calculation
    when(bitTimer.tick) {
      parity := parity ^ sampler.value
    }

    switch(state) {
      is(IDLE) {
        when(sampler.tick && !sampler.value && !break.valid) {
          state := START
          bitTimer.reset()
        }
      }
      is(START) {
        when(bitTimer.tick) {
          state := DATA
          bitCounter.reset()
          parity := io.configFrame.parity === UartParityType.ODD
          when(sampler.value === True) {
            state := IDLE
          }
        }
      }
      is(DATA) {
        when(bitTimer.tick) {
          shifter(bitCounter.value) := sampler.value
          when(bitCounter.value === io.configFrame.dataLength) {
            bitCounter.reset()
            when(io.configFrame.parity === UartParityType.NONE) {
              state := STOP
              validReg := True
            } otherwise {
              state := PARITY
            }
          }
        }
      }
      is(PARITY) {
        when(bitTimer.tick) {
          bitCounter.reset()
          when(parity === sampler.value) {
            state := STOP
            validReg := True
          } otherwise {
            state := IDLE
            io.error := True
          }
        }
      }
      is(STOP) {
        when(bitTimer.tick) {
          when(!sampler.value) {
            io.error := True
            state := IDLE
          }elsewhen(bitCounter.value === UartStopType.toBitCount(io.configFrame.stop)) {
            state := IDLE
          }
        }
      }
    }
  }
  io.read.payload := stateMachine.shifter
}

// UART TX
object UartCtrlTxState extends SpinalEnum {
  val IDLE, START, DATA, PARITY, STOP = newElement()
}
class UartCtrlTx(g : UartCtrlGenerics) extends Component {
  import g._

  val io = new Bundle {
    val configFrame = in(UartCtrlFrameConfig(g))
    val samplingTick = in Bool()
    val write = slave Stream (Bits(dataWidthMax bit))
    val cts = in Bool()
    val txd = out Bool()
    val break = in Bool()
  }

  // Provide one clockDivider.tick each rxSamplePerBit pulse of io.samplingTick
  // Used by the stateMachine as a baud rate time reference
  val clockDivider = new Area {
    val counter = Counter(rxSamplePerBit)
    val tick = counter.willOverflow
    when(io.samplingTick) {
      counter.increment()
    }
  }

  // Count up each clockDivider.tick, used by the state machine to count up data bits and stop bits
  val tickCounter = new Area {
    val value = Reg(UInt(Math.max(log2Up(dataWidthMax), 2) bit))
    def reset() = value := 0

    when(clockDivider.tick) {
      value := value + 1
    }
  }

  val stateMachine = new Area {
    import UartCtrlTxState._

    val state = RegInit(IDLE)
    val parity = Reg(Bool())
    val txd = True

    when(clockDivider.tick) {
      parity := parity ^ txd
    }

    io.write.ready := io.break
    switch(state) {
      is(IDLE){
        when(io.write.valid && !io.cts && clockDivider.tick){
          state := START
        }
      }
      is(START) {
        txd := False
        when(clockDivider.tick) {
          state := DATA
          parity := io.configFrame.parity === UartParityType.ODD
          tickCounter.reset()
        }
      }
      is(DATA) {
        txd := io.write.payload(tickCounter.value)
        when(clockDivider.tick) {
          when(tickCounter.value === io.configFrame.dataLength) {
            io.write.ready := True
            tickCounter.reset()
            when(io.configFrame.parity === UartParityType.NONE) {
              state := STOP
            } otherwise {
              state := PARITY
            }
          }
        }
      }
      is(PARITY) {
        txd := parity
        when(clockDivider.tick) {
          state := STOP
          tickCounter.reset()
        }
      }
      is(STOP) {
        when(clockDivider.tick) {
          when(tickCounter.value === UartStopType.toBitCount(io.configFrame.stop)) {
            state := io.write.valid ? START | IDLE
          }
        }
      }
    }
  }

  io.txd := RegNext(stateMachine.txd && !io.break) init(True)
}


object Apb3UartGen{
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
      dataLength = 7, //7 => 8 bits
      parity = UartParityType.NONE,
      stop = UartStopType.ONE
    ),
    txFifoDepth = 16,
    rxFifoDepth = 16
  )
  def main(args: Array[String]) {
    SpinalConfig(
      mode = Verilog,
      targetDirectory = "rtl",
      defaultClockDomainFrequency=FixedFrequency(50 MHz)
    ).generate(new Apb3Uart(uartCtrlConfig))
  }
}
