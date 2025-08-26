`timescale 1ns / 1ps
module tb_top;

    // top Parameters
    parameter T = 37.037;  // 时钟周期
    parameter USE_TPG = "true";

    // top Inputs
    reg clk = 0;
    reg rst_n = 0;

    wire [15:0] GPIOA, GPIOB;
    reg  USART1_RX = 1'b1;
    assign GPIOB = {14'bz, USART1_RX, 1'bz};
    wire USART1_TX = GPIOB[0];

    initial begin
        forever #(T / 2) clk = ~clk;
    end

    initial begin
        #(T * 2) rst_n = 1;
        #48000 sim_uart_tx(8'b10101010);  // 调用task 模拟 UART 发送数据
    end

    cyberwithddrlcd cyber (
        .io_clk   (clk),
        .io_rstn  (rst_n)
    );

    // 模拟 UART 发送波形
    task sim_uart_tx(input [7:0] data);
        integer i;
        begin
            USART1_RX = 1'b1;  // Idle状态
            #150;
            USART1_RX = 1'b0;  // 开始位
            #150;
            // 发送数据位
            for (i = 0; i < 8; i = i + 1) begin
                USART1_RX = data[i];  // 发送数据位
                #150;
            end
            USART1_RX = 1'b1;  // 停止位
            #150;
        end
    endtask

endmodule
