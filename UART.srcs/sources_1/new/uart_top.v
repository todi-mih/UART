`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 04:25:49 PM
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input wire clk,          // 100 MHz clock
    input wire rst_n,        // Active low reset
    input wire uart_rx,      // UART receive pin
    output wire uart_tx,     // UART transmit pin
    output reg [7:0] led     // 8 LEDs to display data
);

    wire [7:0] rx_data;
    wire rx_done;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_done;


    uart_rx #(
        .CLKS_PER_BIT(868)
    ) uart_rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx(uart_rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );


    uart_tx #(
        .CLKS_PER_BIT(868)
    ) uart_tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(uart_tx),
        .tx_done(tx_done)
    );


    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam SEND = 2'b01;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            tx_start <= 0;
            tx_data <= 8'h00;
            led <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    tx_start <= 0;
                    if (rx_done) begin
                        led <= rx_data;    // Display received data on LEDs
                        tx_data <= rx_data; // Prepare data to send back
                        state <= SEND;
                    end
                end

                SEND: begin
                    tx_start <= 1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule

