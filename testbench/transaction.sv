class transaction;

	rand bit sel;
	rand bit wr_en,rd_en;
	rand bit [7:0]din;
	logic [7:0]dout;
	logic full,empty,almost_full,almost_empty;	
	
	constraint select {  sel dist {1:=90, 0:=10};  }

	
endclass
