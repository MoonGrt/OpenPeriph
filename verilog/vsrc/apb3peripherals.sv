module Apb3Peripherals (
  input logic pclk, presetn,
  input logic psel, penable, pwrite,
  input logic [19:0] paddr,
  input logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic pready, pslverr,
  input logic [15:0] gpioa_read, gpiob_read,
  output logic [15:0] gpioa_write, gpiob_write,
  output logic [15:0] gpioa_write_enable, gpiob_write_enable,
  input logic uart_rxd,
  output logic uart_txd,
  output logic [3:0] timer_channel,
  output logic uart_interrupt, timer_interrupt, systick_interrupt,
  output logic [15:0] exti_interrupt,
  output logic iwdg_reset, wwdg_reset,
  input logic i2c_sda_in,
  output logic i2c_scl, i2c_sda_out, i2c_sda_output_enable, i2c_interrupt,
  input logic spi_miso,
  output logic spi_sclk, spi_mosi, spi_nss, spi_interrupt,
  input logic can_rx,
  output logic can_tx, can_interrupt,
  input logic sdio_cmd_in,
  input logic [3:0] sdio_data_in,
  output logic sdio_clk, sdio_cmd_out, sdio_cmd_output_enable,
  output logic [3:0] sdio_data_out, sdio_data_output_enable,
  output logic sdio_interrupt,
  output logic vga_hsync, vga_vsync, vga_de,
  output logic [23:0] vga_rgb
);
  logic [14:0] select;
  logic [31:0] rdata[0:14];
  logic [14:0] ready, error;
  logic [15:0] afio_exti;
  logic crc_interrupt;
  assign select[0]=psel&&paddr[19:12]==8'h00;
  assign select[1]=psel&&paddr[19:12]==8'h01;
  assign select[2]=psel&&paddr[19:16]==4'h1;
  assign select[3]=psel&&paddr[19:16]==4'h4;
  assign select[4]=psel&&paddr[19:16]==4'h6;
  assign select[5]=psel&&paddr[19:16]==4'hd;
  assign select[6]=psel&&paddr[19:16]==4'he;
  assign select[7]=psel&&paddr[19:16]==4'h5&&!paddr[10];
  assign select[8]=psel&&paddr[19:16]==4'h5&&paddr[10];
  assign select[9]=psel&&paddr[19:16]==4'h2;
  assign select[10]=psel&&paddr[19:16]==4'h3;
  assign select[11]=psel&&paddr[19:16]==4'hb;
  assign select[12]=psel&&paddr[19:16]==4'h9;
  assign select[13]=psel&&paddr[19:16]==4'ha;
  assign select[14]=psel&&paddr[19:16]==4'h7;

  Apb3Gpio gpioa(pclk,presetn,select[0],penable,pwrite,paddr[4:0],pwdata,rdata[0],ready[0],error[0],gpioa_read,16'b0,gpioa_write,gpioa_write_enable);
  Apb3Gpio gpiob(pclk,presetn,select[1],penable,pwrite,paddr[4:0],pwdata,rdata[1],ready[1],error[1],gpiob_read,16'b0,gpiob_write,gpiob_write_enable);
  Apb3Uart uart(pclk,presetn,select[2],penable,pwrite,paddr[11:0],pwdata,rdata[2],ready[2],error[2],uart_rxd,uart_txd,uart_interrupt);
  Apb3Tim timer(pclk,presetn,select[3],penable,pwrite,paddr[6:0],pwdata,rdata[3],ready[3],error[3],timer_channel,timer_interrupt);
  Apb3SysTick systick(pclk,presetn,select[4],penable,pwrite,paddr[3:0],pwdata,rdata[4],ready[4],error[4],systick_interrupt);
  Apb3Afio afio(pclk,presetn,select[5],penable,pwrite,paddr[4:0],pwdata,rdata[5],ready[5],error[5],{gpiob_read,gpioa_read},afio_exti);
  Apb3Exti exti_ctrl(pclk,presetn,select[6],penable,pwrite,paddr[4:0],pwdata,rdata[6],ready[6],error[6],afio_exti,exti_interrupt);
  Apb3Iwdg iwdg(pclk,presetn,select[7],penable,pwrite,paddr[3:0],pwdata,rdata[7],ready[7],error[7],iwdg_reset);
  Apb3Wwdg wwdg(pclk,presetn,select[8],penable,pwrite,paddr[4:0],pwdata,rdata[8],ready[8],error[8],wwdg_reset);
  Apb3I2c i2c(pclk,presetn,select[9],penable,pwrite,paddr[5:0],pwdata,rdata[9],ready[9],error[9],i2c_sda_in,i2c_scl,i2c_sda_out,i2c_sda_output_enable,i2c_interrupt);
  Apb3Spi spi(pclk,presetn,select[10],penable,pwrite,paddr[5:0],pwdata,rdata[10],ready[10],error[10],spi_miso,spi_sclk,spi_mosi,spi_nss,spi_interrupt);
  Apb3Crc crc_ctrl(pclk,presetn,select[11],penable,pwrite,paddr[4:0],pwdata,rdata[11],ready[11],error[11],crc_interrupt);
  Apb3Can can(pclk,presetn,select[12],penable,pwrite,paddr[9:0],pwdata,rdata[12],ready[12],error[12],can_rx,can_tx,can_interrupt);
  Apb3Sdio sdio(pclk,presetn,select[13],penable,pwrite,paddr[7:0],pwdata,rdata[13],ready[13],error[13],sdio_cmd_in,sdio_data_in,sdio_clk,sdio_cmd_out,sdio_cmd_output_enable,sdio_data_out,sdio_data_output_enable,sdio_interrupt);
  Apb3Vga vga(pclk,presetn,select[14],penable,pwrite,paddr[7:0],pwdata,rdata[14],ready[14],error[14],vga_hsync,vga_vsync,vga_de,vga_rgb);

  integer i;
  always_comb begin
    prdata=0; pready=1; pslverr=psel;
    for(i=0;i<15;i++) if(select[i]) begin prdata=rdata[i];pready=ready[i];pslverr=error[i];end
  end
endmodule
