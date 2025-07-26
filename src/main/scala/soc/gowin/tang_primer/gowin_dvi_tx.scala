package soc.gowin.tangprimer

import spinal.core._


class CLKDIV extends BlackBox {
  setDefinitionName("CLKDIV") // Verilog 中模块名为 CLKDIV，不加 io_
  // Inputs
  val RESETN = in Bool ()
  val CALIB = in Bool ()
  val HCLKIN = in Bool ()
  // Outputs
  val CLKOUT = out Bool ()
}
