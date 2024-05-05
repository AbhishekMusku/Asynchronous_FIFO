class scoreboard;
  
  mailbox #(transaction) mbx;   // Mailbox for communication
  transaction tr;          		// Transaction object for monitoring
  event sconext;
  bit [7:0] din[$];            // Array to store written data
  bit [7:0] temp;         		// Temporary data storage
  int err = 0;           	    // Error count
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;     
  endfunction;
 
  task run();
    forever begin
      mbx.get(tr);
      //$display("[SCO] : Wr:%0d rd:%0d din:%0h dout:%0h full:%0d empty:%0d", tr.wr_en, tr.rd_en, tr.din, tr.dout, tr.full, tr.empty);
      
      if (tr.wr_en == 1'b1) begin
        if (tr.full == 1'b0) begin
          din.push_front(tr.din);		  
          $display("[SCO] : DATA STORED IN QUEUE");
		  if(tr.almost_full == 1'b1)
		  $display(" [HF] : FIFO is half full");
		  #8.88;
        end
        else begin
          $display("[SCO] : FIFO is full");
        end
        $display("--------------------------------------"); 
	   -> sconext;
      end
    
      if (tr.rd_en == 1'b1) begin
        if (tr.empty == 1'b0) begin  
		  temp = din.pop_back();
			#7;
          if (tr.dout == temp) begin
            $display("[SCO] : DATA MATCH");
		   if(tr.almost_empty == 1'b1)
		  $display(" [HE] : FIFO is half empty");
		  end
          else begin
            //$error("[SCO] : DATA MISMATCH ");
            err++;
          end
        end
        else begin
          $display("[SCO] : FIFO IS EMPTY");
        end
        $display("--------------------------------------"); 
	     -> sconext;
      end
	  
		
   
    end
endtask

endclass
