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

covergroup cvr;
option.auto_bin_max = 10;
option.per_instance = 1;
  
  // Coverpoint for write operation
  wr:coverpoint fifo.wr_en {
    bins write_enabled = {1'b1};
    bins write_disabled = {1'b0};
  }
  // Coverpoint for read operation
  rd:coverpoint fifo.rd_en {
    bins read_enabled = {1'b1};
    bins read_disabled = {1'b0};
  }
  // Coverpoint for data input
  din:coverpoint fifo.din {
         bins min = {'h0000000000000000};
         bins others = {['h0000000000000001:'hFFFFFFFFFFFFFFFE]};
         bins max  = {'hFFFFFFFFFFFFFFFF};
  }

  // Coverpoints for FIFO states
  full:coverpoint fifo.full {
    bins full_state = {1'b1};
    bins not_full_state = {1'b0};
  }
  empty:coverpoint fifo.empty {
    bins empty_state = {1'b1};
    bins not_empty_state = {1'b0};
  }
  almost_full:coverpoint fifo.almost_full {
    bins almost_full_state = {1'b1};
    bins not_almost_full_state = {1'b0};
  }
  almost_empty:coverpoint fifo.almost_empty {
    bins almost_empty_state = {1'b1};
    bins not_almost_empty_state = {1'b0};
  }
  // Cross coverage between wr_en and rd_en
  cross wr,rd {
    bins wr_en_and_rd_en = binsof (wr.write_enabled) && binsof (rd.read_enabled);
    bins wr_en_and_not_rd_en = binsof (wr.write_enabled) && binsof (rd.read_disabled);
    bins not_wr_en_and_rd_en = binsof (wr.write_disabled) && binsof (rd.read_enabled);
    bins not_wr_en_and_not_rd_en = binsof (wr.write_disabled) && binsof (rd.read_disabled);
  }
  // Cross coverage between wr_en and full state
  cross wr,full {
    bins wr_en_and_full = binsof (wr.write_enabled) && binsof (full.full_state);
    bins wr_en_and_not_full = binsof (wr.write_enabled) && binsof (full.not_full_state);
    bins not_wr_en_and_full = binsof (wr.write_disabled) && binsof (full.full_state);
    bins not_wr_en_and_not_full = binsof (wr.write_disabled) && binsof (full.not_full_state);
  }
  // Cross coverage between rd_en and empty state
  cross rd,empty {
    bins rd_en_and_empty = binsof (rd.read_enabled) && binsof (empty.empty_state);
    bins rd_en_and_not_empty = binsof (rd.read_enabled) && binsof (empty.not_empty_state);
    bins not_rd_en_and_empty = binsof (rd.read_disabled) && binsof (empty.empty_state);
    bins not_rd_en_and_not_empty = binsof (rd.read_disabled) && binsof (empty.not_empty_state);
  }
endgroup

	cvr cv;
   // min_or_max_on_din din_min_max;

   initial begin : coverage
   
      cv = new();
    //  din_min_max = new();
   
      forever begin @(negedge fifo.clk1);
         cv.sample();
    //     din_min_max.sample();
      end
   end : coverage
   
	 

	
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
