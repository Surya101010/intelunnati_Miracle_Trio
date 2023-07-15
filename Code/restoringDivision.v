module restoringDivision(clk,rst,start,X,Y,valid,quot,rem);

input clk;
input rst;
input start;
input [7:0]X,Y;
output [7:0]quot,rem;
output valid;

reg [15:0] Z,next_Z,Z_temp,Z_temp1;
reg next_state, pres_state;
reg [3:0] count,next_count;
reg valid, next_valid;

parameter IDLE = 1'b0;
parameter START = 1'b1;

assign rem = Z[15:8];
assign quot = Z[7:0];

always @ (posedge clk or negedge rst)
begin
if(!rst)
begin
  Z          <= 16'd0;
  valid      <= 1'b0;
  pres_state <= 1'b0;
  count      <= 4'd0;
end
else
begin
  Z          <= next_Z;
  valid      <= next_valid;
  pres_state <= next_state;
  count      <= next_count;
end
end

always @ (*)
begin 
case(pres_state)
IDLE:
begin
next_count = 4'b0;
next_valid = 1'b0;
if(start)
begin
    next_state = START;
    next_Z     = {8'd0,X};
end
else
begin
    next_state = pres_state;
    next_Z     = 16'd0;
end
end

START:
begin
next_count = count + 1'b1;
Z_temp     = Z << 1;
Z_temp1    = {Z_temp[15:8]-Y,Z_temp[7:0]};
next_Z     = Z_temp1[15] ? {Z_temp[15:8],Z_temp[7:1],1'b0} : 
                          {Z_temp1[15:8],Z_temp[7:1],1'b1};
next_valid = (&count) ? 1'b1 : 1'b0; 
next_state = (&count) ? IDLE : pres_state;	
end
endcase
end
endmodule