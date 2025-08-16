// package periph

// import spinal.core._
// import spinal.lib._
// import spinal.lib.bus.amba3.apb._
// import spinal.lib.bus.misc.SizeMapping

// object Apb3Crc {
//   def apb3Config(addressWidth: Int, dataWidth: Int) =
//     Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
// }

// case class Apb3Crc(
//     addressWidth: Int = 7,
//     dataWidth: Int = 32,
//     polynomialWidth: Int = 32
// ) extends Component {
//   val io = new Bundle {
//     val apb = slave(Apb3(Apb3Crc.apb3Config(addressWidth, dataWidth)))
//     val interrupt = out(Bool())
//   }

//   val ctrl = Apb3SlaveFactory(io.apb)

//   def Reg32Init(value: Int = 0) = Reg(UInt(32 bits)) init (value)

//   // 寄存器定义 - 按照STM32 CRC寄存器布局
//   val DR = Reg32Init()    // 数据寄存器
//   val IDR = Reg32Init()   // 独立数据寄存器
//   val CR = Reg32Init()    // 控制寄存器
//   val INIT = Reg32Init()  // 初始值寄存器
//   val POL = Reg32Init()   // 多项式寄存器

//   // CR位域解析
//   val RESET = CR(0)       // 复位位
//   val POLYSIZE = CR(4 downto 3) // 多项式大小
//   val REV_IN = CR(6 downto 5)   // 输入数据反转
//   val REV_OUT = CR(7)     // 输出数据反转

//   // CRC计算引擎
//   val crcEngine = new Area {
//     val crcReg = Reg(UInt(polynomialWidth bits)) init(INIT)
//     val dataIn = Reg(Bits(dataWidth bits)) init(0)
//     val polynomial = Reg(UInt(polynomialWidth bits)) init(POL)
    
//     // 根据配置选择多项式大小
//     val polySize = Mux(POLYSIZE === 0, 7, Mux(POLYSIZE === 1, 8, Mux(POLYSIZE === 2, 16, 32)))
    
//     // 输入数据反转
//     val reversedInput = Mux(REV_IN === 0, dataIn, 
//                            Mux(REV_IN === 1, dataIn(7 downto 0) ## dataIn(15 downto 8) ## dataIn(23 downto 16) ## dataIn(31 downto 24),
//                                dataIn(3 downto 0) ## dataIn(7 downto 4) ## dataIn(11 downto 8) ## dataIn(15 downto 12) ##
//                                dataIn(19 downto 16) ## dataIn(23 downto 20) ## dataIn(27 downto 24) ## dataIn(31 downto 28)))
    
//     // CRC计算逻辑
//     val nextCrc = Reg(UInt(polynomialWidth bits)) init(0)
    
//     // 32位CRC计算
//     when(polySize === 32) {
//       val temp = crcReg ^ reversedInput.asUInt
//       for(i <- 0 until 32) {
//         when(i === 0) {
//           nextCrc := Mux(temp(31), (temp << 1) ^ polynomial, temp << 1)
//         }.otherwise {
//           nextCrc := Mux(nextCrc(31), (nextCrc << 1) ^ polynomial, nextCrc << 1)
//         }
//       }
//     }
    
//     // 16位CRC计算
//     .elsewhen(polySize === 16) {
//       val temp = crcReg(15 downto 0) ^ reversedInput(15 downto 0).asUInt
//       for(i <- 0 until 16) {
//         when(i === 0) {
//           nextCrc := Mux(temp(15), (temp << 1) ^ polynomial(15 downto 0), temp << 1)
//         }.otherwise {
//           nextCrc := Mux(nextCrc(15), (nextCrc << 1) ^ polynomial(15 downto 0), nextCrc << 1)
//         }
//       }
//     }
    
//     // 8位CRC计算
//     .elsewhen(polySize === 8) {
//       val temp = crcReg(7 downto 0) ^ reversedInput(7 downto 0).asUInt
//       for(i <- 0 until 8) {
//         when(i === 0) {
//           nextCrc := Mux(temp(7), (temp << 1) ^ polynomial(7 downto 0), temp << 1)
//         }.otherwise {
//           nextCrc := Mux(nextCrc(7), (nextCrc << 1) ^ polynomial(7 downto 0), nextCrc << 1)
//         }
//       }
//     }
    
//     // 7位CRC计算
//     .otherwise {
//       val temp = crcReg(6 downto 0) ^ reversedInput(6 downto 0).asUInt
//       for(i <- 0 until 7) {
//         when(i === 0) {
//           nextCrc := Mux(temp(6), (temp << 1) ^ polynomial(6 downto 0), temp << 1)
//         }.otherwise {
//           nextCrc := Mux(nextCrc(6), (nextCrc << 1) ^ polynomial(6 downto 0), nextCrc << 1)
//         }
//       }
//     }
    
//     // 输出数据反转
//     val finalCrc = Mux(REV_OUT, 
//                       nextCrc(0) ## nextCrc(1) ## nextCrc(2) ## nextCrc(3) ## nextCrc(4) ## nextCrc(5) ## nextCrc(6) ## nextCrc(7) ##
//                       nextCrc(8) ## nextCrc(9) ## nextCrc(10) ## nextCrc(11) ## nextCrc(12) ## nextCrc(13) ## nextCrc(14) ## nextCrc(15) ##
//                       nextCrc(16) ## nextCrc(17) ## nextCrc(18) ## nextCrc(19) ## nextCrc(20) ## nextCrc(21) ## nextCrc(22) ## nextCrc(23) ##
//                       nextCrc(24) ## nextCrc(25) ## nextCrc(26) ## nextCrc(27) ## nextCrc(28) ## nextCrc(29) ## nextCrc(30) ## nextCrc(31),
//                       nextCrc)
    
//     // 更新CRC寄存器
//     when(RESET) {
//       crcReg := INIT
//     }.otherwise {
//       crcReg := finalCrc
//     }
    
//     // 更新DR寄存器
//     DR := finalCrc
//   }

//   // 中断生成（CRC计算完成）
//   val crcCompleteInterrupt = Reg(Bool()) init(False)
//   io.interrupt := crcCompleteInterrupt

//   // APB寄存器映射
//   ctrl.readAndWrite(DR, 0x00)
//   ctrl.readAndWrite(IDR, 0x04)
//   ctrl.readAndWrite(CR, 0x08)
//   ctrl.readAndWrite(INIT, 0x10)
//   ctrl.readAndWrite(POL, 0x14)

//   // 当写入DR时触发CRC计算
//   ctrl.onWrite(0x00) {
//     crcEngine.dataIn := io.apb.PWDATA.asBits
//     crcCompleteInterrupt := True
//   }

//   // 当读取DR时清除中断
//   ctrl.onRead(0x00) {
//     crcCompleteInterrupt := False
//   }
// }

// // CRC计算示例
// object CrcExample {
//   def main(args: Array[String]) {
//     // 生成Verilog
//     SpinalConfig(
//       targetDirectory = "rtl",
//       defaultConfigForClockDomains = ClockDomainConfig(
//         resetKind = BOOT
//       )
//     ).generateVerilog(new Apb3Crc())
//   }
// }
