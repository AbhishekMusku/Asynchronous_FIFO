class driver;
	transaction tr;
	virtual fifo_inf fifo;
	mailbox #(transaction) mbx;    
	
function new (mailbox #(transaction) mbx);
	this.mbx = mbx;
endfunction

//Reset the DUT
task initialize();
	fifo.wrst_n <= 1'b1;
	fifo.rrst_n <= 1'b1;
	fifo.din <= '0;
	fifo.wr_en <= '0;
	fifo.rd_en <= '0;
	repeat (2) @(negedge fifo.clk1);
	repeat (2) @(negedge fifo.clk2);
	fifo.wrst_n <= 1'b0;
	fifo.rrst_n <= 1'b0;
	$display("[DRV] : DUT Reset Done");
	$display("------------------------------------------"); 
endtask

//Write to the FIFO
task write();
@(negedge fifo.clk1);
	fifo.wrst_n <= 1'b0;
    fifo.rd_en <= 1'b0;
    fifo.wr_en <= 1'b1;
    fifo.din <= tr.din;
	$display("[DRV] : DATA WRITE dataIn: %d ", tr.din); 
    @(negedge fifo.clk1);
    fifo.wr_en <= 1'b0;
	@(negedge fifo.clk1);
endtask

//Read from the FIFO
task read();
 @(negedge fifo.clk2);
    fifo.rrst_n <= 1'b0;
    fifo.rd_en <= 1'b1;
    fifo.wr_en <= 1'b0;
	$display("[DRV] : DATA READ "); 
    @(negedge fifo.clk2);
    fifo.rd_en <= 1'b0;
	repeat(1)@(negedge fifo.clk2);	
  endtask

//Applying stimulus to DUT
task run();
    forever begin
      mbx.get(tr);  
     if (tr.sel==1'b1)
        write();
	 else
        read();
    end
  endtask
  
  endclass
  
