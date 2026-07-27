package graphic.dvt

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbDvtTransmitter(addressWidth: Int = 10, dataWidth: Int = 32, colorWidth: Int = 16)
    extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val dvt = Output(new DvtIO(colorWidth))
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)

  val synchronization = RegInit(0.U(32.W))
  val backPorch = RegInit(0.U(32.W))
  val activeWidth = RegInit(0.U(32.W))
  val totalWidth = RegInit(0.U(32.W))
  val globalControl = RegInit(0.U(32.W))
  val shadowReload = RegInit(0.U(32.W))
  val backgroundColor = RegInit(0.U(32.W))
  val interruptEnable = RegInit(0.U(32.W))
  val interruptStatus = RegInit(0.U(32.W))
  val lineInterruptPosition = RegInit(0.U(32.W))
  val testPatternControl = RegInit(0.U(32.W))
  val testPatternSolidColor = RegInit(0.U(32.W))
  val horizontal = RegInit(0.U(12.W))
  val vertical = RegInit(0.U(12.W))

  val readWriteRegisters = Seq(
    0x08 -> synchronization, 0x0c -> backPorch, 0x10 -> activeWidth,
    0x14 -> totalWidth, 0x18 -> globalControl, 0x24 -> shadowReload,
    0x2c -> backgroundColor, 0x34 -> interruptEnable,
    0x40 -> lineInterruptPosition, 0x4c -> testPatternControl,
    0x50 -> testPatternSolidColor
  )
  for ((address, register) <- readWriteRegisters) {
    when(ApbPeripheral.write(io.apb, address)) { register := io.apb.pwdata }
  }
  when(ApbPeripheral.write(io.apb, 0x3c)) {
    interruptStatus := interruptStatus & ~io.apb.pwdata
  }

  val enabled = globalControl(0)
  when(enabled) {
    when(horizontal === totalWidth(27, 16)) {
      horizontal := 0.U
      vertical := Mux(vertical === totalWidth(11, 0), 0.U, vertical + 1.U)
    }.otherwise { horizontal := horizontal + 1.U }
  }.otherwise { horizontal := 0.U; vertical := 0.U }

  val horizontalActive = horizontal >= backPorch(27, 16) && horizontal < activeWidth(27, 16)
  val verticalActive = vertical >= backPorch(11, 0) && vertical < activeWidth(11, 0)
  val displayEnable = horizontalActive && verticalActive
  io.dvt.hs := ((horizontal <= synchronization(27, 16)) ^ globalControl(31)) && enabled
  io.dvt.vs := ((vertical <= synchronization(11, 0)) ^ globalControl(30)) && enabled
  io.dvt.de := (displayEnable ^ globalControl(29)) && enabled

  val x = horizontal - backPorch(27, 16)
  val width = activeWidth(27, 16) - backPorch(27, 16)
  val barIndex = WireDefault(7.U(3.W))
  for (index <- 6 to 0 by -1) {
    when((x << 3) < width * (index + 1).U) { barIndex := index.U }
  }
  val bars = VecInit(Seq("h0000".U, "hf800".U, "h07e0".U, "h001f".U,
    "hffe0".U, "hf81f".U, "h07ff".U, "hffff".U))
  val testPixel = Mux(testPatternControl(2, 1) === 3.U,
    testPatternSolidColor(colorWidth - 1, 0), bars(barIndex))
  io.dvt.data := Mux(displayEnable,
    Mux(testPatternControl(0), testPixel, backgroundColor(colorWidth - 1, 0)), 0.U)

  val previousHs = RegNext(io.dvt.hs, false.B)
  val lineMatch = vertical === lineInterruptPosition(11, 0) && io.dvt.hs && !previousHs
  when(lineMatch && interruptEnable(0)) { interruptStatus := interruptStatus | 1.U }
  val currentPosition = Cat(horizontal, 0.U(4.W), vertical)
  val displayStatus = Cat(0.U(28.W), io.dvt.vs, io.dvt.hs, horizontalActive, verticalActive)
  ApbPeripheral.readMux(io.apb, readWriteRegisters ++ Seq(
    0x38 -> interruptStatus, 0x44 -> currentPosition, 0x48 -> displayStatus
  ))
  io.interrupt := (interruptStatus & interruptEnable).orR
}
