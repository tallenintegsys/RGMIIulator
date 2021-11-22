`timescale 1ns / 1ps

///////////////////////////////////////
// This is easier in System Verilog! //
/////////////////////////////////////// 

module buffer (
	input	[5:0]addr,
	output	reg [7:0]data
);
always @* begin
case(addr)
	6'h00 : data = 8'h57;
	6'h01 : data = 8'h68;
	6'h02 : data = 8'h61;
	6'h03 : data = 8'h74;
	6'h04 : data = 8'h20;
	6'h05 : data = 8'h77;
	6'h06 : data = 8'h65;
	6'h07 : data = 8'h20;
	6'h08 : data = 8'h68;
	6'h09 : data = 8'h61;
	6'h0a : data = 8'h76;
	6'h0b : data = 8'h65;
	6'h0c : data = 8'h20;
	6'h0d : data = 8'h68;
	6'h0e : data = 8'h65;
	6'h0f : data = 8'h72;
	6'h10 : data = 8'h65;
	6'h11 : data = 8'h20;
	6'h12 : data = 8'h69;
	6'h13 : data = 8'h73;
	6'h14 : data = 8'h20;
	6'h15 : data = 8'h61;
	6'h16 : data = 8'h20;
	6'h17 : data = 8'h66;
	6'h18 : data = 8'h61;
	6'h19 : data = 8'h69;
	6'h1a : data = 8'h6c;
	6'h1b : data = 8'h75;
	6'h1c : data = 8'h72;
	6'h1d : data = 8'h65;
	6'h1e : data = 8'h20;
	6'h1f : data = 8'h74;
	6'h20 : data = 8'h6f;
	6'h21 : data = 8'h20;
	6'h22 : data = 8'h63;
	6'h23 : data = 8'h6f;
	6'h24 : data = 8'h6d;
	6'h25 : data = 8'h6d;
	6'h26 : data = 8'h75;
	6'h27 : data = 8'h6e;
	6'h28 : data = 8'h69;
	6'h29 : data = 8'h63;
	6'h2a : data = 8'h61;
	6'h2b : data = 8'h74;
	6'h2c : data = 8'h65;
	6'h2d : data = 8'h21;
	6'h2e : data = 8'h0d;
	6'h2f : data = 8'h0a;
	default: data = 8'h00;
endcase 
end
endmodule
