package periph.systick

import chisel3._
import freechips.rocketchip.amba.apb.{APBBundle, APBBundleParameters}
import periph.ApbPeripheral

class ApbSysTick(addressWidth: Int = 4, dataWidth: Int = 32, calibValue: Int = 1000)
    extends Module {
  val io = IO(new Bundle {
    val apb = Flipped(new APBBundle(APBBundleParameters(addressWidth, dataWidth)))
    val interrupt = Output(Bool())
  })

  ApbPeripheral.defaults(io.apb)
  val ctrl = RegInit(0.U(32.W))
  val load = RegInit(0.U(32.W))
  val value = RegInit(0.U(32.W))

  when(ApbPeripheral.write(io.apb, 0x00)) { ctrl := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x04)) { load := io.apb.pwdata }
  when(ApbPeripheral.write(io.apb, 0x08)) { value := io.apb.pwdata }

  when(ctrl(0)) {
    when(value === 0.U) { value := load }
      .otherwise {
        when(value === 1.U) { ctrl := ctrl.bitSet(16.U, true.B) }
        value := value - 1.U
      }
  }.otherwise {
    ctrl := ctrl.bitSet(16.U, false.B)
  }

  ApbPeripheral.readMux(io.apb, Seq(
    0x00 -> ctrl,
    0x04 -> load,
    0x08 -> value,
    0x0c -> calibValue.U(32.W)
  ))
  io.interrupt := ctrl(1) && ctrl(16)
}
