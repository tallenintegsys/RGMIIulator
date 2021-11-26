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
reg		[0:3] rgm0_d	= 4'b0000;
wire		d3;
wire		d2;
wire		d1;
wire		d0;

assign	d3 = rgm0_d[3];
assign	d2 = rgm0_d[2];
assign	d1 = rgm0_d[1];
assign	d0 = rgm0_d[0];

localparam dst = 48'h54_ff_01_21_23_24;
localparam src = 48'h12_34_56_78_9a_bc;
localparam type =16'h0000;

integer i;
initial begin
	$dumpfile("RGMIIulator.vcd");
	$dumpvars(0, RGMIIulator_tb);
	#0	SW0 = 0;
	#5	SW0 = 1;
	#10;
	rgm0_en = 1;
	//preamble
	for (i=0; i<15; i=i+1)
		#40 rgm0_d = 4'b1010;
	//start of frame delimeter
	#40 rgm0_d = 4'b1011;
	//dst
	#40 rgm0_d = {dst[40],dst[41],dst[42],dst[43]};
	#40 rgm0_d = {dst[44],dst[45],dst[46],dst[47]};
	#40 rgm0_d = {dst[32],dst[33],dst[34],dst[35]};
	#40 rgm0_d = {dst[36],dst[37],dst[38],dst[39]};
	#40 rgm0_d = {dst[24],dst[25],dst[26],dst[27]};
	#40 rgm0_d = {dst[28],dst[29],dst[30],dst[31]};
	#40 rgm0_d = {dst[16],dst[17],dst[18],dst[19]};
	#40 rgm0_d = {dst[20],dst[21],dst[22],dst[23]};
	#40 rgm0_d = {dst[8],dst[9],dst[10],dst[11]};
	#40 rgm0_d = {dst[12],dst[13],dst[14],dst[15]};
	#40 rgm0_d = {dst[0],dst[1],dst[2],dst[3]};
	#40 rgm0_d = {dst[4],dst[5],dst[6],dst[7]};
	//src
	#40 rgm0_d = {src[40],src[41],src[42],src[43]};
	#41 rgm0_d = {src[44],src[45],src[46],src[47]};
	#40 rgm0_d = {src[32],src[33],src[34],src[35]};
	#40 rgm0_d = {src[36],src[37],src[38],src[39]};
	#40 rgm0_d = {src[24],src[25],src[26],src[27]};
	#40 rgm0_d = {src[28],src[29],src[30],src[31]};
	#40 rgm0_d = {src[16],src[17],src[18],src[19]};
	#40 rgm0_d = {src[20],src[21],src[22],src[23]};
	#40 rgm0_d = {src[8],src[9],src[10],src[11]};
	#40 rgm0_d = {src[12],src[13],src[14],src[15]};
	#40 rgm0_d = {src[0],src[1],src[2],src[3]};
	#40 rgm0_d = {src[4],src[5],src[6],src[7]};
	//type
	#40 rgm0_d = type[15:12];
	#40 rgm0_d = type[11:8];
	#40 rgm0_d = type[7:4];
	#40 rgm0_d = type[3:0];

	#100	$finish;
end

always #10 clk = !clk;
always #20 rgm0_clk = !rgm0_clk;


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
