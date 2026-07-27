package periph.spi

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbSpi(addressWidth: Int = 6, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val miso = Input(Bool()); val sclk = Output(Bool()); val mosi = Output(Bool()); val nss = Output(Bool())
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val cr1 = RegInit(0.U(16.W)); val cr2 = RegInit(0.U(16.W)); val crcpr = RegInit(7.U(16.W))
  val i2scfgr = RegInit(0.U(16.W)); val i2spr = RegInit(2.U(16.W))
  val tx = Reg(UInt(16.W)); val rx = RegInit(0.U(16.W)); val shiftTx = Reg(UInt(16.W)); val shiftRx = Reg(UInt(16.W))
  val pending = RegInit(false.B); val rxValid = RegInit(false.B); val busy = RegInit(false.B)
  val bitsLeft = Reg(UInt(5.W)); val divider = RegInit(0.U(9.W)); val sclk = RegInit(false.B)
  val frameBits = Mux(cr1(11), 16.U, 8.U)
  val reload = ((1.U(9.W) << (cr1(5, 3) + 1.U)) - 1.U)(8, 0)

  when(ApbPeripheral.write(io.apb, 0x00)) { cr1 := io.apb.pwdata; sclk := io.apb.pwdata(1) }
  when(ApbPeripheral.write(io.apb, 0x04)) { cr2 := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x0c) && !pending) { tx := io.apb.pwdata; pending := true.B }
  when(ApbPeripheral.write(io.apb, 0x10)) { crcpr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x1c)) { i2scfgr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x20)) { i2spr := io.apb.pwdata }
  when(ApbPeripheral.read(io.apb, 0x0c)) { rxValid := false.B }
  when(!busy && pending && cr1(6)) {
    shiftTx := tx; shiftRx := 0.U; bitsLeft := frameBits; busy := true.B; pending := false.B; divider := reload; sclk := cr1(1)
  }.elsewhen(busy) {
    when(divider === 0.U) {
      divider := reload; sclk := !sclk
      when(sclk =/= (cr1(1) ^ cr1(0))) {
        when(cr1(7)) { shiftRx := Cat(io.miso, shiftRx(15, 1)); shiftTx := Cat(0.U, shiftTx(15, 1)) }
          .otherwise { shiftRx := Cat(shiftRx(14, 0), io.miso); shiftTx := Cat(shiftTx(14, 0), 0.U) }
        bitsLeft := bitsLeft - 1.U
        when(bitsLeft === 1.U) { rx := Mux(cr1(7), Cat(io.miso, shiftRx(15, 1)), Cat(shiftRx(14, 0), io.miso)); rxValid := true.B; busy := false.B; sclk := cr1(1) }
      }
    }.otherwise { divider := divider - 1.U }
  }
  val status = Cat(0.U(8.W), busy, 0.U(5.W), !pending, rxValid)
  ApbPeripheral.readMux(io.apb, Seq(0x00 -> cr1, 0x04 -> cr2, 0x08 -> status, 0x0c -> rx,
    0x10 -> crcpr, 0x14 -> 0.U, 0x18 -> 0.U, 0x1c -> i2scfgr, 0x20 -> i2spr))
  io.sclk := sclk; io.mosi := Mux(cr1(7), shiftTx(0), Mux(cr1(11), shiftTx(15), shiftTx(7))); io.nss := !(busy && cr1(2))
  io.interrupt := (cr2(7) && !pending) || (cr2(6) && rxValid)
}
