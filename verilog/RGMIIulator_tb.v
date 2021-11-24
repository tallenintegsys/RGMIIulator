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
module RGMIIulator_tb;
reg		clk				= 0;
reg		SW0				= 0;
reg		uart_rx;
wire	uart_tx			= 0;
wire	[7:0]LED		= 8'b00000000;
reg		rgm0_en			= 0;
reg		rgm0_clk		= 0;
reg		[3:0] rgm0_d	= 4'b0000;

initial begin
	$dumpfile("RGMIIulator.vcd");
    	$dumpvars(0, RGMIIulator_tb);
	#0		SW0 = 0;
	#1		SW0 = 1;
	#100	$finish;
end

always #10 clk = !clk;
always #40 rgm0_clk = !rgm0_clk;

RGMIIulator_top uut(
	.clk(clk),
	.SW0(SW0),
	.uart_rx(uart_rx),
	.uart_tx(uart_tx),
	.LED(LED),
	.rgm0_en(rgm0_en),
	.rgm0_clk(rgm0_clk),
	.rgm0_d(rgm0_d)
);
endmodule
