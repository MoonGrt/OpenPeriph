// package graphic.hdmi

// import graphic.base._
// import graphic.dvtc._
// import spinal.core._
// import spinal.lib._
// import spinal.lib.bus.amba3.apb._
// import spinal.lib.bus.amba4.axi._
// import spinal.lib.graphic.{VideoDmaGeneric, VideoDma}

// case class Axi4LcdCtrlGenerics(
//   axiAddressWidth : Int,
//   axiDataWidth : Int,
//   burstLength : Int,
//   frameSizeMax : Int,
//   fifoSize : Int,
//   rgbConfig: RgbConfig,
//   timingsWidth: Int = 12,
//   pendingRequestMax : Int = 7,
//   lcdClock : ClockDomain = ClockDomain.current
// ) {
//   def axi4Config = dmaGenerics.getAxi4ReadOnlyConfig

//   def apb3Config = Apb3Config(
//     addressWidth = 8,
//     dataWidth = 32,
//     useSlaveError = false
//   )

//   def dmaGenerics = VideoDmaGeneric(
//     addressWidth      = axiAddressWidth - log2Up(bytePerAddress),
//     dataWidth         = axiDataWidth,
//     beatPerAccess     = burstLength,
//     sizeWidth         = log2Up(frameSizeMax) -log2Up(bytePerAddress),
//     pendingRequetMax  = pendingRequestMax,
//     fifoSize          = fifoSize,
//     frameClock        = lcdClock,
//     frameFragmentType = Rgb(rgbConfig)
//   )

//   def bytePerAddress =  axiDataWidth/8 * burstLength
//   def colorConfig = rgbConfig.toColorConfig
// }

// case class Axi4Lcd(g : Axi4LcdCtrlGenerics) extends Component{
//   import g._
//   require(isPow2(burstLength))

//   val io = new Bundle{
//     val axi = master(Axi4ReadOnly(axi4Config))
//     val apb = slave(Apb3(apb3Config))
//     val dvt = master(DVTBus(colorConfig))
//   }

//   val dma  = VideoDma(dmaGenerics)
//   dma.io.mem.toAxi4ReadOnly <> io.axi

//   val lcd = new ClockingArea(lcdClock) {
//     val DVTCCtrl = new Apb3Dvtc(g.colorConfig, g.timingsWidth)
//   }
//   io.apb <> lcd.DVTCCtrl.io.apb
//   io.dvt <> lcd.DVTCCtrl.io.dvt
// }

// object Axi4LcdCtrlGen{
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Axi4Lcd(Axi4LcdCtrlGenerics(
//         axiAddressWidth = 32,
//         axiDataWidth = 32,
//         burstLength = 8,
//         frameSizeMax = 2048*1512,
//         fifoSize = 512,
//         ColorConfig = RGBConfig(5, 6, 5),
//         lcdClock = ClockDomain.external("lcd"))
//       )
//     )
//   }
// }
