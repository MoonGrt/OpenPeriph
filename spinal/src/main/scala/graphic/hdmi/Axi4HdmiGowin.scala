package graphic.hdmi

import spinal.core._
import spinal.lib._
import spinal.lib.blackbox.lattice.ecp5.ODDRX1F
import spinal.lib.graphic.RgbConfig
import spinal.lib.graphic.vga._


case class Hdmi() extends Bundle with IMasterSlave {
  // 输出接口
  val O_tmds_clk_p  = out Bool()        // TMDS clock positive
  val O_tmds_clk_n  = out Bool()        // TMDS clock negative
  val O_tmds_data_p = out Bits(3 bits)  // TMDS data positive [2:0]
  val O_tmds_data_n = out Bits(3 bits)  // TMDS data negative [2:0]

  override def asMaster(): Unit = {
    out(O_tmds_clk_p, O_tmds_clk_n, O_tmds_data_p, O_tmds_data_n)
  }
}

case class dvi_tx (vgaCd: ClockDomain, hdmiCd: ClockDomain) extends BlackBox {
  setDefinitionName("DVI_TX_Top") // Verilog 中模块名为 DVI_TX_Top，不加 io_
  val io = new Bundle {
    // Inputs
    val I_rst_n = in Bool ()
    val I_serial_clk = in Bool ()
    val I_rgb_clk = in Bool ()
    val I_rgb_vs = in Bool ()
    val I_rgb_hs = in Bool ()
    val I_rgb_de = in Bool ()
    val I_rgb_r = in Bits (8 bits)
    val I_rgb_g = in Bits (8 bits)
    val I_rgb_b = in Bits (8 bits)
    // Outputs
    val O_tmds_clk_p  = out Bool()
    val O_tmds_clk_n  = out Bool()
    val O_tmds_data_p = out Bits(3 bits)
    val O_tmds_data_n = out Bits(3 bits)
  }
  def connectHdmiInterface(iface: Hdmi): Unit = {
    iface.O_tmds_clk_p  := io.O_tmds_clk_p
    iface.O_tmds_clk_n  := io.O_tmds_clk_n
    iface.O_tmds_data_p := io.O_tmds_data_p
    iface.O_tmds_data_n := io.O_tmds_data_n
  }
  noIoPrefix()
  mapClockDomain(vgaCd, clock = io.I_rgb_clk, reset = io.I_rst_n, resetActiveLevel = LOW)
  mapClockDomain(hdmiCd, clock = io.I_serial_clk)
}

case class VgaToHdmiGowin(vgaCd: ClockDomain, hdmiCd: ClockDomain, rgbConfig: RgbConfig) extends Component {
  val io = new Bundle {
    val vga  = slave(Vga(rgbConfig))   // VGA 输入信号
    val hdmi = master(Hdmi())          // HDMI 输出信号
  }

  // 实例化 DVI_TX_Top BlackBox
  val dvi_tx = new dvi_tx(vgaCd, hdmiCd)
  // ------- 信号连接 -------
  // VGA 同步信号
  dvi_tx.io.I_rgb_vs := ~io.vga.vSync
  dvi_tx.io.I_rgb_hs := ~io.vga.hSync
  dvi_tx.io.I_rgb_de := io.vga.colorEn
  // RGB 数据
  dvi_tx.io.I_rgb_r := (io.vga.color.r ## B"3'b000")
  dvi_tx.io.I_rgb_g := (io.vga.color.g ## B"2'b00")
  dvi_tx.io.I_rgb_b := (io.vga.color.b ## B"3'b000")
  // TMDS 输出
  dvi_tx.connectHdmiInterface(io.hdmi)
}
