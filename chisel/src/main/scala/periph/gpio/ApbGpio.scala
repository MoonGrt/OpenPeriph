package periph.gpio

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.{ApbPeripheral, TriStateIO}

class ApbGpio(
    gpioWidth: Int = 16,
    withReadSync: Boolean = true,
    addressWidth: Int = 5,
    dataWidth: Int = 32
) extends Module {
  require(gpioWidth == 16, "The register layout contains exactly 16 GPIO pins")

  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val gpio = new TriStateIO(gpioWidth)
    val afio = Input(UInt(gpioWidth.W))
  })

  ApbPeripheral.defaults(io.apb)

  val crl = RegInit(0.U(32.W))
  val crh = RegInit(0.U(32.W))
  val odr = RegInit(0.U(gpioWidth.W))
  val lckr = RegInit(0.U(gpioWidth.W))
  val lckk = RegInit(false.B)
  val gpioInput = if (withReadSync) RegNext(RegNext(io.gpio.read, 0.U), 0.U) else io.gpio.read

  private def configMask(offset: Int): UInt =
    Cat((0 until 8).reverse.map(i => Fill(4, !lckr(i + offset))))

  when(ApbPeripheral.write(io.apb, 0x00)) {
    val mask = configMask(0)
    crl := (crl & ~mask) | (io.apb.pwdata & mask)
  }
  when(ApbPeripheral.write(io.apb, 0x04)) {
    val mask = configMask(8)
    crh := (crh & ~mask) | (io.apb.pwdata & mask)
  }
  when(ApbPeripheral.write(io.apb, 0x0c)) { odr := io.apb.pwdata(gpioWidth - 1, 0) }
  when(ApbPeripheral.write(io.apb, 0x10)) {
    odr := (odr | io.apb.pwdata(15, 0)) & ~io.apb.pwdata(31, 16)
  }
  when(ApbPeripheral.write(io.apb, 0x14)) { odr := odr & ~io.apb.pwdata(15, 0) }
  when(ApbPeripheral.write(io.apb, 0x18)) {
    lckr := lckr | (io.apb.pwdata(15, 0) & ~lckr)
    when(io.apb.pwdata(16)) { lckk := true.B }
  }

  ApbPeripheral.readMux(io.apb, Seq(
    0x00 -> crl,
    0x04 -> crh,
    0x08 -> gpioInput,
    0x0c -> odr,
    0x18 -> Cat(0.U(15.W), lckk, lckr)
  ))

  val writeData = Wire(Vec(gpioWidth, Bool()))
  val writeEnable = Wire(Vec(gpioWidth, Bool()))
  for (i <- 0 until gpioWidth) {
    val cfg = if (i < 8) crl(4 * i + 3, 4 * i) else crh(4 * (i - 8) + 3, 4 * (i - 8))
    val mode = cfg(1, 0)
    val cnf = cfg(3, 2)
    val output = Mux(cnf === 2.U || cnf === 3.U, io.afio(i), odr(i))
    writeData(i) := output
    writeEnable(i) := mode =/= 0.U && (!(cnf === 1.U || cnf === 3.U) || !output)
  }
  io.gpio.write := writeData.asUInt
  io.gpio.writeEnable := writeEnable.asUInt
}
