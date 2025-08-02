// Gowin DDR3 Interface

package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

case class DDR3_Interface() extends Bundle with IMasterSlave {
  val O_ddr_addr = Bits(14 bits)
  val O_ddr_ba = Bits(3 bits)
  val O_ddr_cs_n = Bool()
  val O_ddr_ras_n = Bool()
  val O_ddr_cas_n = Bool()
  val O_ddr_we_n = Bool()
  val O_ddr_clk = Bool()
  val O_ddr_clk_n = Bool()
  val O_ddr_cke = Bool()
  val O_ddr_odt = Bool()
  val O_ddr_reset_n = Bool()
  val O_ddr_dqm = Bits(2 bits)
  val IO_ddr_dq = Analog(Bits(16 bits))
  val IO_ddr_dqs = Analog(Bits(2 bits))
  val IO_ddr_dqs_n = Analog(Bits(2 bits))

  override def asMaster() : Unit = {
    out(O_ddr_addr, O_ddr_ba, O_ddr_cs_n, O_ddr_ras_n, O_ddr_cas_n, O_ddr_we_n, O_ddr_clk, O_ddr_clk_n, O_ddr_cke, O_ddr_odt, O_ddr_reset_n, O_ddr_dqm)
    inout(IO_ddr_dq, IO_ddr_dqs, IO_ddr_dqs_n)
  }
}

case class Gowin_DDR3(sysclk: ClockDomain, memclk: ClockDomain) extends BlackBox {
  val io = new Bundle {
    /*
    .memory_clk(memory_clk_i), //input memory_clk
		.clk(clk_i), //input clk
		.pll_lock(pll_lock_i), //input pll_lock
		.rst_n(rst_n_i), //input rst_n
		.app_burst_number(app_burst_number_i), //input [5:0] app_burst_number
		.cmd_ready(cmd_ready_o), //output cmd_ready
		.cmd(cmd_i), //input [2:0] cmd
		.cmd_en(cmd_en_i), //input cmd_en
		.addr(addr_i), //input [26:0] addr
		.wr_data_rdy(wr_data_rdy_o), //output wr_data_rdy
		.wr_data(wr_data_i), //input [127:0] wr_data
		.wr_data_en(wr_data_en_i), //input wr_data_en
		.wr_data_end(wr_data_end_i), //input wr_data_end
		.wr_data_mask(wr_data_mask_i), //input [15:0] wr_data_mask
		.rd_data(rd_data_o), //output [127:0] rd_data
		.rd_data_valid(rd_data_valid_o), //output rd_data_valid
		.rd_data_end(rd_data_end_o), //output rd_data_end
		.sr_req(sr_req_i), //input sr_req
		.ref_req(ref_req_i), //input ref_req
		.sr_ack(sr_ack_o), //output sr_ack
		.ref_ack(ref_ack_o), //output ref_ack
		.init_calib_complete(init_calib_complete_o), //output init_calib_complete
		.clk_out(clk_out_o), //output clk_out
		.ddr_rst(ddr_rst_o), //output ddr_rst
		.burst(burst_i), //input burst
		.O_ddr_addr(O_ddr_addr_o), //output [13:0] O_ddr_addr
		.O_ddr_ba(O_ddr_ba_o), //output [2:0] O_ddr_ba
		.O_ddr_cs_n(O_ddr_cs_n_o), //output O_ddr_cs_n
		.O_ddr_ras_n(O_ddr_ras_n_o), //output O_ddr_ras_n
		.O_ddr_cas_n(O_ddr_cas_n_o), //output O_ddr_cas_n
		.O_ddr_we_n(O_ddr_we_n_o), //output O_ddr_we_n
		.O_ddr_clk(O_ddr_clk_o), //output O_ddr_clk
		.O_ddr_clk_n(O_ddr_clk_n_o), //output O_ddr_clk_n
		.O_ddr_cke(O_ddr_cke_o), //output O_ddr_cke
		.O_ddr_odt(O_ddr_odt_o), //output O_ddr_odt
		.O_ddr_reset_n(O_ddr_reset_n_o), //output O_ddr_reset_n
		.O_ddr_dqm(O_ddr_dqm_o), //output [1:0] O_ddr_dqm
		.IO_ddr_dq(IO_ddr_dq_io), //inout [15:0] IO_ddr_dq
		.IO_ddr_dqs(IO_ddr_dqs_io), //inout [1:0] IO_ddr_dqs
		.IO_ddr_dqs_n(IO_ddr_dqs_n_io) //inout [1:0] IO_ddr_dqs_n
    */
    val memory_clk = in Bool ()
    val clk = in Bool ()
    val pll_lock = in Bool ()
    val rst_n = in Bool ()
    val app_burst_number = in UInt (6 bits)
    val cmd_ready = out Bool ()
    val cmd = in Bits (3 bits)
    val cmd_en = in Bool ()
    val addr = in UInt (28 bits)
    val wr_data_rdy = out Bool ()
    val wr_data = in Bits (128 bits)
    val wr_data_en = in Bool ()
    val wr_data_end = in Bool ()
    val wr_data_mask = in Bits (16 bits)
    val rd_data = out Bits (128 bits)
    val rd_data_valid = out Bool ()
    val rd_data_end = out Bool ()
    val sr_req = in Bool ()
    val ref_req = in Bool ()
    val sr_ack = out Bool ()
    val ref_ack = out Bool ()
    val init_calib_complete = out Bool ()
    val clk_out = out Bool ()
    val ddr_rst = out Bool ()
    val burst = in Bool ()

    val O_ddr_addr = out Bits (14 bits)
    val O_ddr_ba = out Bits (3 bits)
    val O_ddr_cs_n = out Bool ()
    val O_ddr_ras_n = out Bool ()
    val O_ddr_cas_n = out Bool ()
    val O_ddr_we_n = out Bool ()
    val O_ddr_clk = out Bool ()
    val O_ddr_clk_n = out Bool ()
    val O_ddr_cke = out Bool ()
    val O_ddr_odt = out Bool ()
    val O_ddr_reset_n = out Bool ()
    val O_ddr_dqm = out Bits (2 bits)
    val IO_ddr_dq = inout(Analog(Bits(16 bits)))
    val IO_ddr_dqs = inout(Analog(Bits(2 bits)))
    val IO_ddr_dqs_n = inout(Analog(Bits(2 bits)))
  }

  def connectDDR3Interface(iface: DDR3_Interface): Unit = {
    iface.O_ddr_addr := io.O_ddr_addr
    iface.O_ddr_ba := io.O_ddr_ba
    iface.O_ddr_cs_n := io.O_ddr_cs_n
    iface.O_ddr_ras_n := io.O_ddr_ras_n
    iface.O_ddr_cas_n := io.O_ddr_cas_n
    iface.O_ddr_we_n := io.O_ddr_we_n
    iface.O_ddr_clk := io.O_ddr_clk
    iface.O_ddr_clk_n := io.O_ddr_clk_n
    iface.O_ddr_cke := io.O_ddr_cke
    iface.O_ddr_odt := io.O_ddr_odt
    iface.O_ddr_reset_n := io.O_ddr_reset_n
    iface.O_ddr_dqm := io.O_ddr_dqm
    iface.IO_ddr_dq := io.IO_ddr_dq
    iface.IO_ddr_dqs := io.IO_ddr_dqs
    iface.IO_ddr_dqs_n := io.IO_ddr_dqs_n
  }

  noIoPrefix()
  mapClockDomain(sysclk, clock = io.clk, reset = io.rst_n, resetActiveLevel = LOW)
  mapClockDomain(memclk, clock = io.memory_clk)
  setDefinitionName("DDR3_Memory_Interface_Top")

  val clk_out = ClockDomain(
    clock = io.clk_out,
    reset = io.ddr_rst,
    config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = HIGH),
    frequency = FixedFrequency(200 MHz)
  )
}

object Axi4Ddr_CMDTYPE extends SpinalEnum {
  val read, write = newElement()
}

case class Axi4Ddr_PayloadCMD[T <: Data](
    addrlen: Int,
    burstlen: Int,
    contextType: T
) extends Bundle {
  val cmdtype = Axi4Ddr_CMDTYPE()
  val addr = UInt(addrlen bits)
  val burst_cnt = UInt(burstlen bits)
  val wr_data = Bits(128 bits)
  val wr_mask = Bits(16 bits)
  val context = cloneOf(contextType)
}

case class Axi4Ddr_PayloadRSP[T <: Data](contextType: T) extends Bundle {
  val rsp_data = Bits(128 bits)
  val context = cloneOf(contextType)
}

case class Axi4Ddr_Controller[T <: Data](
    sys_clk: ClockDomain,
    ddr_ref_clk: ClockDomain,
    addrlen: Int = 28,
    burstlen: Int = 6,
    fifo_length: Int = 32,
    contextType: T
) extends Component {
  val sys_clk_inst = sys_clk
  val ddr_ref_clk_inst = ddr_ref_clk

  val io = new Bundle() {
    val app_burst_number = out UInt (burstlen bits)
    val cmd_ready = in Bool ()
    val cmd = out Bits (3 bits)
    val cmd_en = out Bool ()
    val addr = out UInt (addrlen bits)
    val wr_data_rdy = in Bool ()
    val wr_data = out Bits (128 bits)
    val wr_data_en = out Bool ()
    // val wr_data_end = out Bool() // not use due to 1:4 mode
    val wr_data_mask = out Bits (16 bits)
    val rd_data = in Bits (128 bits)
    val rd_data_valid = in Bool ()
    // val rd_data_end = in Bool() // not use due to 1:4 mode
    val init_calib_complete = in Bool ()

    val ddr_cmd = slave(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType)))
    val ddr_rsp = master(Stream(Axi4Ddr_PayloadRSP(contextType)))
  }

  val cmd_fifo = new StreamFifoCC(
    dataType = Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType),
    depth = fifo_length,
    pushClock = sys_clk,
    popClock = ddr_ref_clk
  )

  val rsp_fifo = new StreamFifoCC(
    dataType = Axi4Ddr_PayloadRSP(contextType),
    depth = fifo_length,
    pushClock = ddr_ref_clk,
    popClock = sys_clk
  )

  val sys_area = new ClockingArea(sys_clk) {
    io.ddr_cmd >> cmd_fifo.io.push
    io.ddr_rsp << rsp_fifo.io.pop
  }

  val ddr_control_area = new ClockingArea(ddr_ref_clk) {
    val cmd_free = Reg(Bool()) init True
    val cmd_can_send =
      RegNext(io.cmd_ready & io.wr_data_rdy & io.init_calib_complete) init False
    val cmd_trigger = Reg(Bool()) init False
    val cmd_en = cmd_trigger
    val burst_cnt = Reg(UInt((burstlen + 1) bits)) init 0

    val rd_fire = io.rd_data_valid
    val wr_fire = io.wr_data_en & io.wr_data_rdy
    val data_fire = rd_fire | wr_fire

    cmd_fifo.io.pop.ready := cmd_free & cmd_can_send
    when(cmd_fifo.io.pop.fire) {
      cmd_free.clear()
      cmd_trigger.set()
      burst_cnt := 0
    }
    when(data_fire) {
      burst_cnt := burst_cnt + 1
    }
    when(cmd_en) {
      cmd_trigger.clear()
    }
    val cmd = RegNextWhen(cmd_fifo.io.pop.payload, cmd_fifo.io.pop.fire)
    cmd.burst_cnt init 0
    when(burst_cnt === cmd.burst_cnt +^ 1) {
      cmd_free.setWhen(cmd_free === False)
    }

    io.cmd_en := cmd_en
    io.app_burst_number := cmd.burst_cnt
    io.addr := cmd.addr
    io.wr_data := cmd.wr_data
    io.wr_data_mask := cmd.wr_mask
    when(cmd.cmdtype === Axi4Ddr_CMDTYPE.read) {
      io.cmd := B"001"
      io.wr_data_en := False
    }.otherwise { // write
      io.cmd := B"000"
      io.wr_data_en := (burst_cnt =/= cmd.burst_cnt +^ 1) & io.wr_data_rdy
    }

    rsp_fifo.io.push.valid := io.rd_data_valid
    rsp_fifo.io.push.payload.rsp_data := io.rd_data
    rsp_fifo.io.push.payload.context := cmd.context
  }
}

case class Axi4DdrWithCache(
    sys_clk: ClockDomain,
    dataWidth: Int,
    axiaddrlen: Int,
    idWidth: Int,
    addrlen: Int = 28,
    burstlen: Int = 6
) extends Component {
  val sys_clk_inst = sys_clk

  val axiConfig = Axi4Config(
    addressWidth = axiaddrlen,
    dataWidth = dataWidth,
    idWidth = idWidth,
    useLock = false,
    useRegion = false,
    useCache = false,
    useProt = false,
    useQos = false
  )

  val context_type = UInt(1 bits)

  val io = new Bundle() {
    val axi = slave(Axi4Shared(axiConfig))
    val ddr_cmd = master(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, context_type)))
    val ddr_rsp = slave(Stream(Axi4Ddr_PayloadRSP(context_type)))
  }

  val sys_area = new ClockingArea(sys_clk) {
    val ddr_cmd_valid = Reg(Bool()) init False
    val ddr_cmd_payload = Axi4Ddr_PayloadCMD(addrlen, burstlen, context_type)
    io.ddr_cmd.valid := ddr_cmd_valid
    io.ddr_cmd.payload := ddr_cmd_payload
    io.ddr_rsp.ready := True

    val cache_addr = Reg(UInt(addrlen bits)) init 0
    val cache_data = Reg(Bits(128 bits)) init 0
    val cache_dirty_bit = Reg(Bits(16 bits)) init B"16'xFFFF"

    val axi_burst_read = (io.axi.arw.len =/= 0) && (!io.axi.w.valid)
    val axi_unburst = io.axi.sharedCmd.unburstify
    val arwcmd_free = Reg(Bool()) init True
    val arwcmd = RegNextWhen(axi_unburst.payload, axi_unburst.fire)
    val pageDirty = cache_dirty_bit =/= B"16'xFFFF"
    val pageNotSame = cache_addr((addrlen - 1) downto 4) =/= arwcmd.addr((addrlen - 1) downto 4)
    val pageDirty_Trigger = Reg(Bool()) init False
    val pageNotSame_Trigger = Reg(Bool()) init False
    when(axi_unburst.fire) {
      arwcmd_free.clear()
      pageNotSame_Trigger.set()
      pageDirty_Trigger := pageDirty
    }
    axi_unburst.ready := arwcmd_free

    val write_data_ready = Reg(Bool()) init False
    val write_response_valid = Reg(Bool()) init False
    val read_response_valid = Reg(Bool()) init False
    io.axi.readRsp.payload.id := arwcmd.id
    io.axi.readRsp.payload.last := arwcmd.last
    io.axi.readRsp.payload.setOKAY()
    io.axi.readRsp.valid := read_response_valid
    io.axi.readRsp.payload.data := 0
    io.axi.writeRsp.valid := write_response_valid
    io.axi.writeRsp.payload.id := arwcmd.id
    io.axi.writeRsp.payload.setOKAY()
    io.axi.writeData.ready := write_data_ready

    ddr_cmd_payload.addr := 0
    ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.write
    ddr_cmd_payload.burst_cnt := 0
    ddr_cmd_payload.wr_data := cache_data
    ddr_cmd_payload.wr_mask := cache_dirty_bit
    ddr_cmd_payload.context := 0






    var fifoSize = 1 << burstlen
    val fifoPop = Stream(Fragment(Bits(128 bits)))
    val fifoPopData = Stream(Fragment(Bits(dataWidth bits)))
    val fifo = new StreamFifoCC(Fragment(Bits(dataWidth bit)), fifoSize, pushClock = ClockDomain.current, popClock = ClockDomain.current)

    // fifo.io.push << memRsp.toStream
    // fifo.io.pop >> fifoPop
    StreamFragmentWidthAdapter(fifoPop, fifoPopData)


    when(io.ddr_rsp.fire) {
      cache_addr := (arwcmd.addr((addrlen - 1) downto 4).asBits ## B"0000").asUInt
      cache_data := io.ddr_rsp.payload.rsp_data
      cache_dirty_bit := B"16'xFFFF"
    }
    when(arwcmd_free === False) {
      when(pageNotSame) {
        when(pageDirty_Trigger) {
          ddr_cmd_payload.addr := (cache_addr((addrlen - 1) downto 4).asBits ## B"0000").asUInt
          ddr_cmd_valid := ~io.ddr_cmd.fire
          ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.write
          pageDirty_Trigger.clearWhen(io.ddr_cmd.fire)
        }.elsewhen(pageNotSame_Trigger) {
          ddr_cmd_payload.addr := (arwcmd.addr((addrlen - 1) downto 4).asBits ## B"0000").asUInt
          ddr_cmd_valid := ~io.ddr_cmd.fire
          ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.read
          pageNotSame_Trigger.clearWhen(io.ddr_cmd.fire)
        }
      }.otherwise {
        when(arwcmd.write === True) {
          when(io.axi.writeData.fire) {
            switch(arwcmd.addr(3 downto 2)) {
              is(0x0) {
                var startbit = 0
                var startbit2 = 0
                var i = 0
                for (i <- 0 to 3) {
                  when(io.axi.writeData.payload.strb(i)) {
                    cache_data(
                      (i * 8 + 7 + startbit) downto (i * 8 + startbit)
                    ) := io.axi.writeData.payload.data(
                      (i * 8 + 7) downto (i * 8)
                    )
                    cache_dirty_bit(i + startbit2) := False
                  }
                }
              }
              is(0x1) {
                var startbit = 32
                var startbit2 = 4
                var i = 0
                for (i <- 0 to 3) {
                  when(io.axi.writeData.payload.strb(i)) {
                    cache_data(
                      (i * 8 + 7 + startbit) downto (i * 8 + startbit)
                    ) := io.axi.writeData.payload.data(
                      (i * 8 + 7) downto (i * 8)
                    )
                    cache_dirty_bit(i + startbit2) := False
                  }
                }
              }
              is(0x2) {
                var startbit = 64
                var startbit2 = 8
                var i = 0
                for (i <- 0 to 3) {
                  when(io.axi.writeData.payload.strb(i)) {
                    cache_data(
                      (i * 8 + 7 + startbit) downto (i * 8 + startbit)
                    ) := io.axi.writeData.payload.data(
                      (i * 8 + 7) downto (i * 8)
                    )
                    cache_dirty_bit(i + startbit2) := False
                  }
                }
              }
              default { // 0x3
                var startbit = 96
                var startbit2 = 12
                var i = 0
                for (i <- 0 to 3) {
                  when(io.axi.writeData.payload.strb(i)) {
                    cache_data(
                      (i * 8 + 7 + startbit) downto (i * 8 + startbit)
                    ) := io.axi.writeData.payload.data(
                      (i * 8 + 7) downto (i * 8)
                    )
                    cache_dirty_bit(i + startbit2) := False
                  }
                }
              }
            }
          }
          write_data_ready := ~write_response_valid
          when(io.axi.writeData.fire) {
            write_data_ready := False
            write_response_valid := True
          }
          when(io.axi.writeRsp.fire) {
            write_response_valid := False
            arwcmd_free.set()
          }
        }.otherwise { // read
          switch(arwcmd.addr(3 downto 2)) {
            is(0x0) {
              io.axi.readRsp.payload.data := cache_data(31 downto 0)
            }
            is(0x1) {
              io.axi.readRsp.payload.data := cache_data(63 downto 32)
            }
            is(0x2) {
              io.axi.readRsp.payload.data := cache_data(95 downto 64)
            }
            default { // 0x3
              io.axi.readRsp.payload.data := cache_data(127 downto 96)
            }
          }
          read_response_valid := ~io.axi.readRsp.fire
          when(io.axi.readRsp.fire) {
            arwcmd_free.set()
          }
        }
      }
    }
  }
}

case class Axi4Ddr_Bus[T <: Data](addrlen: Int = 28, burstlen: Int = 6, contextType : T) extends Bundle {
  val cmd = master(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType)))
  val rsp = slave(Stream(Axi4Ddr_PayloadRSP(contextType)))
}

case class Axi4Ddr_Bus_Device[T <: Data](addrlen: Int = 28, burstlen: Int = 6, contextType : T) extends Bundle {
  val cmd = slave(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType)))
  val rsp = master(Stream(Axi4Ddr_PayloadRSP(contextType)))
}

case class Axi4Ddr_BusArbiter_Context[T <: Data](contextType : T) extends Bundle {
  val devid = UInt(1 bits)
  val other = cloneOf(contextType)
}

case class Axi4Ddr_BusArbiter[T <: Data](sys_clk: ClockDomain, addrlen: Int = 28, burstlen: Int = 6, contextType : T) extends Component{
  val bus_context = Axi4Ddr_BusArbiter_Context(contextType)
  val io = new Bundle {
    val bus_ddr = Axi4Ddr_Bus(addrlen, burstlen, bus_context)
    val bus_device_1 = Axi4Ddr_Bus_Device(addrlen, burstlen, contextType)
    val bus_device_2 = Axi4Ddr_Bus_Device(addrlen, burstlen, contextType)
  }

  val DEVID_BUS_1 = 0
  val DEVID_BUS_2 = 1

  val area = new ClockingArea(sys_clk) {
    val device1_ready = Reg(Bool) init(False)
    val device1_cmd_payload = Reg(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType))
    val device2_ready = Reg(Bool) init(False)
    val device2_cmd_payload = Reg(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType))

    when(io.bus_device_1.cmd.fire) {
      device1_ready := True
      device1_cmd_payload := io.bus_device_1.cmd.payload
    }
    when(io.bus_device_2.cmd.fire) {
      device2_ready := True
      device2_cmd_payload := io.bus_device_2.cmd.payload
    }

    io.bus_device_1.cmd.ready := ~device1_ready
    io.bus_device_2.cmd.ready := ~device2_ready

    val bus_ddr_valid = Reg(Bool) init(False)
    when(device1_ready) {
      io.bus_ddr.cmd.payload.cmdtype := device1_cmd_payload.cmdtype
      io.bus_ddr.cmd.payload.addr := device1_cmd_payload.addr
      io.bus_ddr.cmd.payload.burst_cnt := device1_cmd_payload.burst_cnt
      io.bus_ddr.cmd.payload.wr_mask := device1_cmd_payload.wr_mask
      io.bus_ddr.cmd.payload.wr_data := device1_cmd_payload.wr_data
      io.bus_ddr.cmd.payload.context.devid := DEVID_BUS_1
      io.bus_ddr.cmd.payload.context.other := device1_cmd_payload.context
    }.otherwise {
      io.bus_ddr.cmd.payload.cmdtype := device2_cmd_payload.cmdtype
      io.bus_ddr.cmd.payload.addr := device2_cmd_payload.addr
      io.bus_ddr.cmd.payload.burst_cnt := device2_cmd_payload.burst_cnt
      io.bus_ddr.cmd.payload.wr_mask := device2_cmd_payload.wr_mask
      io.bus_ddr.cmd.payload.wr_data := device2_cmd_payload.wr_data
      io.bus_ddr.cmd.payload.context.devid := DEVID_BUS_2
      io.bus_ddr.cmd.payload.context.other := device2_cmd_payload.context
    }

    when(device1_ready || device2_ready) {
      bus_ddr_valid := ~io.bus_ddr.cmd.fire
    }
    when(device1_ready) {
      when(io.bus_ddr.cmd.fire) {
        device1_ready := False
      }
    }.elsewhen(device2_ready) {
      when(io.bus_ddr.cmd.fire) {
        device2_ready := False
      }
    }

    io.bus_ddr.cmd.valid := bus_ddr_valid
    io.bus_device_1.rsp.payload.rsp_data := io.bus_ddr.rsp.payload.rsp_data
    io.bus_device_1.rsp.payload.context := io.bus_ddr.rsp.payload.context.other
    io.bus_device_2.rsp.payload.rsp_data := io.bus_ddr.rsp.payload.rsp_data
    io.bus_device_2.rsp.payload.context := io.bus_ddr.rsp.payload.context.other
    switch(io.bus_ddr.rsp.payload.context.devid) {
      is(DEVID_BUS_1) {
        io.bus_device_1.rsp.valid := io.bus_ddr.rsp.valid
        io.bus_ddr.rsp.ready := io.bus_device_1.rsp.ready
        io.bus_device_2.rsp.valid := False
      }
      is(DEVID_BUS_2) {
        io.bus_device_2.rsp.valid := io.bus_ddr.rsp.valid
        io.bus_ddr.rsp.ready := io.bus_device_2.rsp.ready
        io.bus_device_1.rsp.valid := False
      }
    }
  }
}

case class Axi4Ddr(sys_clk: ClockDomain, mem_clk: ClockDomain) extends Component {
  val axiController = Axi4DdrWithCache(sys_clk, 32, 28, 4)
  val io = new Bundle() {
    val pll_lock = in Bool ()
    val axi = slave(Axi4Shared(axiController.axiConfig))
    val ddr_iface = master(DDR3_Interface())
    val init_calib_complete = out Bool()
  }

  val gowin_DDR3 = Gowin_DDR3(sys_clk, mem_clk)
  val ddr_ref_clk = gowin_DDR3.clk_out
  val controller = Axi4Ddr_Controller(
    sys_clk,
    ddr_ref_clk,
    contextType = axiController.context_type,
    fifo_length = 4
  )

  val sys_area = new ClockingArea(sys_clk) {
    axiController.io.ddr_cmd >> controller.io.ddr_cmd
    axiController.io.ddr_rsp << controller.io.ddr_rsp

    io.axi.sharedCmd >> axiController.io.axi.sharedCmd
    io.axi.writeData >> axiController.io.axi.writeData
    io.axi.writeRsp << axiController.io.axi.writeRsp
    io.axi.readRsp << axiController.io.axi.readRsp

    gowin_DDR3.io.sr_req := False
    gowin_DDR3.io.ref_req := False
    gowin_DDR3.io.burst := True
    gowin_DDR3.io.pll_lock := io.pll_lock
    gowin_DDR3.io.app_burst_number := controller.io.app_burst_number
    gowin_DDR3.io.cmd := controller.io.cmd
    gowin_DDR3.io.cmd_en := controller.io.cmd_en
    gowin_DDR3.io.addr := controller.io.addr
    gowin_DDR3.io.wr_data := controller.io.wr_data
    gowin_DDR3.io.wr_data_en := controller.io.wr_data_en
    gowin_DDR3.io.wr_data_end := controller.io.wr_data_en
    gowin_DDR3.io.wr_data_mask := controller.io.wr_data_mask

    controller.io.cmd_ready := gowin_DDR3.io.cmd_ready
    controller.io.wr_data_rdy := gowin_DDR3.io.wr_data_rdy
    controller.io.rd_data := gowin_DDR3.io.rd_data
    controller.io.rd_data_valid := gowin_DDR3.io.rd_data_valid
    controller.io.init_calib_complete := gowin_DDR3.io.init_calib_complete

    gowin_DDR3.connectDDR3Interface(io.ddr_iface)
  }
  io.init_calib_complete := gowin_DDR3.io.init_calib_complete
}

case class Axi4DdrCtrl(sys_clk: ClockDomain, mem_clk: ClockDomain) extends Component{
  val inst = Axi4Ddr(sys_clk, mem_clk)
  val axiConfig = inst.axiController.axiConfig

  val io = new Bundle() {
    val pll_lock = in Bool()
    val axi = slave(Axi4(axiConfig))
    val ddr_iface = master(DDR3_Interface())
    val init_calib_complete = out Bool()
  }

  Axi4SpecRenamer(io.axi)

  val sys_area = new ClockingArea(sys_clk) {
    inst.io.pll_lock := io.pll_lock
    inst.io.axi << Axi4ToAxi4Shared(io.axi)
    io.ddr_iface := inst.io.ddr_iface
    io.init_calib_complete := inst.io.init_calib_complete
  }
}

case class Axi4DdrWithDMA(sys_clk: ClockDomain, mem_clk: ClockDomain) extends Component{
  val axiController = Axi4DdrWithCache(sys_clk, 32, 28, 4)
  val io = new Bundle() {
    val pll_lock = in Bool()
    val axi = slave(Axi4Shared(axiController.axiConfig))
    val ddr_dma_bus = Axi4Ddr_Bus_Device(contextType = axiController.context_type)
    val ddr_iface = master(DDR3_Interface())
    val init_calib_complete = out Bool()
  }

  val gowin_DDR3 = Gowin_DDR3(sys_clk, mem_clk)
  val ddr_ref_clk = gowin_DDR3.clk_out
  val busArbiter = Axi4Ddr_BusArbiter(
    sys_clk,
    contextType = axiController.context_type
  )
  val controller = Axi4Ddr_Controller(
    sys_clk,
    ddr_ref_clk,
    contextType = busArbiter.bus_context,
    fifo_length = 4
  )

  val sys_area = new ClockingArea(sys_clk) {
    busArbiter.io.bus_ddr.cmd >/-> controller.io.ddr_cmd
    busArbiter.io.bus_ddr.rsp <-/< controller.io.ddr_rsp

    io.ddr_dma_bus.cmd >/-> busArbiter.io.bus_device_1.cmd
    io.ddr_dma_bus.rsp <-/< busArbiter.io.bus_device_1.rsp

    axiController.io.ddr_cmd >/-> busArbiter.io.bus_device_2.cmd
    axiController.io.ddr_rsp <-/< busArbiter.io.bus_device_2.rsp

    io.axi.sharedCmd >> axiController.io.axi.sharedCmd
    io.axi.writeData >> axiController.io.axi.writeData
    io.axi.writeRsp << axiController.io.axi.writeRsp
    io.axi.readRsp  << axiController.io.axi.readRsp

    gowin_DDR3.io.sr_req := False
    gowin_DDR3.io.ref_req := False
    gowin_DDR3.io.burst := True
    gowin_DDR3.io.pll_lock := io.pll_lock
    gowin_DDR3.io.app_burst_number := controller.io.app_burst_number
    gowin_DDR3.io.cmd := controller.io.cmd
    gowin_DDR3.io.cmd_en := controller.io.cmd_en
    gowin_DDR3.io.addr := controller.io.addr
    gowin_DDR3.io.wr_data := controller.io.wr_data
    gowin_DDR3.io.wr_data_en := controller.io.wr_data_en
    gowin_DDR3.io.wr_data_end := controller.io.wr_data_en
    gowin_DDR3.io.wr_data_mask := controller.io.wr_data_mask
    controller.io.cmd_ready := gowin_DDR3.io.cmd_ready
    controller.io.wr_data_rdy := gowin_DDR3.io.wr_data_rdy
    controller.io.rd_data := gowin_DDR3.io.rd_data
    controller.io.rd_data_valid := gowin_DDR3.io.rd_data_valid
    controller.io.init_calib_complete := gowin_DDR3.io.init_calib_complete

    gowin_DDR3.connectDDR3Interface(io.ddr_iface)
  }
  io.init_calib_complete := gowin_DDR3.io.init_calib_complete
}

case class Axi4DdrWithDMACtrl(sys_clk: ClockDomain, mem_clk: ClockDomain) extends Component{
  val inst = Axi4DdrWithDMA(sys_clk, mem_clk)
  val axiConfig = inst.axiController.axiConfig
  val context_type = inst.axiController.context_type

  val io = new Bundle() {
    val pll_lock = in Bool()
    val axi = slave(Axi4(axiConfig))
    val ddr_dma_bus = Axi4Ddr_Bus_Device(contextType = context_type)
    val ddr_iface = master(DDR3_Interface())
    val init_calib_complete = out Bool()
  }

  Axi4SpecRenamer(io.axi)

  val sys_area = new ClockingArea(sys_clk) {
    inst.io.pll_lock := io.pll_lock
    inst.io.axi << Axi4ToAxi4Shared(io.axi)
    io.ddr_dma_bus <> inst.io.ddr_dma_bus
    io.ddr_iface := inst.io.ddr_iface
    io.init_calib_complete := inst.io.init_calib_complete
  }
}


// object Axi4DdrGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Axi4DdrCtrl(
//         ClockDomain.external("sysclk", config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = LOW)),
//         ClockDomain.external("memclk", config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = LOW))
//       )
//     )
//   }
// }

// object Axi4DdrWithDMAGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Axi4DdrWithDMACtrl(
//         ClockDomain.external("sysclk", config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = LOW)),
//         ClockDomain.external("memclk", config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = LOW))
//       )
//     )
//   }
// }
