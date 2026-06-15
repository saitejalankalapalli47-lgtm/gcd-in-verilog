`timescale 1ns / 1ps

module gcd(clk,rst,go,in1,in2,out,done);
input [7:0]in1,in2;
input clk,rst,go;
output  [7:0] out;
output done;
wire a_gt_b,a_lt_b,a_eq_b,a_sel,b_sel,a_ld,b_ld,out_en;

controlpath c1(clk,rst,go,a_gt_b,a_lt_b,a_eq_b,a_sel,b_sel,a_ld,b_ld,out_en,done);

datapath d1(clk,rst,in1,in2,a_sel,b_sel,a_ld,b_ld,out_en,out,a_gt_b,a_lt_b,a_eq_b);

endmodule

//datapath module

module datapath(clk,rst,in1,in2,a_sel,b_sel,a_ld,b_ld,out_en,out,a_gt_b,a_lt_b,a_eq_b);
input clk,rst,a_sel,b_sel,a_ld,b_ld,out_en;
input [7:0] in1,in2;
output [7:0]out;
output a_gt_b,a_lt_b,a_eq_b;
wire [7:0]aout,bout,t1,t2,out1,out2;
//subtractors 
subtractor s1(aout,bout,t1);
subtractor s2(bout,aout,t2);
//multiplexers
mux m1(t1,in1,a_sel,out1);
mux m2(t2,in2,b_sel,out2);
//registers
register reg1(clk,rst,a_ld,out1,aout);
register reg2(clk,rst,b_ld,out2,bout);
register reg3(clk,rst,out_en,aout,out);
//comparator 
comparator c1(aout,bout,a_gt_b,a_lt_b,a_eq_b);
endmodule

//subtractor module
module subtractor(a,b,out);
input [7:0]a,b;
output [7:0] out;
assign out=a-b;
endmodule

//multiplexer module
module mux (a,b,sel,out);
input [7:0]a,b;
input sel;
output reg [7:0] out;
always@(*)
begin
if(sel==0)
out=a;
else
out=b;
end
endmodule

//register module
module register(clk,rst,ld,in,out);
input clk,rst,ld;
input [7:0] in;
output reg [7:0] out;
always@(posedge clk)
begin
if(rst==1)
out<=0;
else if(ld==1)
out<=in;
end
endmodule

//comparator module
module comparator (a,b,g,l,e);
input [7:0] a,b;
output g,l,e;
assign g=(a>b)?1:0;
assign l=(a<b)?1:0;
assign e=(a==b)?1:0;
endmodule

//controlpath module
module controlpath (clk,rst,go,a_gt_b,a_lt_b,a_eq_b,a_sel,b_sel,a_ld,b_ld,out_en,done);
input clk,rst,go,a_gt_b,a_lt_b,a_eq_b;
output reg a_sel,b_sel,a_ld,b_ld,out_en,done;
reg [2:0] ps,ns;
parameter s0=3'b000;
parameter s1=3'b001;
parameter s2=3'b010;
parameter s3=3'b011;
parameter s4=3'b100;
parameter s5=3'b101;
parameter s6=3'b110;
parameter s7=3'b111;
always@(posedge clk)
begin
if(rst==1)
ps=s0;
else
ps=ns;
end
always@(go or a_gt_b or a_lt_b or a_eq_b or ps)
begin
case({ps})
s0: if(go==0)
      ns=s0;
    else
      ns=s1;
s1: ns=s2;
s2: ns=s3;
s3: if(a_gt_b==1)
ns=s4;
    else if(a_lt_b==1)
      ns=s5;
    else
      ns=s7;
s4: ns=s6;
s5: ns=s6;
s6: ns=s3;
s7: ns=s0;
endcase
end
always@(ps)
begin
case({ps})
s0: begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 0; 
     b_ld = 0; 
     done = 0; 
     out_en =0; 
     end
s1: begin 
     a_sel = 1; 
     b_sel = 1; 
     a_ld = 1; 
     b_ld = 1; 
     done = 0; 
     out_en =0; 
     end
s2:begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 0; 
     b_ld = 0; 
     done = 0; 
     out_en =0; 
     end
s3:begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 0; 
     b_ld = 0; 
     done = 0; 
     out_en =0; 
     end
s4:begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 1; 
     b_ld = 0; 
     done = 0; 
     out_en =0; 
     end
s5:begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 0; 
     b_ld = 1; 
     done = 0; 
     out_en =0; 
     end
s6:begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 0; 
     b_ld = 0; 
     done = 0; 
     out_en =0; 
     end
s7:begin 
     a_sel = 0; 
     b_sel = 0; 
     a_ld = 0; 
     b_ld = 0; 
     done = 1; 
     out_en =1; 
     end
endcase
end
endmodule

//testbench code
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