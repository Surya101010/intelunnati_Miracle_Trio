module restoringDivisiontb;

reg clk,rst,start;
reg [7:0]X,Y;
wire [7:0]quot,rem;
wire valid;

always #5 clk = ~clk;

restoringDivision inst (clk,rst,start,X,Y,valid,quot,rem);

initial
$monitor("X=%d, Y=%d, valid=%d, quot=%d, rem=%d ",X,Y,valid,quot,rem);

initial
begin
X=15;Y=8;clk=1'b1;rst=1'b0;start=1'b0;
#10 rst = 1'b1;
#10 start = 1'b1;
#10 start = 1'b0;
@valid
#10 X=10;Y=2;start = 1'b1;
#10 start = 1'b0;
end      
endmodule