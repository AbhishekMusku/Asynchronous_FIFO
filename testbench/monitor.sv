class monitor;
 
  virtual fifo_inf fifo;     // Virtual interface to the FIFO
  mailbox #(transaction) mbx;  // Mailbox for communication
  transaction tr;          // Transaction object for monitoring
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;   
	tr = new();	
  endfunction;
 
  task run();
    
    forever begin
	@(negedge fifo.clk1);
      tr.wr_en = fifo.wr_en;
      tr.rd_en = fifo.rd_en;
	  tr.din = fifo.din;
      tr.full = fifo.full;
      tr.empty = fifo.empty; 
	  tr.almost_full = fifo.almost_full;
	  tr.almost_empty = fifo.almost_empty;
	  tr.dout = fifo.dout;
	  	
      mbx.put(tr);
    end
    
  endtask
  
endclass

