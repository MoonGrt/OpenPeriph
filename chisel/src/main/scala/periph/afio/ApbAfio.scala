package periph.afio

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.{ApbPeripheral, TriStateIO}

class ApbAfio(
    gpioWidth: Int = 16,
    gpioGroupCount: Int = 4,
    addressWidth: Int = 5,
    dataWidth: Int = 32
) extends Module {
  private val totalWidth = gpioWidth * gpioGroupCount
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val device = new TriStateIO(totalWidth)
    val afio = new TriStateIO(totalWidth)
    val afioExti = Output(UInt(gpioWidth.W))
  })

  ApbPeripheral.defaults(io.apb)
  val evcr = RegInit(0.U(32.W))
  val mapr = RegInit(0.U(32.W))
  val exticr = RegInit(VecInit(Seq.fill(4)(0.U(32.W))))
  val mapr2 = RegInit(0.U(32.W))

  when(ApbPeripheral.write(io.apb, 0x00)) { evcr := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x04)) { mapr := io.apb.pwdata }
  for (i <- 0 until 4) {
    when(ApbPeripheral.write(io.apb, 0x08 + i * 4)) { exticr(i) := io.apb.pwdata }
  }
  when(ApbPeripheral.write(io.apb, 0x1c)) { mapr2 := io.apb.pwdata }
  ApbPeripheral.readMux(io.apb,
    Seq(0x00 -> evcr, 0x04 -> mapr, 0x1c -> mapr2) ++
      (0 until 4).map(i => (0x08 + i * 4) -> exticr(i)))

  io.afio.write := io.device.read
  io.device.write := io.afio.read
  io.afio.writeEnable := Fill(totalWidth, true.B)
  io.device.writeEnable := Fill(totalWidth, true.B)

  val exti = Wire(Vec(gpioWidth, Bool()))
  for (pin <- 0 until gpioWidth) {
    val select = exticr(pin / 4)(pin % 4 * 4 + 3, pin % 4 * 4)
    exti(pin) := MuxLookup(select, false.B)(
      (0 until gpioGroupCount).map(group => group.U -> io.afio.read(group * gpioWidth + pin)))
  }
  io.afioExti := exti.asUInt
}
