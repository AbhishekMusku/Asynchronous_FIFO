module rptr_handler #(parameter PTR_WIDTH=8) (
  input rclk, rrst_n, r_en,
  input [PTR_WIDTH:0] g_wptr_sync,
  output reg [PTR_WIDTH:0] b_rptr, g_rptr,
  output reg empty,
  output reg halfempty
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

  reg [PTR_WIDTH:0] b_rptr_next;
  reg [PTR_WIDTH:0] g_rptr_next;
  reg [PTR_WIDTH:0] b_wptr_sync;
  
  wire rempty;
  wire hempty;  

  assign b_rptr_next = b_rptr+(r_en & !empty);
  assign g_rptr_next = (b_rptr_next >>1)^b_rptr_next;
  assign b_wptr_sync = gray_to_bin(g_wptr_sync);
  
  assign rempty = (g_rptr_next == {g_wptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_wptr_sync[PTR_WIDTH-2:0]});
  assign hempty = (b_rptr_next[PTR_WIDTH-1:0] - b_wptr_sync[PTR_WIDTH-1:0] >= 128);
  
  always@(posedge rclk or negedge rrst_n) begin
    if(rrst_n) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end
    else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
    end
  end
  
  always@(posedge rclk or negedge rrst_n) begin
    if(rrst_n) begin
	empty <= 0;
	halfempty <= 0;
	end
    else
	begin
	empty <= rempty;
	halfempty <= hempty;
	end
  end
endmodule
