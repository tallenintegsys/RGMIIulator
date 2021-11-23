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
	input		clk,
	input		SW0,
	input		uart_rx,
	output		uart_tx,
	output 		[7:0]LED,
	input		rgm0_en,
	input		rgm0_clk,
	input		[3:0]rgm0_d
);

localparam INIT			= 4'b0001;
localparam IDLE			= 4'b0010;
localparam ASSEMBLE		= 4'b0100;
localparam OUTLINE		= 4'b1000;
reg [3:0] state = INIT;

wire reset;
reg uart_dv = 0;
reg [7:0] uart_cout = 0;
reg [29:0] count = 0;
reg [9:0] bptr = 0;			// char ptr
reg [7:0] RAM [0:1023];		// serial header

reg [2047:0] FIFO [0:63];
reg [10:0] nibble = 0;
reg [5:0] pktsin = 0;
reg [5:0] pktsout = 0;
reg pktRXd = 0;

reg [2047:0] line;
reg [5:0] lineptr;
reg [7:0] hex [0:15];
reg [5:0] bcount = 0;
reg error = 0;

assign reset = ~SW0;
assign LED = {count[26:23], error, state};

initial begin
	$readmemh("screen.hex", RAM, 0, 666);
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
		count = 0;
		bptr <= 0;
		pktsout <= 0;
		state <= INIT;
		error <= 0;
	end else begin
		case (state)
			INIT : begin
				if (bptr == 667)
					state <= IDLE;
				uart_cout <= RAM[bptr];
				if (uart_active) begin
					uart_dv <= 0;
					count = 0;
				end else begin
					if (count == 5)
						bptr <= bptr + 1;
					if (count == 10)
						uart_dv <= 1;
				end
			end // INIT
			IDLE : begin
				if (pktsin != pktsout) begin
					pktsout <= pktsout + 1;
					bcount = 0;
					state <= ASSEMBLE;
				end
			end // IDLE
			ASSEMBLE : begin
				line <= FIFO[pktsout];
				bcount = bcount + 1;
				if (bcount == 63) begin
					count = 0;
					state <= OUTLINE;
				end
			end // ASSEMBLE
			OUTLINE : begin
				if (bptr == 6'd63)
					state <= IDLE;
				uart_cout <= line[lineptr];
				if (uart_active) begin
					uart_dv <= 0;
					count = 0;
				end else begin
					if (count == 5)
						lineptr <= lineptr + 1;
					if (count == 10)
						uart_dv <= 1;
				end
			end // OUTLINE
			default :
				error <= 1;
		endcase
		count = count + 1;
	end
end

always @(posedge rgm0_clk) begin
	if (reset) begin
		nibble <= 0;
		pktsin <= 0;
		pktRXd <= 0;
	end else begin
		if (rgm0_en) begin
			FIFO[pktsin][nibble+0] <= rgm0_d[0];
			FIFO[pktsin][nibble+1] <= rgm0_d[1];
			FIFO[pktsin][nibble+2] <= rgm0_d[2];
			FIFO[pktsin][nibble+3] <= rgm0_d[3];
			nibble <= nibble + 4;
			pktRXd <= 1;
		end else begin
			if (pktRXd) begin
				pktsin <= pktsin + 1;
				pktRXd <= 0;
			end
		end
	end
end


endmodule
