package bus.simple

import chisel3._
import chisel3.experimental.BundleLiterals._
import scala.collection.immutable.ListMap

/* =========================================================
 * Dynamic Field
 * ========================================================= */

case class BusField[T <: Data](
  name: String,
  gen : T
)

/* =========================================================
 * Config
 * ========================================================= */

case class SimpleBusConfig(
  reqFields : Seq[BusField[_ <: Data]] = Seq(),
  respFields: Seq[BusField[_ <: Data]] = Seq()
)

/* =========================================================
 * Dynamic Bundle
 *
 * 允许：
 *   io.bus.req.addr
 *   io.bus.req.wdata
 *
 * 原理：
 *   Bundle + Record
 * ========================================================= */

abstract class DynamicBundle(
  fields: Seq[(String, Data)]
) extends Record {
  val elements = ListMap(fields: _*)
  override def cloneType: this.type =
    (this.getClass.getConstructors.head
      .newInstance(fields)
      .asInstanceOf[this.type])
}

/* =========================================================
 * Request Channel
 * ========================================================= */

class SimpleBusReq(
  val fieldSeq: Seq[(String, Data)]
) extends DynamicBundle(
  Seq(
    "valid" -> Output(Bool()),
    "ready" -> Input(Bool())
  ) ++ fieldSeq.map { case (n, d) => n -> Output(d.cloneType) }
) {
  def valid = elements("valid").asInstanceOf[Bool]
  def ready = elements("ready").asInstanceOf[Bool]
  def fire: Bool = valid && ready
  def field[T <: Data](name: String): T =
    elements(name).asInstanceOf[T]
  def addr  = field[UInt]("addr")
  def wdata = field[UInt]("wdata")
  def write = field[Bool]("write")
}

/* =========================================================
 * Response Channel
 * ========================================================= */

class SimpleBusResp(
  val fieldSeq: Seq[(String, Data)]
) extends DynamicBundle(
  Seq(
    "valid" -> Input(Bool()),
    "ready" -> Output(Bool())
  ) ++ fieldSeq.map { case (n, d) => n -> Input(d.cloneType) }
) {
  def valid = elements("valid").asInstanceOf[Bool]
  def ready = elements("ready").asInstanceOf[Bool]
  def fire: Bool = valid && ready
  def field[T <: Data](name: String): T =
    elements(name).asInstanceOf[T]
  def rdata = field[UInt]("rdata")
  def error = field[Bool]("error")
}

/* =========================================================
 * Top Bus
 * ========================================================= */

class SimpleBus(cfg: SimpleBusConfig) extends Bundle {
  val req = new SimpleBusReq(
    cfg.reqFields.map(f => f.name -> f.gen)
  )
  val resp = new SimpleBusResp(
    cfg.respFields.map(f => f.name -> f.gen)
  )
}

/* =========================================================
 * Example Config
 * ========================================================= */

object BusConfigs {
  val full = SimpleBusConfig(
    reqFields = Seq(
      BusField("addr",  UInt(32.W)),
      BusField("wdata", UInt(64.W)),
      BusField("write", Bool()),
      BusField("mask",  UInt(8.W))
    ),
    respFields = Seq(
      BusField("rdata", UInt(64.W)),
      BusField("error", Bool())
    )
  )
  val lite = SimpleBusConfig(
    reqFields = Seq(
      BusField("addr", UInt(32.W))
    ),
    respFields = Seq(
      BusField("rdata", UInt(32.W))
    )
  )
}

/* =========================================================
 * Usage
 * ========================================================= */

class Master extends Module {
  val io = IO(new Bundle {
    val bus = new SimpleBus(BusConfigs.full)
  })

  io.bus.req.valid := true.B
  io.bus.resp.ready := true.B
  io.bus.req.addr  := 0x1000.U
  io.bus.req.wdata := 0x1234.U
  io.bus.req.write := true.B
  when(io.bus.resp.valid) {
    printf("%x\n", io.bus.resp.rdata)
  }
}
