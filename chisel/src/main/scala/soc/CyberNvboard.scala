package soc

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline
import _root_.circt.stage.ChiselStage
import core.OpenPeriphRocketConfig
import graphic.base.{ColorConvert, RgbConfig}
import graphic.lcd.Axi4Lcd
import org.chipsalliance.diplomacy.lazymodule.LazyModule
import periph.afio.ApbAfio
import periph.can.ApbCan
import periph.crc.ApbCrc
import periph.exti.ApbExti
import periph.gpio.ApbGpio
import periph.i2c.ApbI2c
import periph.sdio.ApbSdio
import periph.spi.ApbSpi
import periph.systick.ApbSysTick
import periph.tim.ApbTimer
import periph.uart.ApbUart
import periph.wdg.{ApbIndependentWatchdog, ApbWindowWatchdog}
import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}

class CyberNvboard(memWords: Int = 16384, firmware: String = "../../software/rthtread/build/demo.mem32")
    extends RawModule {
  val clk = IO(Input(Clock()))
  val rst = IO(Input(Bool()))
  val uart_tx = IO(Output(Bool())); val uart_rx = IO(Input(Bool()))
  val seg = IO(Output(UInt(8.W))); val led = IO(Output(UInt(8.W)))
  val rgbled = IO(Output(UInt(6.W))); val sw = IO(Input(UInt(8.W)))
  val vga_vs = IO(Output(Bool())); val vga_hs = IO(Output(Bool()))
  val vga_de = IO(Output(Bool())); val vga_data = IO(Output(UInt(24.W)))
  val lcdclk = IO(Output(Bool()))
  lcdclk := clk.asBool

  val resetCounter = withClockAndReset(clk, rst) { RegInit(0.U(6.W)) }
  withClockAndReset(clk, rst) {
    when(!resetCounter.andR) { resetCounter := resetCounter + 1.U }
  }
  val systemReset = rst || !resetCounter.andR

  implicit val rocketParameters: OpenPeriphRocketConfig = new OpenPeriphRocketConfig
  val rocketSystem = LazyModule(new freechips.rocketchip.system.ExampleRocketSystem)
  val rocket = Module(rocketSystem.module)
  rocketSystem.io_clocks.get.elements.values.foreach { domain =>
    domain.clock := clk
    domain.reset := systemReset
  }
  rocket.reset_vector.foreach(_ := 0x80000000L.U)
  rocket.interrupts := 0.U

  withClockAndReset(clk, systemReset) {
    val memory = Mem(memWords, Vec(4, UInt(8.W)))
    loadMemoryFromFileInline(memory, firmware)
    def memoryIndex(address: UInt): UInt = address(log2Ceil(memWords) + 1, 2)

    val memAxi = rocketSystem.mem_axi4.head
    val readActive = RegInit(false.B)
    val readAddress = Reg(UInt(32.W))
    val readId = Reg(UInt(memAxi.ar.bits.id.getWidth.W))
    val readBeats = Reg(UInt(9.W))
    memAxi.ar.ready := !readActive
    when(memAxi.ar.fire) {
      readActive := true.B
      readAddress := memAxi.ar.bits.addr
      readId := memAxi.ar.bits.id
      readBeats := memAxi.ar.bits.len + 1.U
    }
    val readLow = memory(memoryIndex(readAddress)).asUInt
    val readHigh = memory(memoryIndex(readAddress) + 1.U).asUInt
    memAxi.r.valid := readActive
    memAxi.r.bits := 0.U.asTypeOf(memAxi.r.bits)
    memAxi.r.bits.id := readId
    memAxi.r.bits.data := Cat(readHigh, readLow)
    memAxi.r.bits.resp := 0.U
    memAxi.r.bits.last := readBeats === 1.U
    when(memAxi.r.fire) {
      readAddress := readAddress + 8.U
      readBeats := readBeats - 1.U
      when(readBeats === 1.U) { readActive := false.B }
    }

    val writeActive = RegInit(false.B)
    val writeAddress = Reg(UInt(32.W))
    val writeId = Reg(UInt(memAxi.aw.bits.id.getWidth.W))
    val writeResponse = RegInit(false.B)
    memAxi.aw.ready := !writeActive && !writeResponse
    when(memAxi.aw.fire) {
      writeActive := true.B
      writeAddress := memAxi.aw.bits.addr
      writeId := memAxi.aw.bits.id
    }
    memAxi.w.ready := writeActive && !writeResponse
    val lowBytes = Wire(Vec(4, UInt(8.W)))
    val highBytes = Wire(Vec(4, UInt(8.W)))
    val lowMask = Wire(Vec(4, Bool()))
    val highMask = Wire(Vec(4, Bool()))
    for (i <- 0 until 4) {
      lowBytes(i) := memAxi.w.bits.data(8 * i + 7, 8 * i)
      highBytes(i) := memAxi.w.bits.data(8 * (i + 4) + 7, 8 * (i + 4))
      lowMask(i) := memAxi.w.bits.strb(i)
      highMask(i) := memAxi.w.bits.strb(i + 4)
    }
    when(memAxi.w.fire) {
      memory.write(memoryIndex(writeAddress), lowBytes, lowMask)
      memory.write(memoryIndex(writeAddress) + 1.U, highBytes, highMask)
      writeAddress := writeAddress + 8.U
      when(memAxi.w.bits.last) {
        writeActive := false.B
        writeResponse := true.B
      }
    }
    memAxi.b.valid := writeResponse
    memAxi.b.bits := 0.U.asTypeOf(memAxi.b.bits)
    memAxi.b.bits.id := writeId
    memAxi.b.bits.resp := 0.U
    when(memAxi.b.fire) { writeResponse := false.B }

    val gpioA = Module(new ApbGpio()); val gpioB = Module(new ApbGpio())
    val uart = Module(new ApbUart()); val timer = Module(new ApbTimer())
    val systick = Module(new ApbSysTick()); val lcd = Module(new Axi4Lcd())
    val afio = Module(new ApbAfio(gpioGroupCount = 2)); val exti = Module(new ApbExti())
    val iwdg = Module(new ApbIndependentWatchdog()); val wwdg = Module(new ApbWindowWatchdog())
    val i2c = Module(new ApbI2c()); val spi = Module(new ApbSpi())
    val can = Module(new ApbCan()); val sdio = Module(new ApbSdio()); val crc = Module(new ApbCrc())
    val slaves = Seq(gpioA.io.apb, gpioB.io.apb, uart.io.apb, i2c.io.apb, spi.io.apb,
      timer.io.apb, systick.io.apb, lcd.io.apb, can.io.apb, sdio.io.apb, crc.io.apb,
      afio.io.apb, exti.io.apb, iwdg.io.apb, wwdg.io.apb)

    val mmio = rocketSystem.mmio_axi4.head
    val idle :: setup :: access :: readResponse :: writeResponseState :: Nil = Enum(5)
    val state = RegInit(idle)
    val address = Reg(UInt(32.W)); val writeData = Reg(UInt(32.W)); val writeMask = Reg(UInt(4.W))
    val responseData = RegInit(0.U(32.W)); val responseError = RegInit(false.B)
    val responseId = Reg(UInt(mmio.ar.bits.id.getWidth.W))
    val awHeld = RegInit(false.B); val awAddress = Reg(UInt(32.W)); val awId = Reg(UInt(responseId.getWidth.W))
    val wHeld = RegInit(false.B); val wData = Reg(UInt(64.W)); val wStrb = Reg(UInt(8.W))

    mmio.aw.ready := !awHeld && state === idle
    mmio.w.ready := !wHeld && state === idle
    mmio.ar.ready := state === idle && !awHeld && !wHeld
    when(mmio.aw.fire) { awHeld := true.B; awAddress := mmio.aw.bits.addr; awId := mmio.aw.bits.id }
    when(mmio.w.fire) { wHeld := true.B; wData := mmio.w.bits.data; wStrb := mmio.w.bits.strb }
    when(state === idle && awHeld && wHeld) {
      address := awAddress
      responseId := awId
      writeData := Mux(awAddress(2), wData(63, 32), wData(31, 0))
      writeMask := Mux(awAddress(2), wStrb(7, 4), wStrb(3, 0))
      awHeld := false.B; wHeld := false.B; state := setup
    }.elsewhen(state === idle && mmio.ar.fire) {
      address := mmio.ar.bits.addr
      responseId := mmio.ar.bits.id
      writeData := 0.U; writeMask := 0.U; state := setup
    }

    val isWrite = RegInit(false.B)
    when(state === idle && awHeld && wHeld) { isWrite := true.B }
    when(state === idle && mmio.ar.fire) { isWrite := false.B }
    val region = address(19, 16)
    val gpioGroup = address(15, 12)
    val selections = Seq(
      region === 0.U && gpioGroup === 0.U,
      region === 0.U && gpioGroup === 1.U,
      region === 1.U,
      region === 2.U,
      region === 3.U,
      region === 4.U,
      region === 6.U,
      region === 7.U,
      region === 9.U,
      region === 10.U,
      region === 11.U,
      region === 13.U,
      region === 14.U,
      region === 5.U && !address(10),
      region === 5.U && address(10)
    )
    for ((slave, selected) <- slaves.zip(selections)) {
      slave.psel := (state === setup || state === access) && selected
      slave.penable := state === access
      slave.pwrite := isWrite
      slave.paddr := address(slave.params.addrBits - 1, 0)
      slave.pprot := 0.U
      slave.pwdata := writeData
      slave.pstrb := writeMask
      slave.pauser := DontCare
    }
    val anySelected = selections.reduce(_ || _)
    val selectedReady = Mux1H(selections, slaves.map(_.pready))
    val selectedData = Mux1H(selections, slaves.map(_.prdata))
    val selectedError = Mux1H(selections, slaves.map(_.pslverr))
    when(state === setup) { state := access }
    when(state === access && (selectedReady || !anySelected)) {
      responseData := Mux(anySelected, selectedData, 0.U)
      responseError := Mux(anySelected, selectedError, true.B)
      state := Mux(isWrite, writeResponseState, readResponse)
    }
    mmio.r.valid := state === readResponse
    mmio.r.bits := 0.U.asTypeOf(mmio.r.bits)
    mmio.r.bits.id := responseId
    mmio.r.bits.data := Mux(address(2), Cat(responseData, 0.U(32.W)), Cat(0.U(32.W), responseData))
    mmio.r.bits.resp := Mux(responseError, 2.U, 0.U)
    mmio.r.bits.last := true.B
    when(mmio.r.fire) { state := idle; responseError := false.B }
    mmio.b.valid := state === writeResponseState
    mmio.b.bits := 0.U.asTypeOf(mmio.b.bits)
    mmio.b.bits.id := responseId
    mmio.b.bits.resp := Mux(responseError, 2.U, 0.U)
    when(mmio.b.fire) { state := idle; responseError := false.B }

    gpioA.io.gpio.read := Cat(0.U(8.W), sw)
    gpioB.io.gpio.read := 0.U
    gpioA.io.afio := 0.U; gpioB.io.afio := 0.U
    afio.io.device.read := 0.U; afio.io.afio.read := Cat(gpioB.io.gpio.read, gpioA.io.gpio.read)
    exti.io.exti := afio.io.afioExti
    uart.io.rxd := uart_rx
    i2c.io.sdaRead := true.B
    spi.io.miso := true.B
    can.io.rx := true.B
    sdio.io.cmdRead := true.B
    sdio.io.dataRead := "hf".U
    uart_tx := uart.io.txd
    led := gpioA.io.gpio.write(7, 0)
    seg := gpioB.io.gpio.write(15, 8)
    rgbled := gpioB.io.gpio.write(5, 0)
    vga_vs := lcd.io.dvt.vs; vga_hs := lcd.io.dvt.hs; vga_de := lcd.io.dvt.de
    vga_data := ColorConvert.rgb(lcd.io.dvt.data, RgbConfig(5, 6, 5), RgbConfig(8, 8, 8))
  }
}

object CyberNvboard extends App {
  val firtoolOptions = Array("--lowering-options=disallowLocalVariables,disallowPackedArrays")
  ChiselStage.emitSystemVerilogFile(new CyberNvboard(), args, firtoolOptions)
  val targetDir = args.sliding(2).collectFirst {
    case Array("--target-dir", directory) => directory
  }.getOrElse(".")
  val output = Paths.get(targetDir, "CyberNvboard.sv")
  val text = Files.readString(output, StandardCharsets.UTF_8)
  val marker = "// ----- 8< ----- FILE \"firrtl_black_box_resource_files.f\""
  val markerIndex = text.indexOf(marker)
  if (markerIndex >= 0) {
    Files.writeString(output, text.substring(0, markerIndex), StandardCharsets.UTF_8)
  }
}
