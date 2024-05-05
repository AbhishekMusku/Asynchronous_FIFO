`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
module testbench;

  env env_h;
  fifo_inf fifo();
  asynchronous_fifo dut (fifo.clk1, fifo.wrst_n, fifo.clk2, fifo.rrst_n, fifo.wr_en, fifo.rd_en, fifo.din, fifo.dout, fifo.full, fifo.empty, fifo.almost_full, fifo.almost_empty);
 

	
  initial begin
    fifo.clk1 <= 0;
    fifo.clk2 <= 0;
  end
    
  always #2ns fifo.clk1 <= ~fifo.clk1;
  always #5ns fifo.clk2 <= ~fifo.clk2;
    
  initial begin
    env_h = new(fifo);
    env_h.gen.count = 600;
    env_h.run();
  end
   
   initial begin
   #10000;
   $finish();
   end
endmodule
