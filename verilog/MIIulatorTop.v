`timescale 1ns / 1ps
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

module RGMIIulator_top(
	input		clk,
	input		SW0,
	input		uart_rx,
	output		uart_tx,
	output 		[7:0]LED,
	input		rgm0_en,
	input		rgm0_clk,
	input		[3:0]rgm0_d
);

wire reset;
reg uart_dv = 0;
reg [7:0] uart_cout = 0;
wire uart_active;

reg [7:0] FIFO [0:63];
reg [5:0] fifoin = 0;
reg [5:0] fifout = 0;
reg nibble = 0;

reg [7:0] hex [0:15];
reg error = 0;

assign reset = ~SW0;
assign LED = {error};

initial begin
	hex[4'h0] = "0";
	hex[4'h1] = "1";
	hex[4'h2] = "2";
	hex[4'h3] = "3";
	hex[4'h4] = "4";
	hex[4'h5] = "5";
	hex[4'h6] = "6";
	hex[4'h7] = "7";
	hex[4'h8] = "8";
	hex[4'h9] = "9";
	hex[4'ha] = "a";
	hex[4'hb] = "b";
	hex[4'hc] = "c";
	hex[4'hd] = "d";
	hex[4'he] = "e";
	hex[4'hf] = "f";
end

uart_tx #(.CLKS_PER_BIT((100000000)/115200)) uart_tx_0 (
	.i_Clock(clk),
	.i_TX_DV(uart_dv),			// start sending the bits
	.i_TX_Byte(uart_cout),		// char to send
	.o_TX_Active(uart_active),
	.o_TX_Serial(uart_tx),
	.o_TX_Done());

always @(posedge clk) begin
	if (reset) begin
		uart_dv <= 0;
		fifout <= 0;
		error <= 0;
	end else begin
		uart_cout <= FIFO[fifout];
		if (fifoin != fifout) begin
			if (uart_active) begin
				uart_dv <= 0;
			end else begin
				fifout <= fifout + 1;
				uart_dv <= 1;
			end
		end
	end
end


endmodule
