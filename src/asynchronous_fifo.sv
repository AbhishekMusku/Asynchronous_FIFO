`include "synchronizer.sv"
`include "wptr_handler.sv"
`include "rptr_handler.sv"
`include "fifo_mem.sv"

module asynchronous_fifo #(parameter DEPTH=256, DATA_WIDTH=8) (
  input logic wclk, wrst_n,
  input logic rclk, rrst_n,
  input logic w_en, r_en,
  input logic [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out,
  output reg full, empty, halffull, halfempty
);
  
  parameter PTR_WIDTH = $clog2(DEPTH);
 
  reg [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  reg [PTR_WIDTH:0] b_wptr, b_rptr;
  reg [PTR_WIDTH:0] g_wptr, g_rptr;
 

  wire [PTR_WIDTH-1:0] waddr, raddr;

  synchronizer #(PTR_WIDTH) sync_wptr (rclk, rrst_n, g_wptr, g_wptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_WIDTH) sync_rptr (wclk, wrst_n, g_rptr, g_rptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(PTR_WIDTH) wptr_h(wclk, wrst_n, w_en,g_rptr_sync,b_wptr,g_wptr,full,halffull);
  rptr_handler #(PTR_WIDTH) rptr_h(rclk, rrst_n, r_en,g_wptr_sync,b_rptr,g_rptr,empty,halfempty);
  fifo_mem fifom(wclk, w_en, rclk, r_en,b_wptr, b_rptr, data_in,full,empty, data_out);

endmodule


interface fifo_inf;
  
  bit clk1,clk2, rd_en, wr_en;         		// Clock, read, and write signals
  bit full, empty,almost_full,almost_empty; // Flags indicating FIFO status
  logic [7:0] din;         				// Data input
  logic [7:0] dout;        				// Data output
  logic wrst_n, rrst_n;                   				// Reset signal
 
endinterface
