package periph.wdg

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbIndependentWatchdog(addressWidth: Int = 4, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val resetOut = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val prescale = RegInit(0.U(3.W))
  val reload = RegInit("hfff".U(12.W))
  val status = RegInit(0.U(3.W))
  val enabled = RegInit(false.B)
  val counter = RegInit(0.U(12.W))
  val prescaleCounter = RegInit(0.U(8.W))
  val resetReg = RegInit(false.B)

  when(ApbPeripheral.write(io.apb, 0x00)) {
    switch(io.apb.pwdata) {
      is("hcccc".U) { enabled := true.B }
      is("haaaa".U) { counter := reload }
      is("h5555".U) { status := 3.U }
    }
  }
  when(ApbPeripheral.write(io.apb, 0x04) && status(0)) {
    prescale := io.apb.pwdata(2, 0); status := status.bitSet(0.U, false.B)
  }
  when(ApbPeripheral.write(io.apb, 0x08) && status(1)) {
    reload := io.apb.pwdata(11, 0); status := status.bitSet(1.U, false.B)
  }
  val prescaleMax = ((1.U(8.W) << (prescale + 2.U)) - 1.U)(7, 0)
  when(enabled) {
    prescaleCounter := prescaleCounter + 1.U
    when(prescaleCounter === prescaleMax) {
      prescaleCounter := 0.U
      when(counter === 0.U) { resetReg := true.B }
        .otherwise { counter := counter - 1.U; resetReg := false.B }
    }
  }.otherwise { prescaleCounter := 0.U; resetReg := false.B }
  ApbPeripheral.readMux(io.apb, Seq(0x04 -> prescale, 0x08 -> reload, 0x0c -> status))
  io.resetOut := resetReg
}

class ApbWindowWatchdog(addressWidth: Int = 5, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val resetOut = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val cr = RegInit(0.U(8.W))
  val cfr = RegInit(0.U(16.W))
  val interruptFlag = RegInit(false.B)
  val counter = RegInit("h7f".U(7.W))
  val prescaleCounter = RegInit(0.U(15.W))
  val resetReg = RegInit(false.B)

  when(ApbPeripheral.write(io.apb, 0x00)) {
    val count = io.apb.pwdata(6, 0)
    cr := Cat(cr(7) || io.apb.pwdata(7), count)
    when(count < cfr(6, 0)) { counter := count; interruptFlag := false.B }
  }
  when(ApbPeripheral.write(io.apb, 0x04)) { cfr := io.apb.pwdata(15, 0) }
  val prescaleMax = ((4096.U(15.W) << cfr(8, 7)) - 1.U)(14, 0)
  when(cr(7)) {
    prescaleCounter := prescaleCounter + 1.U
    when(prescaleCounter === prescaleMax) {
      prescaleCounter := 0.U
      when(counter === 0.U) { resetReg := true.B }
        .otherwise { counter := counter - 1.U; resetReg := false.B }
    }
  }.otherwise { prescaleCounter := 0.U; resetReg := false.B }
  ApbPeripheral.readMux(io.apb, Seq(0x00 -> cr, 0x04 -> cfr, 0x08 -> interruptFlag.asUInt))
  io.resetOut := resetReg
}
