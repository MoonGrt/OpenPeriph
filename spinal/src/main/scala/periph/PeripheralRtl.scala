package periph

import spinal.core._

/** Elaborates the standalone peripherals that are shared by the SoC variants. */
object PeripheralRtl {
  def main(args: Array[String]): Unit = {
    val output = "rtl/periph"
    SpinalConfig(targetDirectory = output).generateVerilog(Apb3I2c())
    SpinalConfig(targetDirectory = output).generateVerilog(Apb3Spi())
    SpinalConfig(targetDirectory = output).generateVerilog(Apb3Crc())
    SpinalConfig(targetDirectory = output).generateVerilog(Apb3Can())
    SpinalConfig(targetDirectory = output).generateVerilog(Apb3Sdio())
    SpinalConfig(targetDirectory = output).generateVerilog(Axi4Ram(32, 64 KiB, 4))
  }
}
