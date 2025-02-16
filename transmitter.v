`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 03:56:42 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter(
    input wire clk,              // 100MHz system clock
    input wire rst,              // Reset button
    output reg tx_data,          // Single wire output
    output reg [7:0] led        // LEDs to display current data
);

    reg [7:0] data_to_send = 8'b10110011;  // Example data pattern
    reg [31:0] counter = 0;
    reg [3:0] bit_index = 0;
    reg sending = 0;
    
    // States
    localparam SHOW = 1'b0;
    localparam TRANSMIT = 1'b1;
    reg state = SHOW;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            bit_index <= 0;
            tx_data <= 0;
            led <= 0;
            state <= SHOW;
            sending <= 0;
        end else begin
            case (state)
                SHOW: begin
                    led <= data_to_send;
                    if (counter >= 100_000_000) begin  // Wait 1 second
                        state <= TRANSMIT;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                TRANSMIT: begin
                    if (!sending) begin
                        tx_data <= 1;  // Start bit
                        sending <= 1;
                        counter <= 0;
                    end else if (counter >= 10_000_000) begin  // 0.1 second per bit
                        counter <= 0;
                        if (bit_index < 8) begin
                            tx_data <= data_to_send[bit_index];
                            bit_index <= bit_index + 1;
                        end else begin
                            tx_data <= 0;  // Stop bit
                            state <= SHOW;
                            bit_index <= 0;
                            sending <= 0;
                        end
                    end else begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end
endmodule

