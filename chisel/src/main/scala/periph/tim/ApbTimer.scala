package periph.tim

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbTimer(addressWidth: Int = 7, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val ch = Output(UInt(4.W))
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)

  val regs = RegInit(VecInit(Seq.fill(20)(0.U(16.W))))
  val cr1 = regs(0); val cr2 = regs(1); val dier = regs(3); val sr = regs(4)
  val egr = regs(5); val ccer = regs(8); val cnt = regs(9); val psc = regs(10)
  val arr = RegInit("hffff".U(16.W))
  val ccr = regs.slice(13, 17)
  val prescaler = RegInit(0.U(16.W))

  val addresses = Seq(0x00, 0x04, 0x08, 0x0c, 0x10, 0x14, 0x18, 0x1c,
    0x20, 0x24, 0x28, 0x2c, 0x30, 0x34, 0x38, 0x3c, 0x40, 0x44, 0x48, 0x4c)
  for ((address, index) <- addresses.zipWithIndex if address != 0x24 && address != 0x2c) {
    when(ApbPeripheral.write(io.apb, address)) { regs(index) := io.apb.pwdata(15, 0) }
  }
  when(ApbPeripheral.write(io.apb, 0x2c)) { arr := io.apb.pwdata(15, 0) }

  when(cr1(0)) {
    prescaler := prescaler + 1.U
    when(prescaler === psc) {
      prescaler := 0.U
      when(!cr1(4)) {
        cnt := cnt + 1.U
        when(cnt === arr) { cnt := 0.U; sr := sr.bitSet(0.U, true.B) }
      }.otherwise {
        cnt := cnt - 1.U
        when(cnt === 0.U) { cnt := arr; sr := sr.bitSet(0.U, true.B) }
      }
    }
  }
  when(egr(0)) { cnt := 0.U }
  when(egr(0) || egr(1) || egr(2) || egr(3) || egr(4) || egr(6)) { egr := 0.U }

  val readEntries = addresses.zipWithIndex.map { case (address, index) =>
    address -> (if (address == 0x2c) arr else regs(index))
  }
  ApbPeripheral.readMux(io.apb, readEntries)
  io.ch := VecInit((0 until 4).map(i => ccer(i) && cnt < ccr(i))).asUInt
  io.interrupt := sr(0) && dier(0)
}
