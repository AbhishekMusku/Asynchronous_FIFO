module wptr_handler #(parameter PTR_WIDTH=3) (
  input wclk, wrst_n, w_en,
  input [PTR_WIDTH:0] g_rptr_sync,
  output reg [PTR_WIDTH:0] b_wptr, g_wptr,
  output reg full,
  output reg halffull
);

    // Function to convert Gray code to binary using shift operators
    function automatic logic [PTR_WIDTH:0] gray_to_bin(input logic [PTR_WIDTH:0] gray);
        logic [PTR_WIDTH:0] binary;
        
        // Start with the most significant bit of the Gray code
        binary[PTR_WIDTH] = gray[PTR_WIDTH];
        
        // Convert Gray code to binary using shift operators
        for (int i = PTR_WIDTH-1; i >= 0; i--) begin
            binary[i] = gray[i] ^ binary[i+1];
        end
        
        return binary;
    endfunction


  reg [PTR_WIDTH:0] b_wptr_next;
  reg [PTR_WIDTH:0] g_wptr_next;
  reg [PTR_WIDTH:0] b_rptr_sync;
   
  reg wrap_around;
  wire wfull;
  wire hfull;
  
  assign b_wptr_next = b_wptr+(w_en & !full);
  assign g_wptr_next = (b_wptr_next >>1)^b_wptr_next;
  
  assign b_rptr_sync = gray_to_bin(g_rptr_sync);
  
  always@(posedge wclk or negedge wrst_n) begin
    if(wrst_n) begin
      b_wptr <= 0; // set default value
      g_wptr <= 0;
    end
    else begin
      b_wptr <= b_wptr_next; // incr binary write pointer
      g_wptr <= g_wptr_next; // incr gray write pointer
    end
  end
  
  always@(posedge wclk or negedge wrst_n) begin
    if(wrst_n) begin
	full <= 0;
    halffull<=0;
	end
	else begin 
	full <= wfull;
	halffull <= hfull;
	end
  end

  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});
  assign hfull = (b_wptr_next[PTR_WIDTH-1:0] - b_rptr_sync[PTR_WIDTH-1:0] >= 128);


endmodule



