-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sun Oct 12 15:04:30 2025
-- Host        : DESKTOP-MOONGRT running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top sys_Apb3Periph_0_0 -prefix
--               sys_Apb3Periph_0_0_ sys_Apb3Periph_0_0_stub.vhdl
-- Design      : sys_Apb3Periph_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010iclg225-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sys_Apb3Periph_0_0 is
  Port ( 
    io_apb_PADDR : in STD_LOGIC_VECTOR ( 19 downto 0 );
    io_apb_PSEL : in STD_LOGIC_VECTOR ( 0 to 0 );
    io_apb_PENABLE : in STD_LOGIC;
    io_apb_PREADY : out STD_LOGIC;
    io_apb_PWRITE : in STD_LOGIC;
    io_apb_PWDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    io_apb_PRDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    io_apb_PSLVERROR : out STD_LOGIC;
    io_gpio_read : in STD_LOGIC_VECTOR ( 31 downto 0 );
    io_gpio_write : out STD_LOGIC_VECTOR ( 31 downto 0 );
    io_gpio_writeEnable : out STD_LOGIC_VECTOR ( 31 downto 0 );
    io_interrupt : out STD_LOGIC_VECTOR ( 15 downto 0 );
    clk : in STD_LOGIC;
    reset : in STD_LOGIC
  );

end sys_Apb3Periph_0_0;

architecture stub of sys_Apb3Periph_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "io_apb_PADDR[19:0],io_apb_PSEL[0:0],io_apb_PENABLE,io_apb_PREADY,io_apb_PWRITE,io_apb_PWDATA[31:0],io_apb_PRDATA[31:0],io_apb_PSLVERROR,io_gpio_read[31:0],io_gpio_write[31:0],io_gpio_writeEnable[31:0],io_interrupt[15:0],clk,reset";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "Apb3Periph,Vivado 2018.3";
begin
end;
