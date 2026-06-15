`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2025 21:22:38
// Design Name: 
// Module Name: gcd_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gcd_tb();
reg clk,rst,go;
reg [7:0] in1,in2;
wire [7:0]out;
wire done;
gcd uut(.clk(clk),.rst(rst),.go(go),.in1(in1),.in2(in2),.out(out),.done(done));
initial
begin
clk=0;
forever #5 clk=~clk;
end
initial
begin
rst=1;
#10 rst=0;
#10 go=1;
in1=8'd42;
in2=8'd16;
end
endmodule
