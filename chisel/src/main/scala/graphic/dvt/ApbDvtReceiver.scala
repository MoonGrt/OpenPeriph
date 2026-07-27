package graphic.dvt

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbDvtReceiver(addressWidth: Int = 12, dataWidth: Int = 32, colorWidth: Int = 8)
    extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val dvt = Input(new DvtIO(colorWidth))
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val control = RegInit(0.U(32.W))
  val status = Wire(UInt(32.W))
  val rawInterrupt = RegInit(0.U(32.W))
  val interruptEnable = RegInit(0.U(32.W))
  val embeddedSyncCode = RegInit(0.U(32.W))
  val embeddedSyncUnmask = RegInit(0.U(32.W))
  val cropStart = RegInit(0.U(32.W))
  val cropSize = RegInit(0.U(32.W))
  val data = RegInit(0.U(32.W))
  val horizontal = RegInit(0.U(16.W))
  val vertical = RegInit(0.U(16.W))
  val previousHs = RegNext(io.dvt.hs, false.B)
  val previousVs = RegNext(io.dvt.vs, false.B)
  val previousPixelClock = previousHs
  val hsEvent = Mux(control(4), io.dvt.hs && !previousHs, !io.dvt.hs && previousHs)
  val vsEvent = Mux(control(5), io.dvt.vs && !previousVs, !io.dvt.vs && previousVs)
  val pixelEvent = Mux(control(3), io.dvt.hs && !previousPixelClock, !io.dvt.hs && previousPixelClock)
  val cropX = cropStart(15, 0); val cropY = cropStart(31, 16)
  val cropWidth = cropSize(15, 0); val cropHeight = cropSize(31, 16)
  val inCrop = !control(2) || (horizontal >= cropX && horizontal < cropX + cropWidth &&
    vertical >= cropY && vertical < cropY + cropHeight)

  when(vsEvent) { horizontal := 0.U; vertical := 0.U; rawInterrupt := rawInterrupt | 2.U }
  when(hsEvent) { horizontal := 0.U; vertical := vertical + 1.U; rawInterrupt := rawInterrupt | 4.U }
  when(pixelEvent && control(0)) {
    horizontal := horizontal + 1.U
    when(inCrop) { data := io.dvt.data; rawInterrupt := rawInterrupt | 1.U }
  }
  when(control(1) && vsEvent) { control := control.bitSet(0.U, false.B) }

  when(ApbPeripheral.write(io.apb, 0x00)) { control := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x0c)) { interruptEnable := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x14)) { rawInterrupt := rawInterrupt & ~io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x18)) { embeddedSyncCode := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x1c)) { embeddedSyncUnmask := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x20)) { cropStart := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x24)) { cropSize := io.apb.pwdata }
  status := Cat(0.U(28.W), inCrop, io.dvt.hs, io.dvt.vs, control(0))
  val maskedInterrupt = rawInterrupt & interruptEnable
  ApbPeripheral.readMux(io.apb, Seq(
    0x00 -> control, 0x04 -> status, 0x08 -> rawInterrupt,
    0x0c -> interruptEnable, 0x10 -> maskedInterrupt,
    0x18 -> embeddedSyncCode, 0x1c -> embeddedSyncUnmask,
    0x20 -> cropStart, 0x24 -> cropSize, 0x28 -> data
  ))
  io.interrupt := maskedInterrupt.orR
}
