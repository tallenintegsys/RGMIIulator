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
reg		[2:0] idle_count = 0;
reg		mii_en = 0;

always @(posedge mii_clk) begin
	if (reset) begin
		rdy <= 0;
		nibble <= 0;
		idle_count <= 0;
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
			//d <= r;
		end

		if (mii_d == 4'h0) begin
			if (idle_count < 5) begin
				idle_count <= idle_count + 1;
			end else begin
				mii_en <= 0;
				nibble <= 0;
			end
		end else begin
			idle_count <= 0;
			mii_en <= 1;
			nibble <= 1;
		end

		if (mii_en) begin
			nibble <= !nibble;
		end
	end // reset
end // always
endmodule

`endif
