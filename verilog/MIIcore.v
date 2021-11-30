`timescale 1ns / 1ps

module MIIcore (
	input 		reset,
	output reg 	rdy = 0,
	output reg 	[7:0] d = 0,
	// MII interface
	input		mii_clk,
	input 		mii_en,
	input		[3:0]mii_d);

reg		[7:0]r = 8'd0;
reg		nibble = 0;

always @(posedge mii_clk) begin
	if (reset) begin
		rdy <= 0;
		nibble <= 0;
	end else begin
		if (rdy)
			rdy <= 0;
		if (nibble) begin
			d[4] <= mii_d[3]; // high order nibble
			d[5] <= mii_d[2];
			d[6] <= mii_d[1];
			d[7] <= mii_d[0];
			rdy <= 1;
		end else begin
			d[0] <= mii_d[3]; // low order nibble
			d[1] <= mii_d[2];
			d[2] <= mii_d[1];
			d[3] <= mii_d[0];
			//d <= r;
		end
		if (mii_en) begin
			nibble <= !nibble;
		end else begin
			nibble <= 0;
		end
	end // reset
end // always
endmodule
