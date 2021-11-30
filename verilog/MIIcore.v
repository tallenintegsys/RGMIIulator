`timescale 1ns / 1ps

module MIIcore (
	input 		clk,
	input 		reset,
	output reg 	rdy = 0,
	output reg 	error = 0,
	output reg 	[7:0] d = 0,
	// MII interface
	input		mii_clk,
	input 		mii_en,
	input		[3:0]mii_d);

localparam IDL = 0, HON = 1, LON = 2, RDY = 3;
reg [2:0] state = IDL;
reg	[7:0] r = 8'd0;

always @(posedge clk) begin
	if (reset) begin
		rdy <= 0;
		state <= HON;
	end else begin
		case(state)
			HON: begin
				rdy <= 0;
				if (mii_en) begin
					if (mii_clk) begin
						r[4] <= mii_d[3]; // high order nibble
						r[5] <= mii_d[2];
						r[6] <= mii_d[1];
						r[7] <= mii_d[0];
					end else begin
						state <= LON;
					end
				end
			end
			LON: begin
				if (mii_clk) begin
					r[0] <= mii_d[3]; // low order nibble
					r[1] <= mii_d[2];
					r[2] <= mii_d[1];
					r[3] <= mii_d[0];
				end else begin
					d <= r;
					state <= RDY;
				end
			end
			RDY: begin
				rdy <= 1;
				state <= HON;
			end
			default:
				error <= 1;
		endcase
	end
end // always
endmodule
