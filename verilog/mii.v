`ifndef MII_H
`define MII_H
`timescale 1ns / 1ps


module mii (
	input 		reset,
	output reg 	rdy = 0,
	output reg 	[7:0] q = 0,
	// MII interface
	input		mii_clk,
	input		[3:0]mii_d);

reg		nibble = 0;
wire	mii_en;

assign mii_en = mii_d[0] | mii_d[1] | mii_d[2] | mii_d[3];

always @(posedge mii_clk) begin
	if (reset) begin
		rdy <= 0;
		nibble <= 0;
	end else begin
		if (rdy)
			rdy <= 0;
		if (nibble) begin
			q[4] <= mii_d[0]; // high order nibble
			q[5] <= mii_d[1];
			q[6] <= mii_d[2];
			q[7] <= mii_d[3];
			rdy <= 1;
		end else begin
			q[0] <= mii_d[0]; // low order nibble
			q[1] <= mii_d[1];
			q[2] <= mii_d[2];
			q[3] <= mii_d[3];
		end
		if (mii_en) begin
			nibble <= !nibble;
		end else begin
			nibble <= 0;
		end
	end // reset
end // always
endmodule

`endif
