package periph.uart

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbUart(addressWidth: Int = 12, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val txd = Output(Bool())
    val rxd = Input(Bool())
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val brr = RegInit(0.U(16.W))
  val cr1 = RegInit(0.U(16.W)); val cr2 = RegInit(0.U(16.W)); val cr3 = RegInit(0.U(16.W))
  val gtpr = RegInit(0.U(16.W))
  val fifo = Module(new Queue(UInt(8.W), 16))
  fifo.io.enq.valid := ApbPeripheral.write(io.apb, 0x04)
  fifo.io.enq.bits := io.apb.pwdata(7, 0)

  when(ApbPeripheral.write(io.apb, 0x08)) { brr := io.apb.pwdata(15, 0) }
  when(ApbPeripheral.write(io.apb, 0x0c)) { cr1 := io.apb.pwdata(15, 0) }
  when(ApbPeripheral.write(io.apb, 0x10)) { cr2 := io.apb.pwdata(15, 0) }
  when(ApbPeripheral.write(io.apb, 0x14)) { cr3 := io.apb.pwdata(15, 0) }
  when(ApbPeripheral.write(io.apb, 0x18)) { gtpr := io.apb.pwdata(15, 0) }

  val idle :: start :: data :: stop :: Nil = Enum(4)
  val state = RegInit(idle)
  val shift = Reg(UInt(8.W)); val bit = RegInit(0.U(3.W))
  val sample = RegInit(0.U(3.W)); val divider = RegInit(0.U(20.W))
  val sampleTick = divider === 0.U
  divider := Mux(sampleTick, brr(15, 4), divider - 1.U)
  val baudTick = sampleTick && sample === 4.U
  when(sampleTick) { sample := Mux(sample === 4.U, 0.U, sample + 1.U) }
  fifo.io.deq.ready := false.B
  when(state === idle && fifo.io.deq.valid && baudTick) {
    shift := fifo.io.deq.bits; fifo.io.deq.ready := true.B; state := start
  }
  when(baudTick) {
    switch(state) {
      is(start) { bit := 0.U; state := data }
      is(data) { when(bit === 7.U) { state := stop }.otherwise { bit := bit + 1.U } }
      is(stop) { state := idle }
    }
  }
  io.txd := MuxLookup(state, true.B)(Seq(start -> false.B, data -> shift(bit)))
  val status = Cat(0.U(24.W), fifo.io.enq.ready, fifo.io.count === 0.U, 0.U(6.W))
  ApbPeripheral.readMux(io.apb, Seq(
    0x00 -> status, 0x08 -> brr, 0x0c -> cr1, 0x10 -> cr2, 0x14 -> cr3, 0x18 -> gtpr
  ))
  io.interrupt := false.B
}
