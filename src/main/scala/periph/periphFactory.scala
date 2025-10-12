package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.com.uart.{UartCtrlGenerics}
import spinal.lib.io.{TriStateArray}
import scala.collection.mutable.ArrayBuffer

/** 外设配置类型 */
object PeriphType extends SpinalEnum {
  val GPIO, UART, I2C, SPI, TIM, WDG, SYSTICK, AFIO, EXTI = newElement()
}

/** 单类外设组配置 */
case class PeriphArrayConfig(
  tpye: PeriphType.E,
  count: Int = 1,
  base: BigInt = 0x0,
  space: BigInt = 0x0,
  pinMap: Seq[Map[String, Int]] = Nil
)

/** SoC 总外设配置表 */
case class PeriphConfig(arrays: Seq[PeriphArrayConfig])

class PeriphFactory(cfg: PeriphConfig, apb: Apb3, afio: TriStateArray) extends Area {
  val slaves = ArrayBuffer[(Apb3, SizeMapping)]()
  val interrupts = ArrayBuffer[(Int, Bool)]()

  afio.write := B(0, afio.width bits)
  afio.writeEnable := B(0, afio.width bits)

  for (arr <- cfg.arrays) {
    arr.tpye match {
      // ---------------- UART ----------------
      case PeriphType.UART =>
        val uartArray = Apb3UartArray(
          uartCnt = arr.count,
          uartSpace = arr.space,
          uartConfig = Apb3UartCtrlConfig(
            uartCtrlGenerics = UartCtrlGenerics(
              dataWidthMax = 9,
              clockDividerWidth = 20,
              preSamplingSize = 1,
              samplingSize = 3,
              postSamplingSize = 1
            ),
            txFifoDepth = 16,
            rxFifoDepth = 16
          )
        )
        slaves += uartArray.io.apb -> (arr.base, arr.space * arr.count)
        interrupts += 0 -> uartArray.io.interrupt.asBits.orR
        for ((pins, idx) <- arr.pinMap.zipWithIndex) {
          pins.get("txd").foreach( pin => afio.write(pin) := uartArray.io.uarts(idx).txd )
          pins.get("rxd").foreach( pin => uartArray.io.uarts(idx).rxd := afio.read(pin) )
        }

      // ---------------- I2C ----------------
      case PeriphType.I2C =>
        val i2cArray = Apb3I2cArray(arr.count, arr.space)
        slaves += i2cArray.io.apb -> (arr.base, arr.space * arr.count)
        interrupts += 1 -> i2cArray.io.interrupt.asBits.orR
        for ((pins, idx) <- arr.pinMap.zipWithIndex) {
          pins.get("scl").foreach( pin => afio.write(pin) := i2cArray.io.i2cs(idx).scl )
          pins.get("sda").foreach { pin =>
            afio.write(pin) := i2cArray.io.i2cs(idx).sda.write.asBool
            i2cArray.io.i2cs(idx).sda.read := afio.read(pin).asBits
          }
        }

      // ---------------- SPI ----------------
      case PeriphType.SPI =>
        val spiArray = Apb3SpiArray(arr.count, arr.space)
        slaves += spiArray.io.apb -> (arr.base, arr.space * arr.count)
        interrupts += 2 -> spiArray.io.interrupt.asBits.orR
        for ((pins, idx) <- arr.pinMap.zipWithIndex) {
          pins.get("sclk").foreach( pin => afio.write(pin) := spiArray.io.spis(idx).sclk )
          pins.get("mosi").foreach( pin => afio.write(pin) := spiArray.io.spis(idx).mosi )
          pins.get("ss").foreach( pin => afio.write(pin) := spiArray.io.spis(idx).ss )
          pins.get("miso").foreach( pin => spiArray.io.spis(idx).miso := afio.read(pin) )
        }

      // ---------------- TIM ----------------
      case PeriphType.TIM =>
        val timArray = Apb3TimArray(arr.count, arr.space)
        slaves += timArray.io.apb -> (arr.base, arr.space * arr.count)
        interrupts += 2 -> timArray.io.interrupt.asBits.orR
        for ((pins, idx) <- arr.pinMap.zipWithIndex) {
          pins.get("ch0").foreach( pin => afio.write(pin) := timArray.io.ch(0) )
          pins.get("ch1").foreach( pin => afio.write(pin) := timArray.io.ch(1) )
          pins.get("ch2").foreach( pin => afio.write(pin) := timArray.io.ch(2) )
          pins.get("ch3").foreach( pin => afio.write(pin) := timArray.io.ch(3) )
        }

      // ---------------- WDG ----------------
      case PeriphType.WDG =>
        val wdg = Apb3Wdg()
        slaves += wdg.io.apb -> (arr.base, arr.space * arr.count)

      // ---------------- SYSTICK ----------------
      case PeriphType.SYSTICK =>
        val systick = Apb3SysTick()
        slaves += systick.io.apb -> (arr.base, arr.space * arr.count)
        interrupts += 1 -> systick.io.interrupt

      case _ =>
        SpinalWarning(s"Unsupported peripheral tpye: ${arr.tpye}")
    }
  }

  // 自动 APB 解码
  val apbDecoder = Apb3Decoder(master = apb, slaves = slaves.toList)
  // 中断合并
  val interruptCount = if (interrupts.isEmpty) 0 else interrupts.map(_._1).max + 1
  val interruptLines = interrupts.foldLeft(B(interruptCount bits, default -> False)) {
    case (vector, (index, signal)) => vector(index) := signal; vector
  }
}
