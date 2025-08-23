package misc

import spinal.core._
import scala.io.Source
import java.io.{File, FileInputStream}

object MemTools {
  // -------------------------------
  // File Loador
  // -------------------------------
  // Raw HEX (Intel HEX Format)
  def loadRawHexFile(path: String, wordSize: Int, bigEndian: Boolean, hexOffset: BigInt, wordCount: Int, allowOverflow: Boolean): Array[BigInt] = {
    def hToI(that: String, start: Int, size: Int) = Integer.parseInt(that.substring(start, start + size), 16)
    val tmp = Array.fill[BigInt](wordCount)(0)
    var offset = 0
    for (line <- Source.fromFile(path).getLines) {
      if (line.charAt(0) == ':') {
        val byteCount = hToI(line, 1, 2)
        val nextAddr = hToI(line, 3, 4) + offset
        val key = hToI(line, 7, 2)
        key match {
          case 0 =>
            for (i <- 0 until byteCount) {
              val address = nextAddr + i
              val addressWithoutOffset = ((address.toLong & 0xffffffffL) - hexOffset).toLong
              val addressWord = addressWithoutOffset / wordSize
              if (addressWord < 0 || addressWord >= tmp.size) {
                assert(allowOverflow)
              } else {
                tmp(addressWord.toInt) |= BigInt(hToI(line, 9 + i * 2, 2)) << ((addressWithoutOffset.toInt % wordSize) * 8)
              }
            }
          case 2 => offset = hToI(line, 9, 4) << 4
          case 4 => offset = hToI(line, 9, 4) << 16
          case 3 =>
          case 5 =>
          case 1 =>
        }
      }
    }
    tmp
  }

  // 2. Raw BIN (Real binary file)
  def loadRawBinFile(path: String, wordSize: Int = 4, bigEndian: Boolean = false): Array[BigInt] = {
    val file = new File(path)
    val fis = new FileInputStream(file)
    val bytes = new Array[Byte](file.length.toInt)
    fis.read(bytes)
    fis.close()
    bytes.grouped(wordSize)
      .map { group =>
        val ordered = if (bigEndian) group.reverse else group
        ordered.zipWithIndex.map { case (b, i) =>(BigInt(b & 0xff) << (8 * i))}.reduce(_ | _)
      }.toArray
  }

  // 3. Processed HEX (One 32-bit hexadecimal number per line)
  def loadProcessedHexFile(path: String, wordSize: Int = 4, bigEndian: Boolean = false): Array[BigInt] = {
    Source.fromFile(path).getLines().filter(_.nonEmpty)
      .map { line =>
        val value = BigInt(line.trim, 16)
        reorderBytes(value, wordSize, bigEndian)
      }.toArray
  }

  // 4. Processed BIN (One 32-bit binary string per line)
  def loadProcessedBinFile(path: String, wordSize: Int = 4, bigEndian: Boolean = false): Array[BigInt] = {
    Source.fromFile(path).getLines().filter(_.nonEmpty)
      .map { line =>
        val value = BigInt(line.trim, 2)
        reorderBytes(value, wordSize, bigEndian)
      }.toArray
  }

  // 5. Processed DEC (One unsigned decimal number per line)
  def loadProcessedDecFile(
      path: String,
      wordSize: Int = 4,
      bigEndian: Boolean = false
  ): Array[BigInt] = {
    Source.fromFile(path).getLines().filter(_.nonEmpty)
      .map { line =>
        val value = BigInt(line.trim, 10)  // 无符号十进制
        reorderBytes(value, wordSize, bigEndian)
      }.toArray
  }

  // 6. Processed SDEC (One signed decimal number per line)
  def loadProcessedSignedDecFile(
      path: String,
      wordSize: Int = 4,
      bigEndian: Boolean = false
  ): Array[BigInt] = {
    Source.fromFile(path).getLines().filter(_.nonEmpty)
      .map { line =>
        val value = BigInt(line.trim)  // 带符号十进制（BigInt会识别负号）
        reorderBytes(value, wordSize, bigEndian)
      }.toArray
  }

  // -------------------------------
  // Auxiliary function
  // -------------------------------
  // Rearrange by byte order
  private def reorderBytes(value: BigInt, wordSize: Int, bigEndian: Boolean): BigInt = {
    val bytes = (0 until wordSize).map(i => ((value >> (8 * i)) & 0xff).toInt.toByte).toArray
    val ordered = if (bigEndian) bytes else bytes.reverse
    ordered.zipWithIndex.map { case (b, i) =>(BigInt(b & 0xff) << (8 * i))}.reduce(_ | _)
  }
  // Pad or truncate to wordCount
  private def padArray(raw: Array[BigInt], wordCount: Int): Array[BigInt] = {
    val padded = Array.fill[BigInt](wordCount)(BigInt(0))
    Array.copy(raw, 0, padded, 0, math.min(raw.length, wordCount))
    padded
  }

  // -------------------------------
  // General initialization function
  // -------------------------------
  def initMem[T <: Data](
      ram: Mem[T],
      file: String,
      memFileType: String = "rawhex",
      bigEndian: Boolean = true,
      hexOffset: BigInt = 0,
      allowOverflow: Boolean = false
  ): Unit = {
    val wordSize = ram.wordType.getBitsWidth / 8
    val initContent = memFileType match {
      case "rawhex" => // raw hex file
        val raw = loadRawHexFile(file, wordSize, bigEndian, hexOffset, ram.wordCount, allowOverflow)
        padArray(raw, ram.wordCount)
      case "rawbin" => // raw binary file
        val raw = loadRawBinFile(file, wordSize, bigEndian)
        padArray(raw, ram.wordCount)
      case "hex" => // processed hex
        val raw = loadProcessedHexFile(file, wordSize, bigEndian)
        padArray(raw, ram.wordCount)
      case "bin" => // processed bin
        val raw = loadProcessedBinFile(file, wordSize, bigEndian)
        padArray(raw, ram.wordCount)
      case "dec" => // processed unsigned decimal
        val raw = loadProcessedDecFile(file, wordSize, bigEndian)
        padArray(raw, ram.wordCount)
      case "sdec" => // processed signed decimal
        val raw = loadProcessedSignedDecFile(file, wordSize, bigEndian)
        padArray(raw, ram.wordCount)
      case _ =>
        throw new IllegalArgumentException(s"Unsupported file type: $memFileType")
    }
    ram.initBigInt(initContent)
  }
}
