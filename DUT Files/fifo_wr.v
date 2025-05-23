module fifo_wr #(
  parameter P_SIZE = 4                          // pointer width (e.g., 4 for depth 8)
)
  (
   input  wire                    w_clk,              // write domain operating clock
   input  wire                    w_rstn,             // write domain active low reset 
   input  wire                    w_inc,              // write control signal 
   input  wire  [P_SIZE-1:0]      sync_rd_ptr,        // synced gray coded read pointer from read domain         
   output wire  [P_SIZE-2:0]      w_addr,             // generated binary write address (for memory indexing)
   output reg   [P_SIZE-1:0]      w_ptr,              // binary write pointer [registered]
   output reg   [P_SIZE-1:0]      gray_w_ptr,         // generated gray coded write pointer [registered]
   output wire                    full                // fifo full flag
);

// Binary write pointer logic
always @(posedge w_clk or negedge w_rstn)
 begin
  if(!w_rstn)
   begin
    w_ptr <= {P_SIZE{1'b0}};
   end
  else if (!full && w_inc) // Increment only if write is enabled and FIFO is not full
   begin
    w_ptr <= w_ptr + 1 ;
   end
 end

// Generation of write address for memory (usually MSB-1 bits of binary pointer)
assign w_addr = w_ptr[P_SIZE-2:0] ;

always @(posedge w_clk or negedge w_rstn)
 begin
  if(!w_rstn)
   begin
    gray_w_ptr <= {P_SIZE{1'b0}};
   end
  else
  begin
   gray_w_ptr <= w_ptr ^ (w_ptr >> 1);
  end
 end

assign full = (gray_w_ptr[P_SIZE-1]  != sync_rd_ptr[P_SIZE-1]) && 
              (gray_w_ptr[P_SIZE-2]  == sync_rd_ptr[P_SIZE-2]) && // Corrected: second MSBs must be EQUAL
              ( (P_SIZE <= 2) ? 1'b1 : (gray_w_ptr[P_SIZE-3:0] == sync_rd_ptr[P_SIZE-3:0]) );

endmodule


