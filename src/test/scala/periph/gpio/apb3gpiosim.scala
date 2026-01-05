// import scala.util.Random
// import spinal.core._
// import spinal.core.sim._
// import spinal.lib.bus.amba3.apb.sim._
// import spinal.lib.io.InOutWrapper
// import periph.gpio._

// object apb3gpiosim {
//   def main(args: Array[String]): Unit = {
//     SimConfig.withWave
//       .workspacePath("sim")
//       .compile {
//         val dut = apb3gpio()
//         InOutWrapper(dut)
//       }
//       .doSim { dut =>
//         // 初始化
//         dut.clockDomain.forkStimulus(10)

//         // 模拟APB主机
//         val apbCtrl = Apb3Driver(dut.io.apb, dut.clockDomain)

//         // 写ODR = 0xAAAA
//         apbCtrl.write(0x0c, 0xaaaa)
//         dut.clockDomain.waitSampling()

//         // 写BSRR = 0x000F （置位低4位）
//         apbCtrl.write(0x10, 0x000f)
//         dut.clockDomain.waitSampling()

//         // 写BRR = 0x00F0 （复位位4~7）
//         apbCtrl.write(0x14, 0x00f0)
//         dut.clockDomain.waitSampling()

//         // 读IDR（GPIO输入）
//         val inputVal = apbCtrl.read(0x00)
//         println(f"GPIO Input Value: 0x$inputVal%04X")

//         // 结束仿真
//         simSuccess()
//       }
//   }
// }
