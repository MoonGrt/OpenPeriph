package periph.i2c

import chisel3._
import chisel3.util._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbI2c(addressWidth: Int = 6, dataWidth: Int = 32) extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val sdaRead = Input(Bool()); val scl = Output(Bool()); val sdaWrite = Output(Bool()); val sdaWriteEnable = Output(Bool())
    val interrupt = Output(Bool())
  })
  ApbPeripheral.defaults(io.apb)
  val cr1=RegInit(0.U(16.W));val cr2=RegInit(0.U(16.W));val oar1=RegInit(0.U(16.W));val oar2=RegInit(0.U(16.W))
  val dr=RegInit(0.U(16.W));val sr1=RegInit("h0080".U(16.W));val sr2=RegInit(0.U(16.W));val ccr=RegInit(0.U(16.W));val trise=RegInit(2.U(16.W))
  val idle::start::data::ack::stop::Nil=Enum(5);val state=RegInit(idle);val divider=RegInit(0.U(12.W));val bits=RegInit(0.U(4.W));val shift=Reg(UInt(8.W))
  val scl=RegInit(true.B);val sda=RegInit(true.B);val drive=RegInit(false.B);val reload=Mux(ccr(11,0)===0.U,1.U,ccr(11,0))
  when(ApbPeripheral.write(io.apb,0x00)){cr1:=io.apb.pwdata} ;when(ApbPeripheral.write(io.apb,0x04)){cr2:=io.apb.pwdata}
  when(ApbPeripheral.write(io.apb,0x08)){oar1:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x0c)){oar2:=io.apb.pwdata}
  when(ApbPeripheral.write(io.apb,0x10)){dr:=io.apb.pwdata;shift:=io.apb.pwdata(7,0);sr1:=sr1.bitSet(7.U,false.B)}
  when(ApbPeripheral.write(io.apb,0x14)){sr1:=sr1&(~io.apb.pwdata).asUInt};when(ApbPeripheral.write(io.apb,0x1c)){ccr:=io.apb.pwdata};when(ApbPeripheral.write(io.apb,0x20)){trise:=io.apb.pwdata}
  when(cr1(15)){cr1:=0.U;sr1:="h0080".U;sr2:=0.U;state:=idle;scl:=true.B;drive:=false.B}
  .elsewhen(cr1(0)){
    when(divider===0.U){divider:=reload
      switch(state){
        is(idle){when(cr1(8)){state:=start;sda:=false.B;drive:=true.B;sr1:=sr1.bitSet(0.U,true.B);sr2:=3.U;cr1:=cr1.bitSet(8.U,false.B)}}
        is(start){scl:=false.B;bits:=0.U;state:=data;sr1:=sr1.bitSet(0.U,false.B)}
        is(data){scl := !scl;when(scl){sda:=shift(7);shift:=Cat(shift(6,0),0.U);bits:=bits+1.U;when(bits===7.U){state:=ack;drive:=false.B}}}
        is(ack){scl:=true.B;when(io.sdaRead){sr1:=sr1.bitSet(10.U,true.B)}.otherwise{sr1:=sr1.bitSet(2.U,true.B).bitSet(7.U,true.B)};state:=Mux(cr1(9),stop,idle)}
        is(stop){scl:=true.B;sda:=true.B;drive:=true.B;cr1:=cr1.bitSet(9.U,false.B);sr2:=0.U;state:=idle}
      }
    }.otherwise{divider:=divider-1.U}
  }.otherwise{state:=idle;scl:=true.B;drive:=false.B;sr2:=0.U}
  ApbPeripheral.readMux(io.apb,Seq(0x00->cr1,0x04->cr2,0x08->oar1,0x0c->oar2,0x10->dr,0x14->sr1,0x18->sr2,0x1c->ccr,0x20->trise))
  io.scl:=scl;io.sdaWrite:=sda;io.sdaWriteEnable:=drive
  io.interrupt:=(cr2(8)&&sr1(15,8).orR)||(cr2(9)&&sr1(4,0).orR)||(cr2(10)&&sr1(7,6).orR)
}
