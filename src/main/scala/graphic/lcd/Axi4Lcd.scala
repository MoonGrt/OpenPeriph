package graphic.lcd

import graphic.base._
import graphic.dvtc._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.graphic.{VideoDmaGeneric, VideoDma}

case class Axi4Lcd(config: DvtcGenerics) extends Component{
  import config._
  require(isPow2(burstLength))

  val io = new Bundle{
    val axi = master(Axi4ReadOnly(axi4Config))
    val apb = slave(Apb3(Apb3Config(addressWidth = 12, dataWidth = 32, useSlaveError = false)))
    val dvt = master(DVTI(colorConfig))
  }

  val dvtc = new Apb3Dvtc(config)
  val layer = new Apb3DvtcLayer(config)
  layer.io.axi <> io.axi

  val lcd = new ClockingArea(dvtClock) {
    val error = RegInit(False)
    val frameStart = dvtc.io.dvt.de.rise
    val waitStartOfFrame = RegInit(False)
    val firstPixel = Reg(Bool()) setWhen(frameStart) clearWhen(layer.io.pixel.firstFire)

    dvtc.io.pixel << layer.io.pixel.toStreamOfFragment.haltWhen(waitStartOfFrame && !error)

    when(frameStart){
      waitStartOfFrame := False
    }
    when(layer.io.pixel.fire && layer.io.pixel.last){
      error := False
      waitStartOfFrame := error
    }
    when(!waitStartOfFrame && !error) {
      when(firstPixel && layer.io.pixel.valid && !layer.io.pixel.first) {
        error := True
      }
    }

    layer.io.pixel.ready setWhen(!waitStartOfFrame && !error)
    io.dvt <> dvtc.io.dvt
  }

  val decoder = Apb3Decoder(
    master = io.apb,
    slaves = List(
      dvtc.io.apb  -> SizeMapping(0x0000, 0x80),
      layer.io.apb -> SizeMapping(0x0080, 0x80)
    )
  )
}

// object Axi4LcdCtrlGen{
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Axi4Lcd(DvtcGenerics(
//         axiAddressWidth = 32,
//         axiDataWidth = 32,
//         burstLength = 8,
//         frameSizeMax = 2048*1512,
//         fifoSize = 512,
//         colorConfig = RGBConfig(5, 6, 5),
//         dvtClock = ClockDomain.external("dvt"))
//       )
//     )
//   }
// }
