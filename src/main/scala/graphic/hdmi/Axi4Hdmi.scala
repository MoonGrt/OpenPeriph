package graphic.hdmi

import spinal.core._
import spinal.lib._
import spinal.lib.blackbox.lattice.ecp5.ODDRX1F
import spinal.lib.graphic.RgbConfig
import spinal.lib.graphic.vga._


object TmdsEncoder{
  def apply(VD : UInt, CD : Bits, VDE : Bool, TMDS :Bits) : TmdsEncoder = {
    val ret = TmdsEncoder()
    ret.io.VD := VD
    ret.io.CD := CD
    ret.io.VDE := VDE
    TMDS := ret.io.TMDS
    ret
  }
}

case class TmdsEncoder() extends Component{
  val io = new Bundle {
    val VD = in UInt(8 bits)
    val CD = in Bits(2 bits)
    val VDE = in Bool()
    val TMDS = out (Reg(Bits(10 bits)))
  }

  val dc_bias = Reg(UInt(4 bits)) randBoot()

  val ones = io.VD.asBools.map(_.asUInt(4 bits)).reduceBalancedTree(_ + _)
  val XNOR = (ones > 4) || (ones === 4 && io.VD(0) === False)
  val dw = Vec(Bool(), 9)
  dw(8) := ~XNOR;
  dw(7) := dw(6) ^ io.VD(7) ^ XNOR;
  dw(6) := dw(5) ^ io.VD(6) ^ XNOR;
  dw(5) := dw(4) ^ io.VD(5) ^ XNOR;
  dw(4) := dw(3) ^ io.VD(4) ^ XNOR;
  dw(3) := dw(2) ^ io.VD(3) ^ XNOR;
  dw(2) := dw(1) ^ io.VD(2) ^ XNOR;
  dw(1) := dw(0) ^ io.VD(1) ^ XNOR;
  dw(0) := io.VD(0);

  val dw_disp = dw.take(8).map(_.asUInt(4 bits)).reduceBalancedTree(_ + _) + 12
  val sign_eq = dw_disp(3) === dc_bias(3)
  val delta  = dw_disp - U((dw(8) ^ ~sign_eq) & ~(dw_disp===0 || dc_bias===0));
  val inv_dw = (dw_disp === 0 || dc_bias === 0) ? ~dw(8) | sign_eq;
  val dc_bias_d = inv_dw ? (dc_bias - delta) | (dc_bias + delta)
  val TMDS_data =  inv_dw ## dw(8) ## (dw.take(8).asBits ^ (inv_dw ? B(255) | B(0)))
  val TMDS_code = io.CD(1) ? (io.CD(0) ? B"b1010101011" | B"b0101010100") | (io.CD(0) ? B"b0010101011" | B"b1101010100")

  io.TMDS := (io.VDE ? TMDS_data | TMDS_code);
  dc_bias := (io.VDE ? dc_bias_d | 0)
}

case class VgaToHdmi(vgaCd : ClockDomain, hdmiCd : ClockDomain, rgbConfig: RgbConfig) extends Component {
  val io = new Bundle {
    val vga = slave(Vga(rgbConfig))
    val gpdi_dp, gpdi_dn = out Bits(4 bits)
  }

  val rgbR = io.vga.color.r.resize(8)
  val rgbG = io.vga.color.g.resize(8)
  val rgbB = io.vga.color.b.resize(8)

  val TMDS_red, TMDS_green, TMDS_blue = Bits(10 bits)
  val bCd = io.vga.vSync ## io.vga.hSync
  val encode_R = vgaCd(TmdsEncoder(VD = rgbR, CD = B"00", VDE = io.vga.colorEn, TMDS = TMDS_red))
  val encode_G = vgaCd(TmdsEncoder(VD = rgbG, CD = B"00", VDE = io.vga.colorEn, TMDS = TMDS_green))
  val encode_B = vgaCd(TmdsEncoder(VD = rgbB, CD = bCd  , VDE = io.vga.colorEn, TMDS = TMDS_blue))

  val TMDS_rgb = new ClockingArea(hdmiCd) {
    val red_sync   = BufferCC(TMDS_red)
    val green_sync = BufferCC(TMDS_green)
    val blue_sync  = BufferCC(TMDS_blue)
  }

  val ctr_mod5 = hdmiCd(Reg(UInt(3 bits)) randBoot())
  val shift_ld = hdmiCd(Reg(Bool()) randBoot())

  shift_ld :=  ctr_mod5 === 4
  ctr_mod5 := ((ctr_mod5 === 4) ? U"3'd0" | (ctr_mod5 + 1))

  val shift_R, shift_G, shift_B, shift_C = hdmiCd(Reg(Bits(10 bits)))

  shift_R := (shift_ld ? TMDS_rgb.red_sync   | shift_R(9 downto 2).resized)
  shift_G := (shift_ld ? TMDS_rgb.green_sync | shift_G(9 downto 2).resized)
  shift_B := (shift_ld ? TMDS_rgb.blue_sync  | shift_B(9 downto 2).resized)
  shift_C := (shift_ld ? B"10'h3e0"          | shift_C(9 downto 2).resized)

  val ddr3p = hdmiCd(ODDRX1F (Q = io.gpdi_dp(3), D0 =  shift_C(0), D1 =  shift_C(1)))
  val ddr2p = hdmiCd(ODDRX1F (Q = io.gpdi_dp(2), D0 =  shift_R(0), D1 =  shift_R(1)))
  val ddr1p = hdmiCd(ODDRX1F (Q = io.gpdi_dp(1), D0 =  shift_G(0), D1 =  shift_G(1)))
  val ddr0p = hdmiCd(ODDRX1F (Q = io.gpdi_dp(0), D0 =  shift_B(0), D1 =  shift_B(1)))

  val ddr3n = hdmiCd(ODDRX1F (Q = io.gpdi_dn(3), D0 = ~shift_C(0), D1 = ~shift_C(1)))
  val ddr2n = hdmiCd(ODDRX1F (Q = io.gpdi_dn(2), D0 = ~shift_R(0), D1 = ~shift_R(1)))
  val ddr1n = hdmiCd(ODDRX1F (Q = io.gpdi_dn(1), D0 = ~shift_G(0), D1 = ~shift_G(1)))
  val ddr0n = hdmiCd(ODDRX1F (Q = io.gpdi_dn(0), D0 = ~shift_B(0), D1 = ~shift_B(1)))
}
