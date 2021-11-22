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
localparam OUTLINE		= 4'b0100;
localparam WAIT			= 4'b1000;
reg [3:0] state = INIT;
reg [3:0] sstate = 0;


wire reset;
reg uart_dv = 0;
reg [7:0] uart_cout = 0;
reg [31:0] count = 0;
reg [9:0] bptr = 0;
reg [7:0] RAM [0:666];


assign reset = ~SW0;
assign LED = {sstate, state}; //{count[26:23], state};

integer i;
initial begin
	$readmemh("screen.hex", RAM, 0, 666);
end

uart_tx #(.CLKS_PER_BIT((100000000)/115200)) uart_tx_0 (
	.i_Clock(clk),
	.i_TX_DV(uart_dv),			// start sending the bits
	.i_TX_Byte(uart_cout),		// char to send
	.o_TX_Active(uart_active),
	.o_TX_Serial(uart_tx),
	.o_TX_Done());

always @(posedge clk)
	if (reset) begin
		uart_dv <= 0;
		count = 0;
		bptr <= 0;
		state <= INIT;
		sstate <= 0;
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
					if (count == 32'd5)
						bptr <= bptr + 1;
					if (count == 32'd10)
						uart_dv <= 1;
				end
			end // INIT
			IDLE : begin
				if (count == 100000000) begin
					bptr <= 588;
					count = 0;
					state <= OUTLINE;
				end
			end // IDLE
			OUTLINE : begin
				if (bptr == 667)
					state <= IDLE;
				uart_cout <= RAM[bptr];
				if (uart_active) begin
					uart_dv <= 0;
					count = 0;
				end else begin
					if (count == 32'd5)
						bptr <= bptr + 1;
					if (count == 32'd10)
						uart_dv <= 1;
				end
			end
		endcase
		count = count + 1;
	end

endmodule
