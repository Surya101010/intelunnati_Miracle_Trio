module fast_division (
  input wire signed [15:0] dividend,
  input wire signed [7:0] divisor,
  output reg signed [15:0] quotient,
  output reg signed [7:0] remainder,
  output reg done
);

  reg signed [15:0] div_op;
  reg signed [7:0] div_op_abs;
  reg signed [7:0] shift_reg;
  reg signed [15:0] quotient_reg;
  reg signed [7:0] count;
  reg [3:0] state;
  
  always @(*) begin
    case (state)
      0: begin
        if (dividend[15] == 1)
          div_op = -dividend;
        else
          div_op = dividend;
        div_op_abs = (div_op[15] == 1) ? (~div_op + 1) : div_op;
        shift_reg = divisor;
        count = 8;
        quotient_reg = 0;
        state = 1;
      end
      1: begin
        if (div_op[15] == 1'b0) begin
          shift_reg = shift_reg << 1;
          count = count - 1;
          state = 2;
        end
        else begin
          shift_reg = shift_reg >> 1;
          count = count - 1;
          state = 3;
        end
      end
      
      2: begin
        if (div_op_abs >= shift_reg) begin
          div_op = div_op - shift_reg;
          quotient_reg[count] = 1;
        end
        shift_reg = shift_reg >> 1;
        count = count - 1;
        if (count == 0)
          state = 4;
        else
          state = 1;
      end
      
      3: begin
        div_op = div_op + shift_reg;
        quotient_reg[count] = 0;
        shift_reg = shift_reg >> 1;
        count = count - 1;
        if (count == 0)
          state = 4;
        else
          state = 1;
      end
      
      4: begin
        remainder = div_op;
        quotient = quotient_reg;
        done = 1;
        state = 0;
      end
    endcase
  end
  
endmodule
