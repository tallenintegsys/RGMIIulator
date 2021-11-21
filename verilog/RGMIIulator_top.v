//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:32 11/21/2021 
// Design Name: 
// Module Name:    RGMIIulator_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "uart_tx.v"

module RGMIIulator_top(
	input CLK,
	input SW0,
	input uart_rx,
	output uart_tx,
	output uart_busy,
	input rgm0_en,
	input rgm0_clk,
	input [3:0] rgm0_d
);

wire clk = CLK;
wire reset = SW0;
reg uart_dv = 0;
reg [7:0] uart_cout = 0;

uart_tx #(.CLKS_PER_BIT((100000000)/115200)) uart_tx_0 (
	.i_Clock(clk),
	.i_TX_DV(uart_dv),			// cout is valid
	.i_TX_Byte(uart_cout),		// char to send
	.o_TX_Active(uart_busy),
	.o_TX_Serial(uart_tx),
	.o_TX_Done()
);


always @(posedge clk)
	if (reset) begin
		uart_dv <= 0;
	end else begin
		if (!uart_busy) begin
			uart_cout <= "a";
			uart_dv <= 1;
		end
	end

endmodule
