package periph

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.APBBundle

class TriStateIO(width: Int) extends Bundle {
  val read = Input(UInt(width.W))
  val write = Output(UInt(width.W))
  val writeEnable = Output(UInt(width.W))
}

object ApbPeripheral {
  def access(apb: APBBundle): Bool = apb.psel && apb.penable
  def read(apb: APBBundle, address: Int): Bool =
    access(apb) && !apb.pwrite && apb.paddr === address.U
  def write(apb: APBBundle, address: Int): Bool =
    access(apb) && apb.pwrite && apb.paddr === address.U

  def defaults(apb: APBBundle): Unit = {
    apb.prdata := 0.U
    apb.pready := true.B
    apb.pslverr := false.B
  }

  def readMux(apb: APBBundle, entries: Seq[(Int, UInt)]): Unit = {
    apb.prdata := MuxLookup(apb.paddr, 0.U)(entries.map { case (address, data) =>
      address.U -> data
    })
  }
}
