package graphic.lcd

import chisel3._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import graphic.dvt._

/**
  * LCD/VGA timing front-end. The test-pattern path is complete; the AXI4
  * framebuffer reader is attached by the SoC-level DMA node.
  */
class Axi4Lcd(apbAddressWidth: Int = 10, dataWidth: Int = 32, colorWidth: Int = 16)
    extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(apbAddressWidth, dataWidth)))
    val dvt = Output(new DvtIO(colorWidth))
    val interrupt = Output(Bool())
  })
  val transmitter = Module(new ApbDvtTransmitter(apbAddressWidth, dataWidth, colorWidth))
  transmitter.io.apb <> io.apb
  io.dvt := transmitter.io.dvt
  io.interrupt := transmitter.io.interrupt
}
