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

localparam IDLE			= 3'b001;
localparam PUTCHR		= 3'b010;
localparam WAIT			= 3'b100;
reg [2:0] state = IDLE;

wire reset;
reg uart_dv = 0;
reg [7:0] uart_cout = 0;
reg [31:0] count;
reg [9:0] bptr = 0;
reg [7:0] RAM [0:664];


assign reset = ~SW0;
assign LED = {count[26:22], state};

integer i;
initial begin
	$readmemh("screen.hex", RAM, 0, 664);
	for (i=0; i < 664; i=i+1) begin
		//$display("RAM[%d] = %h", i, RAM[i]);
	end
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
		count <= 0;
		bptr <= 0;
		state <= IDLE;
	end else begin
		case (state)
			IDLE : begin
				if (!uart_active)
					state <= PUTCHR;
			end // IDLE
			PUTCHR : begin
				uart_cout <= RAM[bptr];
				uart_dv <= 1;
				count <= 0;
				state <= WAIT;
			end // PUTCHR
			WAIT : begin
				uart_dv <= 0;
				if (count[21]) begin // wait for a while
					if (bptr == 10'd664)
						bptr <= 0;
					else
						bptr <= bptr + 10'd1;
					state <= IDLE;
				end
			end // WAIT
		endcase
		count <= count + 1;
	end

endmodule
