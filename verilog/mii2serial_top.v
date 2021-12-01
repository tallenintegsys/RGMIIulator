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

module mii2serial_top (
	input		clk,
	input		SW0,
	input		uart_rx_serial,
	output		uart_tx_serial,
	output 		[7:0]LED,
	input		mii0_en,
	input		mii0_clk,
	input		[3:0]mii0_d
);

`ifdef __ICARUS__
wire reset = 0;
`endif
wire mii0_rdy;
reg rdy_i = 0; // rdy inhibit
wire [7:0] mii0_q;
reg [7:0] uart_d = 0;
reg uart_dv = 0;
wire uart_active;
reg [7:0] fifo [0:127];
reg [7:0] inptr = 0;
reg [7:0] outptr = 0;

assign reset = ~SW0;

always @(posedge clk) begin
	if (reset) begin
		rdy_i <= 0;
		inptr <= 0;
		outptr <= 0;
	end else begin
		if (mii0_rdy) begin
			if (!rdy_i) begin
				fifo[inptr] <= mii0_q;
				inptr <= inptr + 1;
				rdy_i <= 1;
			end
		end else begin
			if (!uart_active && !uart_dv && (inptr != outptr)) begin
			uart_d <= fifo[outptr];
			outptr <= outptr + 1;
			uart_dv <= 1;
		end else begin
			uart_dv <= 0;
		end
			rdy_i <= 0;
		end
	end
end

mii MII0 (
	.reset(reset),
	.rdy(mii0_rdy),
	.q(mii0_q),
	// MII interface
	.mii_clk(mii0_clk),
	.mii_en(mii0_en),
	.mii_d(mii0_d));

uart_tx #(.CLKS_PER_BIT((100000000)/115200)) uart_tx_0 (
	.i_Clock(clk),
	.i_TX_DV(uart_dv),			// start sending the bits
	.i_TX_Byte(uart_d),		// char to send
	.o_TX_Active(uart_active),
	.o_TX_Serial(uart_tx_serial),
	.o_TX_Done());

endmodule
