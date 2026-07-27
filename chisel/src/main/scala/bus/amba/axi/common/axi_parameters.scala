package bus.amba.axi.common

import scala.math.max

/**
  * RocketChip-style typed key with default value.
  */
abstract class AxiField[T](val default: T)

/**
  * Read-only key/value view for AXI parameters.
  */
trait AxiView {
  def apply[T](key: AxiField[T]): T
}

/**
  * RocketChip-like parameter chain, scoped to bus/axi only.
  */
sealed trait AxiParameters extends AxiView { self =>
  protected def entries: List[AxiParameters.Entry]

  override final def apply[T](key: AxiField[T]): T =
    AxiParameters.lookup(key, self, entries).asInstanceOf[T]

  final def alter(f: AxiParameters.Lookup): AxiParameters =
    AxiParameters.Chain(AxiParameters.Entry(f) :: entries)

  final def ++(tail: AxiParameters): AxiParameters =
    AxiParameters.Chain(entries ++ tail.entries)
}

object AxiParameters {
  type Lookup = (AxiView, AxiView, AxiView) => PartialFunction[AxiField[_], Any]
  final case class Entry(f: Lookup)
  final case class Chain(protected val entries: List[Entry]) extends AxiParameters

  val empty: AxiParameters = Chain(Nil)

  def apply(f: Lookup): AxiParameters = Chain(List(Entry(f)))

  private def mkView(site: AxiParameters, chain: List[Entry]): AxiView = new AxiView {
    override def apply[T](key: AxiField[T]): T =
      lookup(key, site, chain).asInstanceOf[T]
  }

  private def lookup(key: AxiField[_], site: AxiParameters, chain: List[Entry]): Any = chain match {
    case Entry(f) :: tail =>
      val here = mkView(site, chain)
      val up   = mkView(site, tail)
      val pf   = f(site, here, up)
      if (pf.isDefinedAt(key)) pf(key) else lookup(key, site, tail)
    case Nil =>
      key.default
  }
}

abstract class AxiConfig(f: AxiParameters.Lookup) extends AxiParameters {
  override protected val entries: List[AxiParameters.Entry] = List(AxiParameters.Entry(f))
}

/** Parameters for AXI4-Lite. */
case class AxiLiteParams(
  addrBits: Int = 32,
  dataBits: Int = 32,
) {
  require(addrBits > 0 && dataBits >= 8 && dataBits % 8 == 0)
  def strobeBits: Int = dataBits / 8
}

/** Parameters for full AXI4 bundle widths. */
case class AxiParams(
  addrBits: Int = 32,
  dataBits: Int = 32,
  idBits: Int = 4,
  awUserBits: Int = 0,
  wUserBits: Int = 0,
  bUserBits: Int = 0,
  rUserBits: Int = 0,
) {
  require(dataBits % 8 == 0)
  require(idBits > 0)
  require(awUserBits >= 0 && wUserBits >= 0 && bUserBits >= 0 && rUserBits >= 0)
  def strobeBits: Int = dataBits / 8
}

object AXI4Parameters {
  val lenBits   = 8
  val sizeBits  = 3
  val burstBits = 2
  val lockBits  = 1
  val cacheBits = 4
  val protBits  = 3
  val qosBits   = 4
  val respBits  = 2
}

object RegionType extends Enumeration {
  type T = Value
  val GET_EFFECTS, UNCACHED, TRACKED, CACHED = Value
}

object AxiMath {
  def isPow2(x: Int): Boolean = x > 0 && ((x & (x - 1)) == 0)
  def log2Up(x: BigInt): Int = {
    require(x > 0)
    (x - 1).bitLength
  }
}

/** Minimal AddressSet compatible with AXI parameter checks. */
case class AddressSet(base: BigInt, mask: BigInt) {
  // Forbid misaligned base address (and empty sets)
  require ((base & mask) == 0, s"Mis-aligned AddressSets are forbidden, got: ${this.toString}")
  require (base >= 0, s"AddressSet negative base is ambiguous: $base")

  // overlap iff bitwise: both care (~mask0 & ~mask1) => both equal (base0=base1)
  def overlaps(x: AddressSet) = (~(mask | x.mask) & (base ^ x.base)) == 0
  // contains iff bitwise: x.mask => mask && contains(x.base)
  def contains(x: AddressSet) = ((x.mask | (base ^ x.base)) & ~mask) == 0

  // The number of bytes to which the manager must be aligned
  def alignment = ((mask + 1) & ~mask)
  // Is this a contiguous memory range
  def contiguous = alignment == mask+1

  def finite = mask >= 0
  def max = { require (finite, "Max cannot be calculated on infinite mask"); base | mask }
}

case class TransferSizes(min: Int, max: Int) {
  require(min >= 0 && max >= min)
}
object TransferSizes {
  val none: TransferSizes = TransferSizes(0, 0)
}

case class IdRange(start: Int, end: Int) {
  require(start >= 0 && end > start, s"invalid IdRange($start, $end)")
  def size: Int = end - start
  def overlaps(x: IdRange): Boolean = !(end <= x.start || x.end <= start)
}
object IdRange {
  def overlaps(xs: Seq[IdRange]): Seq[(IdRange, IdRange)] = {
    for {
      i <- xs.indices
      j <- (i + 1) until xs.length
      if xs(i).overlaps(xs(j))
    } yield (xs(i), xs(j))
  }
}

trait BundleKeyBase { def isControl: Boolean = true }
trait BundleFieldBase { def key: BundleKeyBase }

object BundleField {
  def union(fields: Seq[BundleFieldBase]): Seq[BundleFieldBase] = {
    fields.foldLeft(Seq.empty[BundleFieldBase]) { case (acc, f) =>
      if (acc.exists(_.key == f.key)) acc else acc :+ f
    }
  }

  def accept(fields: Seq[BundleFieldBase], keys: Seq[BundleKeyBase]): Seq[BundleFieldBase] =
    fields.filter(f => keys.exists(_ == f.key))
}

case class BufferParams(depth: Int = 0, flow: Boolean = false, pipe: Boolean = false) {
  require(depth >= 0)
}
object BufferParams {
  val none: BufferParams = BufferParams()
}

trait DirectedBuffers[T] {
  def copyIn(x: BufferParams): T
  def copyOut(x: BufferParams): T
  def copyInOut(x: BufferParams): T
}

/** Minimal async queue parameters (lightweight stand-in). */
case class AsyncQueueParams(depth: Int = 8, sync: Int = 3) {
  require(depth > 0 && sync > 0)
}

/** Minimal credited delay model (lightweight stand-in). */
case class CreditedDelay(cycles: Int, creditReturnCycles: Int = 0) {
  require(cycles >= 0 && creditReturnCycles >= 0)
  def +(that: CreditedDelay): CreditedDelay =
    CreditedDelay(cycles + that.cycles, creditReturnCycles + that.creditReturnCycles)
  def flip: CreditedDelay = CreditedDelay(creditReturnCycles, cycles)
}

trait IdMapEntry {
  def from: IdRange
  def to: IdRange
  def isCache: Boolean
  def requestFifo: Boolean
}

abstract class IdMap[T <: IdMapEntry] {
  val mapping: Seq[T]
}

case class AXI4SlaveParameters(
  address:       Seq[AddressSet],
  regionType:    RegionType.T  = RegionType.GET_EFFECTS,
  executable:    Boolean       = false,
  nodePath:      Seq[String]   = Seq(),
  supportsWrite: TransferSizes = TransferSizes.none,
  supportsRead:  TransferSizes = TransferSizes.none,
  interleavedId: Option[Int]   = None
) {
  address.foreach { a => require(a.finite) }
  address.combinations(2).foreach { case Seq(x, y) => require(!x.overlaps(y), s"$x and $y overlap") }

  val name: String = nodePath.lastOption.getOrElse("disconnected")
  val maxTransfer: Int = max(supportsWrite.max, supportsRead.max)
  val maxAddress: BigInt = address.map(_.max).max
  val minAlignment: BigInt = address.map(_.alignment).min

  require(minAlignment >= maxTransfer, s"minAlignment ($minAlignment) must be >= maxTransfer ($maxTransfer)")
}

case class AXI4SlavePortParameters(
  slaves:         Seq[AXI4SlaveParameters],
  beatBytes:      Int,
  minLatency:     Int = 1,
  responseFields: Seq[BundleFieldBase] = Nil,
  requestKeys:    Seq[BundleKeyBase]   = Nil
) {
  require(slaves.nonEmpty)
  require(AxiMath.isPow2(beatBytes), s"beatBytes must be power-of-two, got $beatBytes")

  val maxTransfer: Int = slaves.map(_.maxTransfer).max
  val maxAddress: BigInt = slaves.map(_.maxAddress).max

  require(maxTransfer >= beatBytes, s"maxTransfer ($maxTransfer) should not be smaller than bus width ($beatBytes)")
  val limit = beatBytes * (1 << AXI4Parameters.lenBits)
  require(maxTransfer <= limit, s"maxTransfer ($maxTransfer) cannot be larger than $limit on a $beatBytes*8 width bus")

  slaves.combinations(2).foreach { case Seq(x, y) =>
    x.address.foreach { a => y.address.foreach { b =>
      require(!a.overlaps(b), s"$a and $b overlap")
    }}
  }
}

case class AXI4MasterParameters(
  name:      String,
  id:        IdRange = IdRange(0, 1),
  aligned:   Boolean = false,
  maxFlight: Option[Int] = None,
  nodePath:  Seq[String] = Seq()
) {
  maxFlight.foreach(m => require(m >= 0))
}

case class AXI4MasterPortParameters(
  masters:        Seq[AXI4MasterParameters],
  echoFields:     Seq[BundleFieldBase] = Nil,
  requestFields:  Seq[BundleFieldBase] = Nil,
  responseKeys:   Seq[BundleKeyBase]   = Nil
) {
  require(masters.nonEmpty)
  val endId: Int = masters.map(_.id.end).max
  IdRange.overlaps(masters.map(_.id)).foreach { case (x, y) =>
    require(!x.overlaps(y), s"AXI4MasterParameters.id $x and $y overlap")
  }
}

case class AXI4BundleParameters(
  addrBits: Int,
  dataBits: Int,
  idBits:   Int,
  echoFields:     Seq[BundleFieldBase] = Nil,
  requestFields:  Seq[BundleFieldBase] = Nil,
  responseFields: Seq[BundleFieldBase] = Nil
) {
  require(dataBits >= 8, s"AXI4 data bits must be >= 8 (got $dataBits)")
  require(addrBits >= 1, s"AXI4 addr bits must be >= 1 (got $addrBits)")
  require(idBits >= 1, s"AXI4 id bits must be >= 1 (got $idBits)")
  require(AxiMath.isPow2(dataBits), s"AXI4 data bits must be pow2 (got $dataBits)")
  echoFields.foreach(f => require(f.key.isControl, s"$f is not a legal echo field"))

  val lenBits: Int   = AXI4Parameters.lenBits
  val sizeBits: Int  = AXI4Parameters.sizeBits
  val burstBits: Int = AXI4Parameters.burstBits
  val lockBits: Int  = AXI4Parameters.lockBits
  val cacheBits: Int = AXI4Parameters.cacheBits
  val protBits: Int  = AXI4Parameters.protBits
  val qosBits: Int   = AXI4Parameters.qosBits
  val respBits: Int  = AXI4Parameters.respBits

  def union(x: AXI4BundleParameters): AXI4BundleParameters =
    AXI4BundleParameters(
      max(addrBits, x.addrBits),
      max(dataBits, x.dataBits),
      max(idBits, x.idBits),
      BundleField.union(echoFields ++ x.echoFields),
      BundleField.union(requestFields ++ x.requestFields),
      BundleField.union(responseFields ++ x.responseFields)
    )

  def toAxiParams: AxiParams = AxiParams(addrBits = addrBits, dataBits = dataBits, idBits = idBits)
}

object AXI4BundleParameters {
  val emptyBundleParams: AXI4BundleParameters =
    AXI4BundleParameters(addrBits = 1, dataBits = 8, idBits = 1, echoFields = Nil, requestFields = Nil, responseFields = Nil)

  def union(x: Seq[AXI4BundleParameters]): AXI4BundleParameters =
    x.foldLeft(emptyBundleParams)((a, b) => a.union(b))

  def apply(master: AXI4MasterPortParameters, slave: AXI4SlavePortParameters): AXI4BundleParameters =
    new AXI4BundleParameters(
      addrBits = AxiMath.log2Up(slave.maxAddress + 1),
      dataBits = slave.beatBytes * 8,
      idBits   = max(1, AxiMath.log2Up(master.endId)),
      echoFields     = master.echoFields,
      requestFields  = BundleField.accept(master.requestFields, slave.requestKeys),
      responseFields = BundleField.accept(slave.responseFields, master.responseKeys)
    )
}

case class AXI4EdgeParameters(master: AXI4MasterPortParameters, slave: AXI4SlavePortParameters) {
  val bundle: AXI4BundleParameters = AXI4BundleParameters(master, slave)
}

case class AXI4AsyncSlavePortParameters(async: AsyncQueueParams, base: AXI4SlavePortParameters)
case class AXI4AsyncMasterPortParameters(base: AXI4MasterPortParameters)

case class AXI4AsyncBundleParameters(async: AsyncQueueParams, base: AXI4BundleParameters)
case class AXI4AsyncEdgeParameters(master: AXI4AsyncMasterPortParameters, slave: AXI4AsyncSlavePortParameters) {
  val bundle: AXI4AsyncBundleParameters =
    AXI4AsyncBundleParameters(slave.async, AXI4BundleParameters(master.base, slave.base))
}

case class AXI4BufferParams(
  aw: BufferParams = BufferParams.none,
  w:  BufferParams = BufferParams.none,
  b:  BufferParams = BufferParams.none,
  ar: BufferParams = BufferParams.none,
  r:  BufferParams = BufferParams.none
) extends DirectedBuffers[AXI4BufferParams] {
  def copyIn(x: BufferParams): AXI4BufferParams = copy(b = x, r = x)
  def copyOut(x: BufferParams): AXI4BufferParams = copy(aw = x, ar = x, w = x)
  def copyInOut(x: BufferParams): AXI4BufferParams = copyIn(x).copyOut(x)
}

case class AXI4CreditedDelay(
  aw: CreditedDelay,
  w:  CreditedDelay,
  b:  CreditedDelay,
  ar: CreditedDelay,
  r:  CreditedDelay
) {
  def +(that: AXI4CreditedDelay): AXI4CreditedDelay = AXI4CreditedDelay(
    aw = aw + that.aw,
    w  = w  + that.w,
    b  = b  + that.b,
    ar = ar + that.ar,
    r  = r  + that.r
  )
  override def toString: String = s"(${aw}, ${w}, ${b}, ${ar}, ${r})"
}

object AXI4CreditedDelay {
  def apply(delay: CreditedDelay): AXI4CreditedDelay =
    apply(delay, delay, delay.flip, delay, delay.flip)
}

case class AXI4CreditedSlavePortParameters(delay: AXI4CreditedDelay, base: AXI4SlavePortParameters)
case class AXI4CreditedMasterPortParameters(delay: AXI4CreditedDelay, base: AXI4MasterPortParameters)
case class AXI4CreditedEdgeParameters(master: AXI4CreditedMasterPortParameters, slave: AXI4CreditedSlavePortParameters) {
  val delay: AXI4CreditedDelay = master.delay + slave.delay
  val bundle: AXI4BundleParameters = AXI4BundleParameters(master.base, slave.base)
}

/** Pretty printing helper for AXI4 source ID maps. */
class AXI4IdMap(axi4: AXI4MasterPortParameters) extends IdMap[AXI4IdMapEntry] {
  private val sorted = axi4.masters.sortBy(_.id.start)

  val mapping: Seq[AXI4IdMapEntry] = sorted.map { m =>
    // Conservative estimate: AW and AR can both use the ID pool.
    val maxTransactionsInFlight = m.maxFlight.map(_ * m.id.size * 2)
    AXI4IdMapEntry(m.id, m.name, maxTransactionsInFlight)
  }
}

case class AXI4IdMapEntry(
  axi4Id: IdRange,
  name: String,
  maxTransactionsInFlight: Option[Int] = None
) extends IdMapEntry {
  val from: IdRange = axi4Id
  val to: IdRange = axi4Id
  val isCache: Boolean = false
  val requestFifo: Boolean = false
}

case object AxiLiteKey extends AxiField[AxiLiteParams](AxiLiteParams())
case object AxiKey extends AxiField[AxiParams](AxiParams())
case object AxiMasterPortKey extends AxiField[AXI4MasterPortParameters](
  AXI4MasterPortParameters(Seq(AXI4MasterParameters(name = "master0")))
)
case object AxiSlavePortKey extends AxiField[AXI4SlavePortParameters](
  AXI4SlavePortParameters(
    slaves = Seq(
      AXI4SlaveParameters(
        address = Seq(AddressSet(base = 0, mask = 0xffff)),
        supportsWrite = TransferSizes(1, 4),
        supportsRead = TransferSizes(1, 4)
      )
    ),
    beatBytes = 4
  )
)

object AxiLiteParams {
  def fromParameters(implicit p: AxiParameters): AxiLiteParams = p(AxiLiteKey)
}

object AxiParams {
  def fromParameters(implicit p: AxiParameters): AxiParams = p(AxiKey)
  def fromPortParameters(implicit p: AxiParameters): AxiParams = {
    val m = p(AxiMasterPortKey)
    val s = p(AxiSlavePortKey)
    AXI4BundleParameters(m, s).toAxiParams
  }
}

/** AXI-local base config with all AXI keys populated. */
class BaseAxiConfig extends AxiConfig((_, _, _) => {
  case AxiKey         => AxiParams()
  case AxiLiteKey     => AxiLiteParams()
  case AxiMasterPortKey =>
    AXI4MasterPortParameters(Seq(AXI4MasterParameters(name = "master0")))
  case AxiSlavePortKey =>
    AXI4SlavePortParameters(
      slaves = Seq(
        AXI4SlaveParameters(
          address = Seq(AddressSet(base = 0, mask = 0xffff)),
          supportsWrite = TransferSizes(1, 4),
          supportsRead = TransferSizes(1, 4)
        )
      ),
      beatBytes = 4
    )
})

class WithAxiBundle(addrBits: Int, dataBits: Int, idBits: Int) extends AxiConfig((_, _, up) => {
  case AxiKey => up(AxiKey).copy(addrBits = addrBits, dataBits = dataBits, idBits = idBits)
})

class WithAxiPorts(master: AXI4MasterPortParameters, slave: AXI4SlavePortParameters) extends AxiConfig((_, _, _) => {
  case AxiMasterPortKey => master
  case AxiSlavePortKey  => slave
  case AxiKey           => AXI4BundleParameters(master, slave).toAxiParams
})
