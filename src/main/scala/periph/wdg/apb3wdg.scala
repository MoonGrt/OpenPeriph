package periph.wdg

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping

case class Apb3Iwdg(addressWidth: Int = 4, dataWidth: Int = 32)
    extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth, dataWidth)))
    val rst = out Bool () // 外部复位输出（例如连接系统复位）
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // --- IWDG 关键寄存器 ---
  // val KR = Reg(UInt(32 bits)) init (0)
  val PR = Reg(UInt(3 bits)) init (0)
  val RLR = Reg(UInt(12 bits)) init (0xfff)
  val SR = Reg(Bits(3 bits)) init (B"000")

  // --- 控制状态位 ---
  val enable = RegInit(False)

  // --- KR 写入口 ---
  ctrl.onWrite(0x00) {
    // KR := io.apb.PWDATA.asUInt
    switch(io.apb.PWDATA.asUInt) {
      is(U"32'h0000CCCC") {
        enable := True
      }
      is(U"32'h0000AAAA") {
        counter := RLR
      }
      is(U"32'h00005555") {
        SR := B"011" // 设置 PVU 和 RVU
      }
    }
  }

  // --- PR 写 ---
  ctrl.onWrite(0x04) {
    when(SR(0)) {
      PR := io.apb.PWDATA(2 downto 0).asUInt
      SR(0) := False // 写完清除 PVU
    }
  }
  ctrl.read(PR.resize(32), 0x04)

  // --- RLR 写 ---
  ctrl.onWrite(0x08) {
    when(SR(1)) {
      RLR := io.apb.PWDATA(11 downto 0).asUInt
      SR(1) := False // 写完清除 RVU
    }
  }
  ctrl.read(RLR.resize(32), 0x08)

  // --- SR 读 ---
  ctrl.read(SR.resize(32).asUInt, 0x0c)

  // --- 看门狗逻辑 ---
  val rstReg = RegInit(False)
  io.rst := rstReg
  val counter = Reg(UInt(12 bits)) init (0)
  val prescalerCounter = Reg(UInt(8 bits)) init (0)
  val prescalerMax = (U(1, 8 bits) |<< (PR + 2)) - 1 // 预分频器最大值
  val tick = prescalerCounter === prescalerMax
  when(enable) {
    // 分频器
    prescalerCounter := prescalerCounter + 1
    when(tick) {
      prescalerCounter := 0
      when(counter === 0) { // 倒计时逻辑
        rstReg := True
      } otherwise {
        counter := counter - 1
        rstReg := False
      }
    }
  } otherwise {
    prescalerCounter := 0
    rstReg := False
  }
}

case class Apb3Wwdg() extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth = 5, dataWidth = 32)))
    val rst = out Bool ()
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // --- WWDG 关键寄存器 ---
  val CR = Reg(UInt(8 bits)) init (0)
  val CFR = Reg(UInt(16 bits)) init (0)
  val SR = Reg(UInt(32 bits)) init (0)

  // --- 控制状态位 ---
  val WDGA = CR(7) === True
  val W = CFR(6 downto 0)
  val EWI = CFR(9)
  val EWIF = RegInit(False)
  val WDGTB = CFR(8 downto 7)

  // --- APB 写入口 ---
  ctrl.onWrite(0x00) {
    val newCount = io.apb.PWDATA(6 downto 0).asUInt
    val newWDGA = io.apb.PWDATA(7).asUInt
    // 只允许设置 WDGA，禁止清除
    CR := (CR & U"8'h80") | U(B(0, 1 bits) ## newCount) | U(newWDGA ## B(0, 7 bits))
    // 仅当写入值小于窗口值时允许重新装载计数器，并清除中断
    when(newCount < W) {
      counter := newCount
      EWIF := False
    }
  }
  ctrl.readAndWrite(CFR, 0x04)
  ctrl.readAndWrite(SR, 0x08)

  // 生成状态寄存器SR，31位0 + 1位EWIF
  SR := (EWIF.asBits ## B(0, 31 bits)).asUInt

  // --- 看门狗逻辑 ---
  val rstReg = RegInit(False)
  io.rst := rstReg
  val counter = Reg(UInt(7 bits)) init (0x7f)
  val prescalerMax = (U(4096, 15 bits) |<< WDGTB).resize(15) - 1
  val prescalerCounter = Reg(UInt(15 bits)) init (0)
  val tick = prescalerCounter === prescalerMax
  when(WDGA) {
    // 分频器
    prescalerCounter := prescalerCounter + 1
    when(tick) {
      prescalerCounter := 0
      when(counter === 0) { // 倒计时逻辑
        rstReg := True
      } otherwise {
        counter := counter - 1
        rstReg := False
      }
    } 
  }otherwise {
      prescalerCounter := 0
      rstReg := False
  }
}

case class Apb3Wdg(memSize: Int = 0x400) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth = 13, dataWidth = 32)))
    val iwdgRst = out Bool ()
    val wwdgRst = out Bool ()
  }

  // 实例化子模块
  val iwdg = Apb3Iwdg()
  val wwdg = Apb3Wwdg()

  // 使用 Apb3Decoder 创建解码器并映射地址空间
  val decoder = Apb3Decoder(
    master = io.apb,
    slaves = List(
      iwdg.io.apb -> SizeMapping(0x0000, memSize),
      wwdg.io.apb -> SizeMapping(memSize, memSize)
    )
  )

  // 连接复位输出（确保模块接口名为 resetOut）
  io.iwdgRst := iwdg.io.rst
  io.wwdgRst := wwdg.io.rst
}

// object Apb3WwdgGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3Wwdg())
//   }
// }

// object Apb3IwdgGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3Iwdg())
//   }
// }

object Apb3WdgGen {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3Wdg())
  }
}
