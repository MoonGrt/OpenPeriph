package periph.exti

import chisel3._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbExti(extiWidth: Int = 16, addressWidth: Int = 5, dataWidth: Int = 32)
    extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val exti = Input(UInt(extiWidth.W))
    val interrupt = Output(UInt(extiWidth.W))
  })
  ApbPeripheral.defaults(io.apb)
  val imr = RegInit(0.U(extiWidth.W))
  val emr = RegInit(0.U(extiWidth.W))
  val rtsr = RegInit(0.U(extiWidth.W))
  val ftsr = RegInit(0.U(extiWidth.W))
  val swier = RegInit(0.U(extiWidth.W))
  val pending = RegInit(0.U(extiWidth.W))
  val extiReg = RegNext(io.exti, 0.U)

  when(ApbPeripheral.write(io.apb, 0x00)) { imr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x04)) { emr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x08)) { rtsr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x0c)) { ftsr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x10)) { swier := swier | io.apb.pwdata }
  val edgeTriggered = (io.exti & ~extiReg & rtsr) | (~io.exti & extiReg & ftsr)
  pending := pending | edgeTriggered
  when(ApbPeripheral.write(io.apb, 0x14)) { pending := pending & ~io.apb.pwdata }

  ApbPeripheral.readMux(io.apb, Seq(
    0x00 -> imr, 0x04 -> emr, 0x08 -> rtsr, 0x0c -> ftsr,
    0x10 -> swier, 0x14 -> pending
  ))
  io.interrupt := pending & imr
}
