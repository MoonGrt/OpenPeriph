package periph.sdio

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbSdio(addressWidth:Int=8,dataWidth:Int=32)extends Module{
  val io=IO(new Bundle{val apb=Flipped(new APBBundle(APBBundleParameters(addressWidth,dataWidth)));val cmdRead=Input(Bool());val dataRead=Input(UInt(4.W));val sdClk=Output(Bool());val cmdWrite=Output(Bool());val cmdWriteEnable=Output(Bool());val dataWrite=Output(UInt(4.W));val dataWriteEnable=Output(UInt(4.W));val interrupt=Output(Bool())})
  ApbPeripheral.defaults(io.apb)
  val power=RegInit(0.U(32.W));val clkcr=RegInit(0.U(32.W));val arg=RegInit(0.U(32.W));val cmd=RegInit(0.U(32.W));val respcmd=RegInit(0.U(32.W));val resp=RegInit(VecInit(Seq.fill(4)(0.U(32.W))))
  val dtimer=RegInit(0.U(32.W));val dlen=RegInit(0.U(32.W));val dctrl=RegInit(0.U(32.W));val dcount=RegInit(0.U(32.W));val sta=RegInit("h00040000".U(32.W));val mask=RegInit(0.U(32.W))
  val fifo=Module(new Queue(UInt(32.W),32));val divider=RegInit(0.U(8.W));val sdClk=RegInit(false.B)
  fifo.io.enq.valid:=ApbPeripheral.write(io.apb,0x80);fifo.io.enq.bits:=io.apb.pwdata;fifo.io.deq.ready:=ApbPeripheral.read(io.apb,0x80)
  when(ApbPeripheral.write(io.apb,0x00)){power:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x04)){clkcr:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x08)){arg:=io.apb.pwdata}
  when(ApbPeripheral.write(io.apb,0x0c)){cmd:=io.apb.pwdata;when(io.apb.pwdata(10)){respcmd:=io.apb.pwdata(5,0);resp(0):=arg;sta:=sta.bitSet(Mux(io.apb.pwdata(7,6)===0.U,7.U,6.U),true.B)}}
  when(ApbPeripheral.write(io.apb,0x24)){dtimer:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x28)){dlen:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x2c)){dctrl:=io.apb.pwdata;dcount:=dlen}
  when(ApbPeripheral.write(io.apb,0x38)){sta:=sta&(~io.apb.pwdata).asUInt};when(ApbPeripheral.write(io.apb,0x3c)){mask:=io.apb.pwdata}
  when(clkcr(8)&&power(1,0)=/=0.U){when(divider===0.U){divider:=clkcr(7,0);sdClk := !sdClk}.otherwise{divider:=divider-1.U}}.otherwise{sdClk:=false.B}
  val status=sta.bitSet(18.U,fifo.io.count===0.U).bitSet(16.U,fifo.io.count===32.U).bitSet(20.U,fifo.io.count=/=0.U)
  ApbPeripheral.readMux(io.apb,Seq(0x00->power,0x04->clkcr,0x08->arg,0x0c->cmd,0x10->respcmd,0x14->resp(0),0x18->resp(1),0x1c->resp(2),0x20->resp(3),0x24->dtimer,0x28->dlen,0x2c->dctrl,0x30->dcount,0x34->status,0x38->0.U,0x3c->mask,0x48->fifo.io.count,0x80->fifo.io.deq.bits))
  io.sdClk:=sdClk;io.cmdWrite:=true.B;io.cmdWriteEnable:=false.B;io.dataWrite:="hf".U;io.dataWriteEnable:=0.U;io.interrupt:=(status&mask).orR;dontTouch(io.cmdRead);dontTouch(io.dataRead)
}
