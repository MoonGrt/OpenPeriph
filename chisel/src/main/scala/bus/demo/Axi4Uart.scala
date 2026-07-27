package bus.demo

import bus.amba.axi.common._
import bus.amba.axi.host.Axi4SingleBeatMasterHost
import chisel3._
import chisel3.util._

/**
  * AXI4 UART peripheral (single-beat register access).
  *
  * Register map (word offsets):
  * 0x00: TXDATA [7:0] write
  * 0x04: RXDATA [7:0] read (consumes one byte)
  * 0x08: STATUS bit0=txReady, bit1=rxValid
  */
class Axi4Uart(p: AxiParams) extends Module {
  val io = IO(new Bundle {
    val axi = new AXI4SlaveBundle(p)
    val tx = Decoupled(UInt(8.W))
    val rx = Flipped(Decoupled(UInt(8.W)))
  })

  require(p.dataBits >= 8)

  val txRegValid = RegInit(false.B)
  val txRegData  = Reg(UInt(8.W))
  io.tx.valid := txRegValid
  io.tx.bits  := txRegData
  when(io.tx.fire) { txRegValid := false.B }

  val rxRegValid = RegInit(false.B)
  val rxRegData  = Reg(UInt(8.W))
  io.rx.ready := !rxRegValid
  when(io.rx.fire) {
    rxRegValid := true.B
    rxRegData  := io.rx.bits
  }

  val awSeen   = RegInit(false.B)
  val awAddr   = Reg(UInt(p.addrBits.W))
  val awId     = Reg(UInt(p.idBits.W))
  val writeErr = RegInit(false.B)
  val bValid   = RegInit(false.B)

  io.axi.aw.ready := !awSeen && !bValid
  when(io.axi.aw.fire) {
    awSeen := true.B
    awAddr := io.axi.aw.bits.addr
    awId   := io.axi.aw.bits.id
    writeErr := (io.axi.aw.bits.len =/= 0.U) || (io.axi.aw.bits.size =/= log2Ceil(p.dataBits / 8).U)
  }

  io.axi.w.ready := awSeen && !bValid
  when(io.axi.w.fire) {
    val word = awAddr(3, 2)
    when(!writeErr && word === 0.U && !txRegValid) {
      txRegData  := io.axi.w.bits.data(7, 0)
      txRegValid := true.B
    }.elsewhen(!writeErr && word === 0.U && txRegValid) {
      writeErr := true.B
    }.elsewhen(!writeErr && word =/= 0.U) {
      writeErr := true.B
    }
    when(io.axi.w.bits.last) {
      bValid  := true.B
      awSeen  := false.B
    }
  }

  io.axi.b.valid     := bValid
  io.axi.b.bits.id   := awId
  io.axi.b.bits.resp := Mux(writeErr, AxiResp.SLVERR, AxiResp.OKAY)
  io.axi.b.bits.user := 0.U
  when(io.axi.b.fire) {
    bValid := false.B
    writeErr := false.B
  }

  val rValid   = RegInit(false.B)
  val rId      = Reg(UInt(p.idBits.W))
  val rDataReg = Reg(UInt(p.dataBits.W))
  val rRespReg = RegInit(AxiResp.OKAY)

  io.axi.ar.ready := !rValid
  when(io.axi.ar.fire) {
    val isSingle = (io.axi.ar.bits.len === 0.U) && (io.axi.ar.bits.size === log2Ceil(p.dataBits / 8).U)
    val word = io.axi.ar.bits.addr(3, 2)
    rId := io.axi.ar.bits.id
    rValid := true.B
    when(!isSingle) {
      rDataReg := 0.U
      rRespReg := AxiResp.SLVERR
    }.elsewhen(word === 1.U) {
      rDataReg := rxRegData
      rRespReg := Mux(rxRegValid, AxiResp.OKAY, AxiResp.SLVERR)
      when(rxRegValid) { rxRegValid := false.B }
    }.elsewhen(word === 2.U) {
      val status = Cat(0.U((p.dataBits - 2).W), rxRegValid, !txRegValid)
      rDataReg := status
      rRespReg := AxiResp.OKAY
    }.otherwise {
      rDataReg := 0.U
      rRespReg := AxiResp.SLVERR
    }
  }

  io.axi.r.valid     := rValid
  io.axi.r.bits.id   := rId
  io.axi.r.bits.data := rDataReg
  io.axi.r.bits.resp := rRespReg
  io.axi.r.bits.last := true.B
  io.axi.r.bits.user := 0.U
  when(io.axi.r.fire) { rValid := false.B }
}

/**
 * Generate SystemVerilog sources
 */
object Axi4Uart extends App {
  val p = AxiParams(addrBits = 32, dataBits = 32, idBits = 4)
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      "disallowLocalVariables",
      "disallowPackedArrays",
      "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _)
  )
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(new Axi4Uart(p), args, firtoolOptions)
}

/** Minimal Axi4Uart usage example with command host. */
class Axi4UartExample extends Module {
  private implicit val params: AxiParameters = new BaseAxiConfig
  private val p = AxiParams.fromPortParameters

  val io = IO(new Bundle {
    val sent = Output(Bool())
    val txByte = Output(UInt(8.W))
    val txValid = Output(Bool())
  })

  val host = Module(new Axi4SingleBeatMasterHost(p))
  val uart = Module(new Axi4Uart(p))
  host.io.axi <> uart.io.axi

  uart.io.rx.valid := false.B
  uart.io.rx.bits  := 0.U
  io.txByte := uart.io.tx.bits
  io.txValid := uart.io.tx.valid
  uart.io.tx.ready := true.B

  val sWrite :: sWait :: sDone :: Nil = Enum(3)
  val st = RegInit(sWrite)
  host.io.cmd.valid := false.B
  host.io.cmd.bits  := 0.U.asTypeOf(host.io.cmd.bits)
  host.io.rsp.ready := false.B

  switch(st) {
    is(sWrite) {
      host.io.cmd.valid      := true.B
      host.io.cmd.bits.write := true.B
      host.io.cmd.bits.addr  := 0.U
      host.io.cmd.bits.wdata := "h00000041".U // 'A'
      host.io.cmd.bits.strb  := Fill(p.strobeBits, 1.U(1.W))
      host.io.cmd.bits.prot  := 0.U
      when(host.io.cmd.fire) { st := sWait }
    }
    is(sWait) {
      host.io.rsp.ready := true.B
      when(host.io.rsp.fire) { st := sDone }
    }
  }
  io.sent := (st === sDone)
}

object Axi4UartExample extends App {
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      "disallowLocalVariables",
      "disallowPackedArrays",
      "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _)
  )
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(new Axi4UartExample, args, firtoolOptions)
}
