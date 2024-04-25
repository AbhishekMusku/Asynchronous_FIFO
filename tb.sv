`timescale 1ns / 1ps
module tb ();

parameter DSIZE = 8;
parameter ASIZE = 8;
parameter WCLK_PERIOD = 4;
parameter RCLK_PERIOD = 10;

reg winc, wclk, wrst_n, rinc, rclk, rrst_n;
reg [DSIZE-1:0] wdata;
wire [DSIZE-1:0] rdata;
wire wfull, rempty;

// Instance
fifo1 
#(     
    .DSIZE(DSIZE),
    .ASIZE(ASIZE)
)
DUT1
(
    .winc (winc), .wrst_n(wrst_n), .wclk(wclk),
    .rinc(rinc), .rclk(rclk), .rrst_n(rrst_n),
    .wdata(wdata), .rdata(rdata), .wfull(wfull), .rempty(rempty)
);

initial begin
    wrst_n = 0;
    wclk = 0;
    winc = 0;
    wdata = 0;
    repeat (2) #(WCLK_PERIOD/2) wclk = ~wclk;
    wrst_n = 1;
    forever #(WCLK_PERIOD/2) wclk = ~wclk;
end

initial begin
    rrst_n = 0;
    rclk = 0;
    rinc = 0;
    repeat (2) #(RCLK_PERIOD/2) rclk = ~rclk;
    rrst_n = 1;
    forever  #(RCLK_PERIOD/2) rclk = ~rclk;
end


initial begin
    repeat (4) @ (posedge wclk);
	for(int i=0;i<=259;i++) begin
     @(negedge wclk); winc = 1;wdata = $random;
	 $display(" WRITE OP number %d winc = %d  wdata = %d  wfull=%d  ", i,winc,wdata,wfull); 
	end 
     @(negedge wclk); winc = 0;
	 @(negedge rclk);
	for(int i=0; i<=259;i++) begin 
	 rinc = 1;
	 @(negedge rclk);
	 $display("READ OP number %d rinc = %d  rdata = %d  rempty=%d",i, rinc,rdata,rempty);
	 rinc = 0;
	 repeat(2) @(negedge rclk); 
	 end
	 repeat(20) @(negedge rclk);

     #100;
     $finish;
end

endmodule