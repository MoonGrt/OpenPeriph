package graphic.vga

import graphic.base._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.graphic.{VideoDmaGeneric, VideoDma}

case class Axi4Vga(config: DvtcGenerics) extends Component{
  import config._
  require(isPow2(burstLength))

  val io = new Bundle{
    val apb = slave(Apb3(apb3Config))
    val axi = master(Axi4ReadOnly(axi4Config))
    val dvti = master(DVTI(colorCfg.getWidth))
    val interrupt = out(Bool())
  }

  val dvtc = new Apb3Dvtc(config)
  io.apb <> dvtc.io.apb
  io.axi <> dvtc.io.axi
  io.dvti <> dvtc.io.dvti
  io.interrupt <> dvtc.io.interrupt
}

// object Axi4VgaCtrlGen{
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Axi4Vga(DvtcGenerics(
//         axiAddressWidth = 32,
//         axiDataWidth = 32,
//         burstLength = 8,
//         frameSizeMax = 2048*1512,
//         fifoSize = 512,
//         colorCfg = RGBCfg(5, 6, 5),
//         dvtClock = ClockDomain.external("dvt"))
//       )
//     )
//   }
// }
