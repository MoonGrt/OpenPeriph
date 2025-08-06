package soc.gowin.tangprimer

import spinal.core._


class mempll extends BlackBox {
  setDefinitionName("mempll") // Verilog 中模块名为 mempll，不加 io_
  val clkout = out Bool ()
  val lock = out Bool ()
  val reset = in Bool ()
  val clkin = in Bool ()
}

class syspll extends BlackBox {
  setDefinitionName("syspll") // Verilog 中模块名为 syspll，不加 io_
  val clkout = out Bool ()
  val lock = out Bool ()
  val reset = in Bool ()
  val clkin = in Bool ()
}

class vgapll extends BlackBox {
  setDefinitionName("vgapll") // Verilog 中模块名为 vgapll，不加 io_
  val clkout = out Bool ()
  val lock = out Bool ()
  val reset = in Bool ()
  val clkin = in Bool ()
}

class hdmipll extends BlackBox {
  setDefinitionName("hdmipll") // Verilog 中模块名为 hdmipll，不加 io_
  val clkout = out Bool ()
  val lock = out Bool ()
  val reset = in Bool ()
  val clkin = in Bool ()
}

class lcdpll extends BlackBox {
  setDefinitionName("lcdpll") // Verilog 中模块名为 lcdpll，不加 io_
  val clkout = out Bool ()
  val lock = out Bool ()
  val reset = in Bool ()
  val clkin = in Bool ()
}
