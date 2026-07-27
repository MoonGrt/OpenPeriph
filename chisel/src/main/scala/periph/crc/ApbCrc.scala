package periph.crc

import chisel3._
import chisel3.util.Cat
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbCrc(addressWidth: Int = 5, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val crc = RegInit("hffffffff".U(32.W))
  val idr = RegInit(0.U(8.W))

  private def update(initial: UInt, data: UInt): UInt = {
    var value = initial
    for (bit <- 31 to 0 by -1) {
      val feedback = value(31) ^ data(bit)
      value = Cat(value(30, 0), 0.U(1.W)) ^ Mux(feedback, "h04c11db7".U, 0.U)
    }
    value
  }

  when(ApbPeripheral.write(io.apb, 0x00)) { crc := update(crc, io.apb.pwdata) }
  when(ApbPeripheral.write(io.apb, 0x04)) { idr := io.apb.pwdata(7, 0) }
  when(ApbPeripheral.write(io.apb, 0x08) && io.apb.pwdata(0)) { crc := "hffffffff".U }
  ApbPeripheral.readMux(io.apb, Seq(0x00 -> crc, 0x04 -> idr, 0x08 -> 0.U))
  io.interrupt := false.B
}
