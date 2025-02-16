`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 04:33:32 PM
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_tb();

    reg clk;
    reg rst_n;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx;
    wire tx_done;
    wire [7:0] rx_data;
    wire rx_done;


    uart_tx #(
        .CLKS_PER_BIT(434)
    ) uart_tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_done(tx_done)
    );


    uart_rx #(
        .CLKS_PER_BIT(434)
    ) uart_rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

 
always begin
    #5 clk = ~clk; // 100MHz clock
end


    initial begin
        clk = 0;
        rst_n = 0;
        tx_data = 8'h00;
        tx_start = 0;

        #100 rst_n = 0;
        #100 rst_n = 1;

        #100;

        tx_data = 8'hD5;
        tx_start = 1;
        #10 tx_start = 0;
        
        wait(tx_done);
        wait(rx_done);
        #1000000;

        
        wait(tx_done);
        wait(rx_done);
        #1000;

        $finish;
    end

endmodule