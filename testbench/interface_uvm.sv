interface fifo_inf(input logic clk1, clk2);
  
  logic wrst_n, rrst_n;						// reset signal
  logic rd_en, wr_en;         				// read and write signals
  logic full, empty,almost_full,almost_empty; 		// Flags indicating FIFO status
  logic [7:0] din;         				// Data input
  logic [7:0] dout;        				// Data output             				
endinterface

