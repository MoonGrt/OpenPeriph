package soc

import spinal.core._

abstract class NvboardVariant extends Component {
  val io = new Bundle {
    val clk = in Bool()
    val rst = in Bool()
    val uart_tx = out Bool()
    val uart_rx = in Bool()
    val seg = out Bits(8 bits)
    val led = out Bits(8 bits)
    val rgbled = out Bits(6 bits)
    val sw = in Bits(8 bits)
    val vga_vs = out Bool()
    val vga_hs = out Bool()
    val vga_de = out Bool()
    val vga_data = out UInt(24 bits)
    val lcdclk = out Bool()
  }
  noIoPrefix()

  io.vga_vs := False
  io.vga_hs := False
  io.vga_de := False
  io.vga_data := 0
  io.lcdclk := io.clk
}

class CyberNvboardVariant(firmware: String) extends NvboardVariant {
  val soc = new Cyber(CyberConfig.default.copy(memFile = firmware, memFileType = "rawhex"))
  soc.io.clk := io.clk
  soc.io.rstn := !io.rst
  soc.io.jtag.tck := False
  soc.io.jtag.tms := False
  soc.io.jtag.tdi := False
  soc.io.gpio.read := B(0, 14 bits) ## io.uart_rx ## B(0, 9 bits) ## io.sw
  io.uart_tx := soc.io.uartTx
  io.led := soc.io.gpio.write(7 downto 0)
  io.seg := soc.io.gpio.write(15 downto 8)
  io.rgbled := soc.io.gpio.write(5 downto 0)
}

class CyberPlusNvboardVariant(firmware: String) extends NvboardVariant {
  val soc = new CyberPlus(CyberPlusConfig.default.copy(memFile = firmware, memFileType = "rawhex"))
  soc.io.clk := io.clk
  soc.io.rstn := !io.rst
  soc.io.jtag.tck := False
  soc.io.jtag.tms := False
  soc.io.jtag.tdi := False
  soc.io.gpio.read := B(0, 14 bits) ## io.uart_rx ## B(0, 9 bits) ## io.sw
  io.uart_tx := soc.io.uartTx
  io.led := soc.io.gpio.write(7 downto 0)
  io.seg := soc.io.gpio.write(15 downto 8)
  io.rgbled := soc.io.gpio.write(5 downto 0)
}

object CyberNvboardVariant {
  def main(args: Array[String]): Unit =
    SpinalConfig(targetDirectory = "rtl/cyber").generateVerilog(
      new CyberNvboardVariant("../../software/bare/build/demo.hex"))
}

object CyberPlusNvboardVariant {
  def main(args: Array[String]): Unit =
    SpinalConfig(targetDirectory = "rtl/cyberplus").generateVerilog(
      new CyberPlusNvboardVariant("../../software/rthtread/build/demo.hex"))
}
