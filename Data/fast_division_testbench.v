module fast_division_testbench;
  
  reg signed [15:0] dividend;
  reg signed [7:0] divisor;
  wire signed [15:0] quotient;
  wire signed [7:0] remainder;
  wire done;
  
  fast_division dut (
    .dividend(dividend),
    .divisor(divisor),
    .quotient(quotient),
    .remainder(remainder),
    .done(done)
  );
  
  reg signed [15:0] expected_quotient;
  reg signed [7:0] expected_remainder;
  reg expected_done;
  
  always @(posedge done) begin
    expected_quotient <= quotient;
    expected_remainder <= remainder;
    expected_done <= done;
  end
  
  initial begin
    $dumpfile("fast_division.vcd");
    $dumpvars(0, fast_division_testbench);
    
    dividend = 256;
    divisor = 8;
    expected_quotient = dividend / divisor;
    expected_remainder = dividend % divisor;
    
    #10;
    
    dividend = -1234;
    divisor = 17;
    expected_quotient = dividend / divisor;
    expected_remainder = dividend % divisor;
    
    #10;
    
    dividend = 1024;
    divisor = -32;
    expected_quotient = dividend / divisor;
    expected_remainder = dividend % divisor;
    
    #10;
    
    $finish;
  end
  
  always @(posedge expected_done) begin
    $display("Dividend: %d, Divisor: %d, Quotient: %d, Remainder: %d", dividend, divisor, expected_quotient, expected_remainder);
  end
  
endmodule