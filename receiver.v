`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 04:08:17 PM
// Design Name: 
// Module Name: receiver
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

module receiver(
    input wire clk,              // 100MHz system clock
    input wire rst,              // Reset button
    input wire rx_data,          // Single wire input
    output reg [7:0] led        // LEDs to display received data
);

    reg [7:0] received_data;
    reg [31:0] counter = 0;
    reg [3:0] bit_index = 0;
    reg receiving = 0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            bit_index <= 0;
            received_data <= 0;
            led <= 0;
            receiving <= 0;
        end else begin
            if (!receiving && rx_data) begin  // Detect start bit
                receiving <= 1;
                counter <= 0;
                bit_index <= 0;
            end else if (receiving) begin
                if (counter >= 10_000_000) begin  // Sample every 0.1 second
                    counter <= 0;
                    if (bit_index < 8) begin
                        received_data[bit_index] <= rx_data;
                        bit_index <= bit_index + 1;
                    end else begin
                        if (!rx_data) begin  // Check stop bit
                            led <= received_data;  // Update display
                        end
                        receiving <= 0;
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule
