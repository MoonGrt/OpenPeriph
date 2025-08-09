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

  override def asMaster(): Unit = {
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
    contextType: T,
    pagesize: Int = 128
) extends Bundle {
  val cmdtype = Axi4Ddr_CMDTYPE()
  val addr = UInt(addrlen bits)
  val burst_cnt = UInt(burstlen bits)
  val wr_data = Bits(pagesize bits)
  val wr_mask = Bits(pagesize/8 bits)
  val context = cloneOf(contextType)
}

case class Axi4Ddr_PayloadRSP[T <: Data](contextType: T, pagesize: Int = 128) extends Bundle {
  val rsp_data = Bits(pagesize bits)
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
    val cmd_can_send = RegNext(io.cmd_ready & io.wr_data_rdy & io.init_calib_complete) init False
    val cmd_trigger = Reg(Bool()) init False
    val cmd_en = cmd_trigger
    val burst_cnt = Reg(UInt((burstlen + 1) bits)) init 0

    val rd_fire = io.rd_data_valid
    val wr_fire = io.wr_data_en & io.wr_data_rdy
    val data_fire = rd_fire | wr_fire

    val cmd = RegNextWhen(cmd_fifo.io.pop.payload, cmd_fifo.io.pop.fire)
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
    when(burst_cnt === cmd.burst_cnt +^ 1) {
      cmd_free.setWhen(cmd_free === False)
    }

    val is_write = cmd.cmdtype === Axi4Ddr_CMDTYPE.write
    io.cmd_en := cmd_en
    io.cmd := Mux(is_write, B"000", B"001")
    io.app_burst_number := cmd.burst_cnt
    io.addr := cmd.addr
    io.wr_data := cmd.wr_data
    io.wr_data_mask := cmd.wr_mask
    io.wr_data_en := is_write & (burst_cnt =/= cmd.burst_cnt +^ 1) & io.wr_data_rdy

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
    burstlen: Int = 6,
    pagesize: Int = 256,
    pagenum: Int = 4
) extends Component {
  // pagesize 限制
  require(
    pagesize % 128 == 0 &&
    isPow2(pagesize / 128),
    s"pagesize must be 128 * 2^n and > 128, but got $pagesize"
  )
  val pageBytes = pagesize / 8
  val pageWords = pagesize / 32
  val pageBlocks = pagesize / 128

  val sys_clk_inst = sys_clk
  val context_type = UInt(1 bits)

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

  val io = new Bundle() {
    val axi = slave(Axi4Shared(axiConfig))
    val ddr_cmd = master(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, context_type)))
    val ddr_rsp = slave(Stream(Axi4Ddr_PayloadRSP(context_type)))
  }

  val sys_area = new ClockingArea(sys_clk) {
    val cache_addr  = Vec(Reg(UInt(addrlen bits)) init 0, pagenum)
    val cache_data  = Vec(Reg(Bits(pagesize bits)) init 0, pagenum)
    val cache_dirty = Vec(Reg(Bool()) init False, pagenum)  // 标记页是否被修改。可以使用ddr控制器的mask，使得控制更精确，但此处无必要。
    val cache_valid = Vec(Reg(Bool()) init False, pagenum)

    val lru_counter = if (pagenum > 1) {
      Reg(UInt(log2Up(pagenum) bits)) init 0
    } else {
      U(0, 0 bits)
    }

    // AXI unburst 化
    val axi_unburst = io.axi.sharedCmd.unburstify
    val arwcmd_free = Reg(Bool()) init True
    val arwcmd = RegNextWhen(axi_unburst.payload, axi_unburst.fire)
    // 捕捉新的命令
    when(axi_unburst.fire) {
      arwcmd_free.clear()
    }
    axi_unburst.ready := arwcmd_free

    // hit/miss 检测
    val pageOffsetBits = log2Up(pageBytes)
    val current_page_tag = arwcmd.addr((addrlen - 1) downto pageOffsetBits)
    val page_hit_vec = Vec.tabulate(pagenum)(i =>
      cache_valid(i) && (cache_addr(i)((addrlen - 1) downto pageOffsetBits) === current_page_tag)
    )
    val hit = page_hit_vec.orR
    val hit_index = OHToUInt(page_hit_vec)
    val miss = !hit

    // 选出要替换的页索引
    val replace_index = lru_counter

    // DDR 相关
    val ddr_write_pending = Reg(Bool()) init False
    val ddr_read_pending  = Reg(Bool()) init False
    val ddr_write_page = Reg(UInt(log2Up(pagenum) bits))
    val ddr_read_page  = Reg(UInt(log2Up(pagenum) bits))

    val ddr_cmd_valid = Reg(Bool()) init False
    val ddr_cmd_payload = Axi4Ddr_PayloadCMD(addrlen, burstlen, context_type)
    io.ddr_cmd.payload := ddr_cmd_payload
    io.ddr_cmd.valid := ddr_cmd_valid
    io.ddr_rsp.ready := True

    // 初始化 cmd
    ddr_cmd_payload.addr := 0
    ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.write
    ddr_cmd_payload.burst_cnt := pageBlocks - 1
    ddr_cmd_payload.wr_data := 0
    ddr_cmd_payload.wr_mask := B"16'xFFFF" // "0": 数据无效，"1": 数据有效
    ddr_cmd_payload.context := 0

    // 处理未命中时的数据替换
    val dirty = cache_dirty(replace_index)
    val write_burst_counter = if (pageBlocks > 1) {
      Reg(UInt(log2Up(pageBlocks) bits)) init 0
    } else {
      U(0, 0 bits)
    }
    val read_burst_counter = if (pageBlocks > 1) {
      Reg(UInt(log2Up(pageBlocks) bits)) init 0
    } else {
      U(0, 0 bits)
    }
    when(arwcmd_free === False && miss) {
      when(dirty && !ddr_write_pending) {
        // 写回旧页
        for (i <- 0 until pageBlocks) {
          when (i === write_burst_counter) {
            ddr_cmd_payload.wr_data := cache_data(ddr_write_page)(i*128+127 downto i*128)
          }
        }
        ddr_cmd_payload.addr := (cache_addr(replace_index)((addrlen - 1) downto pageOffsetBits) ## U(0, pageOffsetBits bits)).asUInt
        ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.write
        ddr_cmd_valid.setWhen(io.ddr_cmd.ready)
        when(io.ddr_cmd.fire) {
          when(write_burst_counter === pageBlocks - 1) {
            ddr_cmd_valid := False
            ddr_write_pending := True
            ddr_write_page := replace_index
            write_burst_counter := 0
          } otherwise {
            if (pageBlocks > 1) {
              write_burst_counter := write_burst_counter + 1
            }
          }
        }
      }.elsewhen(!ddr_read_pending) {
        // 读取新页
        ddr_cmd_payload.addr := (arwcmd.addr((addrlen - 1) downto pageOffsetBits) ## U(0, pageOffsetBits bits)).asUInt
        ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.read
        ddr_cmd_valid := ~io.ddr_cmd.fire
        when(io.ddr_cmd.fire) {
          ddr_read_pending := True
          ddr_read_page := replace_index
        }
      }
    }

    // 接收DDR读返回
    when(io.ddr_rsp.fire && ddr_read_pending) {
      if (pageBlocks > 1) {
        read_burst_counter := read_burst_counter + 1
      }
      cache_addr(ddr_read_page) := (arwcmd.addr((addrlen - 1) downto pageOffsetBits) ## U(0, pageOffsetBits bits)).asUInt
      for (i <- 0 until pageBlocks) {
        when (i === read_burst_counter) {
          cache_data(ddr_read_page)(i*128+127 downto i*128) := io.ddr_rsp.payload.rsp_data
        }
      }
      when(read_burst_counter === pageBlocks - 1) {
        cache_dirty(ddr_read_page) := False
        cache_valid(ddr_read_page) := True
        ddr_read_pending := False
        ddr_write_pending := False
        read_burst_counter := 0
        if (pagenum > 1) {
          lru_counter := lru_counter + 1
        }
      }
    }

    // AXI写命中处理
    val write_data_ready = Reg(Bool()) init False
    val write_response_valid = Reg(Bool()) init False
    io.axi.writeData.ready := write_data_ready
    io.axi.writeRsp.valid := write_response_valid
    io.axi.writeRsp.payload.id := arwcmd.id
    io.axi.writeRsp.payload.setOKAY()

    when(hit && arwcmd.write && arwcmd_free === False) {
      val strb = io.axi.writeData.payload.strb
      val wdata = io.axi.writeData.payload.data
      cache_dirty(hit_index) := True
      for (i <- 0 until pageWords) {
        when(arwcmd.addr(pageOffsetBits - 1 downto 2) === i) {
          for (j <- 0 until 4) {
            when(strb(j) && io.axi.writeData.fire) {
              cache_data(hit_index)((i*32+j*8+7) downto (i*32+j*8)) := wdata((j*8+7) downto (j*8))
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
        arwcmd_free := True
      }
    }


    // AXI读命中处理
    val read_response_valid = Reg(Bool()) init False
    io.axi.readRsp.valid := read_response_valid
    io.axi.readRsp.payload.id := arwcmd.id
    io.axi.readRsp.payload.last := arwcmd.last
    io.axi.readRsp.payload.setOKAY()
    io.axi.readRsp.payload.data := 0

    when(hit && !arwcmd.write && arwcmd_free === False) {
      for (i <- 0 until pageWords) {
        when(arwcmd.addr(pageOffsetBits - 1 downto 2) === i) {
          io.axi.readRsp.payload.data := cache_data(hit_index)((i*32+31) downto (i*32))
        }
      }
      read_response_valid := ~io.axi.readRsp.fire
      arwcmd_free.setWhen(io.axi.readRsp.fire)
    }
  }
}

case class Axi4DdrControllerWithCache(
    sys_clk: ClockDomain,
    ddr_clk: ClockDomain,
    dataWidth: Int,
    axiaddrlen: Int,
    idWidth: Int,
    addrlen: Int = 28,
    burstlen: Int = 6,
    fifolen: Int = 4,
    pagesize: Int = 128,
    pagenum: Int = 1
) extends Component {
  // pagesize 限制
  require(
    pagesize % 128 == 0 &&
    isPow2(pagesize / 128),
    s"pagesize must be 128 * 2^n and > 128, but got $pagesize"
  )
  val pageBytes = pagesize / 8
  val pageWords = pagesize / 32
  val pageBlocks = pagesize / 128

  val contextType = UInt(1 bits)

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

  val io = new Bundle() {
    // AXI4 接口
    val axi = slave(Axi4Shared(axiConfig))
    // Gowin DDR 控制器接口
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
  }

  val ddr_cmd = Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType, pagesize))
  val ddr_rsp = Stream(Axi4Ddr_PayloadRSP(contextType, pagesize))
  val cmd_fifo = new StreamFifoCC(
    dataType = Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType, pagesize),
    depth = fifolen,
    pushClock = sys_clk,
    popClock = ddr_clk
  )
  val rsp_fifo = new StreamFifoCC(
    dataType = Axi4Ddr_PayloadRSP(contextType, pagesize),
    depth = fifolen,
    pushClock = ddr_clk,
    popClock = sys_clk
  )

  val sys_area = new ClockingArea(sys_clk) {
    val cache_addr  = Vec(Reg(UInt(addrlen bits)) init 0, pagenum)
    val cache_data  = Vec(Reg(Bits(pagesize bits)) init 0, pagenum)
    val cache_dirty = Vec(Reg(Bool()) init False, pagenum)  // 标记页是否被修改。可以使用ddr控制器的mask，使得控制更精确，但此处无必要。
    val cache_valid = Vec(Reg(Bool()) init False, pagenum)

    val lru_counter = if (pagenum > 1) {
      Reg(UInt(log2Up(pagenum) bits)) init 0
    } else {
      U(0, 0 bits)
    }

    // AXI unburst 化
    val axi_unburst = io.axi.sharedCmd.unburstify
    val arwcmd_free = Reg(Bool()) init True
    val arwcmd = RegNextWhen(axi_unburst.payload, axi_unburst.fire)
    // 捕捉新的命令
    when(axi_unburst.fire) {
      arwcmd_free.clear()
    }
    axi_unburst.ready := arwcmd_free

    // hit/miss 检测
    val pageOffsetBits = log2Up(pageBytes)
    val current_page_tag = arwcmd.addr((addrlen - 1) downto pageOffsetBits)
    val page_hit_vec = Vec.tabulate(pagenum)(i =>
      cache_valid(i) && (cache_addr(i)((addrlen - 1) downto pageOffsetBits) === current_page_tag)
    )
    val hit = page_hit_vec.orR
    val hit_index = OHToUInt(page_hit_vec)
    val miss = !hit

    // DDR 相关
    val ddr_write_pending = Reg(Bool()) init False
    val ddr_read_pending  = Reg(Bool()) init False
    val ddr_cmd_valid = Reg(Bool()) init False
    val ddr_cmd_payload = Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType, pagesize)
    ddr_cmd.payload := ddr_cmd_payload
    ddr_cmd.valid := ddr_cmd_valid
    ddr_rsp.ready := True

    // 初始化 cmd
    ddr_cmd_payload.addr := 0
    ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.write
    ddr_cmd_payload.burst_cnt := pageBlocks - 1
    ddr_cmd_payload.wr_data := cache_data(lru_counter)
    ddr_cmd_payload.wr_mask :=  B(pageBytes bits, default -> False)  // "0": 数据有效，"1": 数据无效
    ddr_cmd_payload.context := 0

    // 处理未命中时的数据替换
    val dirty = cache_dirty(lru_counter)
    when(arwcmd_free === False && miss) {
      when(dirty && !ddr_write_pending) {
        // 写回旧页
        ddr_cmd_payload.addr := (cache_addr(lru_counter)((addrlen - 1) downto pageOffsetBits) ## U(0, pageOffsetBits bits)).asUInt
        ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.write
        ddr_cmd_valid := ~ddr_cmd.fire
        ddr_write_pending.setWhen(ddr_cmd.fire)
      }.elsewhen(!ddr_read_pending) {
        // 读取新页
        ddr_cmd_payload.addr := (arwcmd.addr((addrlen - 1) downto pageOffsetBits) ## U(0, pageOffsetBits bits)).asUInt
        ddr_cmd_payload.cmdtype := Axi4Ddr_CMDTYPE.read
        ddr_cmd_valid := ~ddr_cmd.fire
        ddr_read_pending.setWhen(ddr_cmd.fire)
      }
    }

    // 接收DDR读返回
    when(ddr_rsp.fire && ddr_read_pending) {
      cache_addr(lru_counter) := (arwcmd.addr((addrlen - 1) downto pageOffsetBits) ## U(0, pageOffsetBits bits)).asUInt
      cache_data(lru_counter) := ddr_rsp.payload.rsp_data
      cache_dirty(lru_counter) := False
      cache_valid(lru_counter) := True
      ddr_read_pending := False
      ddr_write_pending := False
      if (pagenum > 1) {
        lru_counter := lru_counter + 1
      }
    }

    // AXI写命中处理
    val write_data_ready = Reg(Bool()) init False
    val write_response_valid = Reg(Bool()) init False
    io.axi.writeData.ready := write_data_ready
    io.axi.writeRsp.valid := write_response_valid
    io.axi.writeRsp.payload.id := arwcmd.id
    io.axi.writeRsp.payload.setOKAY()

    when(hit && arwcmd.write && arwcmd_free === False) {
      val strb = io.axi.writeData.payload.strb
      val wdata = io.axi.writeData.payload.data
      cache_dirty(hit_index) := True
      for (i <- 0 until pageWords) {
        when(arwcmd.addr(pageOffsetBits - 1 downto 2) === i) {
          for (j <- 0 until 4) {
            when(strb(j) && io.axi.writeData.fire) {
              cache_data(hit_index)((i*32+j*8+7) downto (i*32+j*8)) := wdata((j*8+7) downto (j*8))
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
        arwcmd_free := True
      }
    }

    // AXI读命中处理
    val read_response_valid = Reg(Bool()) init False
    io.axi.readRsp.valid := read_response_valid
    io.axi.readRsp.payload.id := arwcmd.id
    io.axi.readRsp.payload.last := arwcmd.last
    io.axi.readRsp.payload.setOKAY()
    io.axi.readRsp.payload.data := 0

    when(hit && !arwcmd.write && arwcmd_free === False) {
      for (i <- 0 until pageWords) {
        when(arwcmd.addr(pageOffsetBits - 1 downto 2) === i) {
          io.axi.readRsp.payload.data := cache_data(hit_index)((i*32+31) downto (i*32))
        }
      }
      read_response_valid := ~io.axi.readRsp.fire
      arwcmd_free.setWhen(io.axi.readRsp.fire)
    }

    ddr_cmd >> cmd_fifo.io.push
    ddr_rsp << rsp_fifo.io.pop
  }

  val ddr_control_area = new ClockingArea(ddr_clk) {
    val cmd_free = Reg(Bool()) init True
    val cmd_can_send = RegNext(io.cmd_ready & io.wr_data_rdy & io.init_calib_complete) init False
    val cmd_trigger = Reg(Bool()) init False
    val cmd_en = cmd_trigger
    val burst_cnt = Reg(UInt((burstlen + 1) bits)) init 0

    val rd_fire = io.rd_data_valid
    val wr_fire = io.wr_data_en & io.wr_data_rdy
    val data_fire = rd_fire | wr_fire

    val cmd = RegNextWhen(cmd_fifo.io.pop.payload, cmd_fifo.io.pop.fire)
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
    when(burst_cnt === cmd.burst_cnt +^ 1) {
      cmd_free.setWhen(cmd_free === False)
    }

    val is_write = cmd.cmdtype === Axi4Ddr_CMDTYPE.write
    io.cmd_en := cmd_en
    io.cmd := Mux(is_write, B"000", B"001")
    io.app_burst_number := cmd.burst_cnt
    io.addr := cmd.addr
    io.wr_data_en := is_write & (burst_cnt =/= cmd.burst_cnt +^ 1) & io.wr_data_rdy
    io.wr_data := B(0, 128 bits) // 默认赋值，消除 latch
    io.wr_data_mask := B"16'x0000" // 默认赋值，消除 latch
    for (i <- 0 until pageBlocks) {
      when (i === burst_cnt) {
        io.wr_data := cmd.wr_data(i*128+127 downto i*128)
        io.wr_data_mask := cmd.wr_mask(i*16+15 downto i*16)
      }
    }

    val push_valid_reg = RegNext(io.rd_data_valid & (burst_cnt === cmd.burst_cnt)) init False
    val push_context_reg = RegNext(cmd.context) init 0
    val push_data_reg = Reg(Bits(pagesize bits)) init 0
    for (i <- 0 until pageBlocks) {
      when (i === burst_cnt) {
        push_data_reg(i*128+127 downto i*128) := io.rd_data
      }
    }
    rsp_fifo.io.push.valid := push_valid_reg
    rsp_fifo.io.push.payload.context := push_context_reg
    rsp_fifo.io.push.payload.rsp_data := push_data_reg
  }
}

case class Axi4Ddr_Bus[T <: Data](addrlen: Int = 28, burstlen: Int = 6, contextType: T) extends Bundle {
  val cmd = master(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType)))
  val rsp = slave(Stream(Axi4Ddr_PayloadRSP(contextType)))
}

case class Axi4Ddr_Bus_Device[T <: Data](addrlen: Int = 28, burstlen: Int = 6, contextType: T) extends Bundle {
  val cmd = slave(Stream(Axi4Ddr_PayloadCMD(addrlen, burstlen, contextType)))
  val rsp = master(Stream(Axi4Ddr_PayloadRSP(contextType)))
}

case class Axi4Ddr_BusArbiter_Context[T <: Data](contextType: T) extends Bundle {
  val devid = UInt(1 bits)
  val other = cloneOf(contextType)
}

case class Axi4Ddr_BusArbiter[T <: Data](sys_clk: ClockDomain, addrlen: Int = 28, burstlen: Int = 6, contextType: T) extends Component{
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

// case class Axi4Ddr(sys_clk: ClockDomain, mem_clk: ClockDomain) extends Component {
//   val axiController = Axi4DdrWithCache(sys_clk, 32, 28, 4)
//   val io = new Bundle() {
//     val pll_lock = in Bool ()
//     val axi = slave(Axi4Shared(axiController.axiConfig))
//     val ddr_iface = master(DDR3_Interface())
//     val init_calib_complete = out Bool()
//   }

//   val gowin_DDR3 = Gowin_DDR3(sys_clk, mem_clk)
//   val ddr_ref_clk = gowin_DDR3.clk_out
//   val controller = Axi4Ddr_Controller(
//     sys_clk,
//     ddr_ref_clk,
//     contextType = axiController.context_type,
//     fifo_length = 4
//   )

//   val sys_area = new ClockingArea(sys_clk) {
//     axiController.io.ddr_cmd >> controller.io.ddr_cmd
//     axiController.io.ddr_rsp << controller.io.ddr_rsp

//     io.axi.sharedCmd >> axiController.io.axi.sharedCmd
//     io.axi.writeData >> axiController.io.axi.writeData
//     io.axi.writeRsp << axiController.io.axi.writeRsp
//     io.axi.readRsp << axiController.io.axi.readRsp

//     gowin_DDR3.io.sr_req := False
//     gowin_DDR3.io.ref_req := False
//     gowin_DDR3.io.burst := True
//     gowin_DDR3.io.pll_lock := io.pll_lock
//     gowin_DDR3.io.app_burst_number := controller.io.app_burst_number
//     gowin_DDR3.io.cmd := controller.io.cmd
//     gowin_DDR3.io.cmd_en := controller.io.cmd_en
//     gowin_DDR3.io.addr := controller.io.addr
//     gowin_DDR3.io.wr_data := controller.io.wr_data
//     gowin_DDR3.io.wr_data_en := controller.io.wr_data_en
//     gowin_DDR3.io.wr_data_end := controller.io.wr_data_en
//     gowin_DDR3.io.wr_data_mask := controller.io.wr_data_mask

//     controller.io.cmd_ready := gowin_DDR3.io.cmd_ready
//     controller.io.wr_data_rdy := gowin_DDR3.io.wr_data_rdy
//     controller.io.rd_data := gowin_DDR3.io.rd_data
//     controller.io.rd_data_valid := gowin_DDR3.io.rd_data_valid
//     controller.io.init_calib_complete := gowin_DDR3.io.init_calib_complete

//     gowin_DDR3.connectDDR3Interface(io.ddr_iface)
//   }
//   io.init_calib_complete := gowin_DDR3.io.init_calib_complete
// }

case class Axi4Ddr(sys_clk: ClockDomain, mem_clk: ClockDomain) extends Component {
  val gowin_DDR3 = Gowin_DDR3(sys_clk, mem_clk)
  val ddr_clk = gowin_DDR3.clk_out
  val axiController = Axi4DdrControllerWithCache(sys_clk, ddr_clk, 32, 28, 4)
  val io = new Bundle() {
    val pll_lock = in Bool ()
    val axi = slave(Axi4Shared(axiController.axiConfig))
    val ddr_iface = master(DDR3_Interface())
    val init_calib_complete = out Bool()
  }

  io.init_calib_complete := gowin_DDR3.io.init_calib_complete
  val sys_area = new ClockingArea(sys_clk) {
    io.axi.sharedCmd >> axiController.io.axi.sharedCmd
    io.axi.writeData >> axiController.io.axi.writeData
    io.axi.writeRsp << axiController.io.axi.writeRsp
    io.axi.readRsp << axiController.io.axi.readRsp

    gowin_DDR3.io.sr_req := False
    gowin_DDR3.io.ref_req := False
    gowin_DDR3.io.burst := True
    gowin_DDR3.io.pll_lock := io.pll_lock
    gowin_DDR3.io.app_burst_number := axiController.io.app_burst_number
    gowin_DDR3.io.cmd := axiController.io.cmd
    gowin_DDR3.io.cmd_en := axiController.io.cmd_en
    gowin_DDR3.io.addr := axiController.io.addr
    gowin_DDR3.io.wr_data := axiController.io.wr_data
    gowin_DDR3.io.wr_data_en := axiController.io.wr_data_en
    gowin_DDR3.io.wr_data_end := axiController.io.wr_data_en
    gowin_DDR3.io.wr_data_mask := axiController.io.wr_data_mask

    axiController.io.cmd_ready := gowin_DDR3.io.cmd_ready
    axiController.io.wr_data_rdy := gowin_DDR3.io.wr_data_rdy
    axiController.io.rd_data := gowin_DDR3.io.rd_data
    axiController.io.rd_data_valid := gowin_DDR3.io.rd_data_valid
    axiController.io.init_calib_complete := gowin_DDR3.io.init_calib_complete

    gowin_DDR3.connectDDR3Interface(io.ddr_iface)
  }
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
