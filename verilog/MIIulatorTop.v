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

module MIIulatorTop(
	input		clk,
	input		SW0,
	input		uart_rx,
	output		uart_tx_serial,
	output 		[7:0]LED,
	input		mii0_en,
	input		mii0_clk,
	input		[3:0]mii0_d
);

wire reset = 0;
wire rdy;
reg rdy_i = 0; // rdy inhibit
wire error = 0;
wire [7:0] d;
reg [7:0] uart_d = 0;
reg uart_dv = 0;
wire uart_active;
reg [7:0] fifo [0:63];
reg [5:0] inptr = 0;
reg [5:0] outptr = 0;

reg [7:0] hex [0:15];

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


always @(posedge clk) begin
	if (reset) begin
		rdy_i <= 0;
		inptr <= 0;
		outptr <= 0;
	end else begin
		if (rdy) begin
			if (!rdy_i) begin
				fifo[inptr] <= d;
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

MIIcore MII0 (
	.clk(clk),
	.reset(reset),
	.rdy(rdy),
	.error(error),
	.d(d),
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
