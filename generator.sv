class generator;
	transaction tr;
	mailbox #(transaction) mbx;
	int count = 0;
	int i = 0;
	
	event sconext;
	event done;
	
function new(mailbox #(transaction) mbx);
	this.mbx = mbx;
	tr = new();
endfunction

task run();
	repeat (count) begin
		assert (tr.randomize()) else $error("Randomization failed");
		i++;
		mbx.put(tr);
		$display("[GEN] : %0d iteration ", i);
		@(sconext);
    end	
	-> done;
endtask

function void display();
$display("[Generator] : write enable = %0d, read enable = %0d, din = %0d", tr.wr_en, tr.rd_en, tr.din);
endfunction

endclass


