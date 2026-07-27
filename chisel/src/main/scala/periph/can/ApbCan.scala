package periph.can

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbCan(addressWidth: Int = 10, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val rx = Input(Bool()); val tx = Output(Bool()); val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val mcr=RegInit(2.U(32.W));val msr=RegInit(1.U(32.W));val tsr=RegInit("h1c000000".U(32.W))
  val rf0r=RegInit(0.U(32.W));val rf1r=RegInit(0.U(32.W));val ier=RegInit(0.U(32.W));val esr=RegInit(0.U(32.W));val btr=RegInit(0.U(32.W))
  val tx=RegInit(VecInit(Seq.fill(12)(0.U(32.W))));val rx=RegInit(VecInit(Seq.fill(8)(0.U(32.W))))
  val filterCtrl=RegInit(VecInit(Seq.fill(6)(0.U(32.W))));val filters=RegInit(VecInit(Seq.fill(28)(0.U(32.W))))
  val address=io.apb.paddr;val txIndex=address(5,2);val rxIndex=address(4,2)-4.U;val filterIndex=address(6,2)-16.U
  when(ApbPeripheral.write(io.apb,0x000)){mcr:=io.apb.pwdata}
  when(ApbPeripheral.write(io.apb,0x004)){msr:=msr&(~io.apb.pwdata).asUInt}
  when(ApbPeripheral.write(io.apb,0x008)){tsr:=tsr&(~io.apb.pwdata).asUInt}
  when(ApbPeripheral.write(io.apb,0x00c)){rf0r:=rf0r&(~io.apb.pwdata).asUInt}
  when(ApbPeripheral.write(io.apb,0x010)){rf1r:=rf1r&(~io.apb.pwdata).asUInt}
  when(ApbPeripheral.write(io.apb,0x014)){ier:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x01c)){btr:=io.apb.pwdata}
  when(ApbPeripheral.access(io.apb)&&io.apb.pwrite&&address>=0x180.U&&address<0x1b0.U){
    tx(txIndex):=io.apb.pwdata
    when(address(3,0)===0.U&&io.apb.pwdata(0)){
      rx(0):=io.apb.pwdata;rx(1):=tx(txIndex+1.U);rx(2):=tx(txIndex+2.U);rx(3):=tx(txIndex+3.U)
      rf0r:=Cat(rf0r(31,4),true.B,rf0r(2),Mux(rf0r(1,0)===3.U,3.U,rf0r(1,0)+1.U));tsr:=tsr.bitSet(0.U,true.B).bitSet(26.U,true.B)
    }
  }
  when(ApbPeripheral.access(io.apb)&&io.apb.pwrite&&address>=0x240.U&&address<0x2b0.U){filters(filterIndex):=io.apb.pwdata}
  val fixed=Seq(0x000->mcr,0x004->msr,0x008->tsr,0x00c->rf0r,0x010->rf1r,0x014->ier,0x018->esr,0x01c->btr)
  val fixedData=MuxLookup(address,0.U)(fixed.map{case(a,d)=>a.U->d})
  io.apb.prdata:=Mux(address>=0x180.U&&address<0x1b0.U,tx(txIndex),Mux(address>=0x1b0.U&&address<0x1d0.U,rx(rxIndex),Mux(address>=0x240.U&&address<0x2b0.U,filters(filterIndex),fixedData)))
  io.tx:=true.B;io.interrupt:=(ier&Cat(0.U(24.W),rf1r(3),rf0r(3),tsr(0),0.U(5.W))).orR
  dontTouch(io.rx);dontTouch(filterCtrl)
}
