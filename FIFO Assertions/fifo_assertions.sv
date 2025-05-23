module fifo_assertions #(
  parameter D_SIZE = 16,  // Data size
  parameter F_DEPTH = 8,  // FIFO depth
  parameter P_SIZE = 4    // Pointer width
)(
  // Write domain signals
  input wire                    w_clk,
  input wire                    i_w_rstn,
  input wire                    i_w_inc,
  input wire                    o_full,         // DUT o_full signal
  input wire [P_SIZE-2:0]       w_addr,
  input wire [P_SIZE-1:0]       w_ptr,          // Binary write pointer from fifo_wr
  input wire [P_SIZE-1:0]       gray_w_ptr,     // Gray write pointer from fifo_wr
  input wire [P_SIZE-1:0]       sync_rd_ptr,    // Synchronized Gray Read Pointer to Write Domain (this is r2w_ptr)
  input wire [D_SIZE-1:0]       i_w_data,

  // Read domain signals
  input wire                    r_clk,
  input wire                    i_r_rstn,
  input wire                    i_r_inc,
  input wire                    o_empty,        // DUT o_empty signal
  input wire [P_SIZE-2:0]       r_addr,
  input wire [P_SIZE-1:0]       rd_ptr,         // Binary read pointer from fifo_rd
  input wire [P_SIZE-1:0]       gray_rd_ptr,    // Gray read pointer from fifo_rd
  input wire [P_SIZE-1:0]       sync_wr_ptr,    // Synchronized Gray Write Pointer to Read Domain (this is w2r_ptr)
  input wire [D_SIZE-1:0]       o_r_data,

  // FIFO memory
  input wire [D_SIZE-1:0]       FIFO_MEM [F_DEPTH-1:0]
);

  // Helper function for Gray code conversion
  function [P_SIZE-1:0] bin_to_gray (input [P_SIZE-1:0] bin);
    return bin ^ (bin >> 1);
  endfunction
  
  // 1. Data Transfer Assertions
  write_data_to_mem_check: assert property (
    @(posedge w_clk) disable iff (!i_w_rstn)
    (i_w_inc && !o_full) |=> (FIFO_MEM[$past(w_addr)] == $past(i_w_data))
  ) else $error($sformatf("Assertion failed: Incorrect data written to FIFO memory"));

  // Checks that data read from FIFO matches memory content when a read occurs
  read_data_from_mem_check: assert property (
    @(posedge r_clk) disable iff (!i_r_rstn)
    (i_r_inc && !o_empty) |-> (o_r_data == FIFO_MEM[r_addr])
  ) else $error($sformatf("Assertion failed: Incorrect data read from FIFO memory (addr: %h, data_out: %h, mem_data: %h) or read occurred when empty.", r_addr, o_r_data, FIFO_MEM[r_addr]));

  // 2. Pointer Increment Assertions
  write_ptr_increment_check: assert property (
    @(posedge w_clk) disable iff (!i_w_rstn)
    (i_w_inc && !o_full) |=> 
      ($past(w_ptr) == {P_SIZE{1'b1}} ? w_ptr == {P_SIZE{1'b0}} : w_ptr == $past(w_ptr) + 1)
  ) else $error($sformatf("Assertion failed: Write pointer did not increment correctly. Previous: %h, Current: %h", $past(w_ptr), w_ptr));


  read_ptr_increment_check: assert property (
    @(posedge r_clk) disable iff (!i_r_rstn)
    (i_r_inc && !o_empty) |=> 
      ($past(rd_ptr) == {P_SIZE{1'b1}} ? rd_ptr == {P_SIZE{1'b0}} : rd_ptr == $past(rd_ptr) + 1)
  ) else $error($sformatf("Assertion failed: Read pointer did not increment correctly. Previous: %h, Current: %h", $past(rd_ptr), rd_ptr));


  // 3. Gray Code Conversion Assertions
  gray_w_ptr_conversion_check: assert property (
    @(posedge w_clk) disable iff (!i_w_rstn)
    (gray_w_ptr == bin_to_gray($past(w_ptr))) // Assuming w_ptr is sampled on the previous cycle for conversion
  ) else $error($sformatf("Assertion failed: w_ptr (%b at previous cycle) to gray_w_ptr (%b at current cycle) conversion incorrect. Expected gray for %b: %b", $past(w_ptr), gray_w_ptr, $past(w_ptr), bin_to_gray($past(w_ptr))));

  gray_rd_ptr_conversion_check: assert property (
    @(posedge r_clk) disable iff (!i_r_rstn)
    (gray_rd_ptr == bin_to_gray($past(rd_ptr)))
  ) else $error($sformatf("Assertion failed: rd_ptr (%b at previous cycle) to gray_rd_ptr (%b at current cycle) conversion incorrect. Expected gray for %b: %b", $past(rd_ptr), gray_rd_ptr, $past(rd_ptr), bin_to_gray($past(rd_ptr))));

  // 4. Pointer Synchronization Assertions
  w2r_sync_check: assert property (
    @(posedge r_clk) disable iff (!i_r_rstn)
    ##2 sync_wr_ptr == $past(gray_w_ptr, 2) 
  ) else $error("Assertion failed: Write pointer synchronization to read domain (sync_wr_ptr) failed.");

  r2w_sync_check: assert property (
    @(posedge w_clk) disable iff (!i_w_rstn)
    ##2 sync_rd_ptr == $past(gray_rd_ptr, 2) 
  ) else $error("Assertion failed: Read pointer synchronization to write domain (sync_rd_ptr) failed.");

  // 5. Flag Generation Logic Assertions
  logic correct_full_condition_logic;
  always_comb begin
    correct_full_condition_logic = (gray_w_ptr[P_SIZE-1] != sync_rd_ptr[P_SIZE-1]) && 
                                   (gray_w_ptr[P_SIZE-2] == sync_rd_ptr[P_SIZE-2]) && 
                                   ( (P_SIZE <= 2) ? 1'b1 : (gray_w_ptr[P_SIZE-3:0] == sync_rd_ptr[P_SIZE-3:0]) );
  end
  
  dut_o_full_matches_correct_logic: assert property (
    @(posedge w_clk) disable iff (!i_w_rstn)
    (o_full == correct_full_condition_logic)
  ) else $error($sformatf("Assertion failed: DUT o_full (%b) does not match expected full condition (%b). gray_w_ptr=%h, sync_rd_ptr=%h", o_full, correct_full_condition_logic, gray_w_ptr, sync_rd_ptr));

  logic correct_empty_condition_logic;
  always_comb begin
    correct_empty_condition_logic = (gray_rd_ptr == sync_wr_ptr);
  end

  dut_o_empty_matches_correct_logic: assert property (
    @(posedge r_clk) disable iff (!i_r_rstn)
    (o_empty == correct_empty_condition_logic)
  ) else $error($sformatf("Assertion failed: DUT o_empty (%b) does not match expected empty condition (%b). gray_rd_ptr=%h, sync_wr_ptr=%h", o_empty, correct_empty_condition_logic, gray_rd_ptr, sync_wr_ptr));

  // 6. Reset Behavior Assertions

  write_pointers_reset_check: assert property (
   @(posedge i_w_rstn) (w_ptr == {P_SIZE{1'b0}} && gray_w_ptr == {P_SIZE{1'b0}})
  ) else $error("Assertion failed: Write pointers did not reset correctly.");

  read_pointers_reset_check: assert property (
    @(posedge i_r_rstn) (rd_ptr == {P_SIZE{1'b0}} && gray_rd_ptr == {P_SIZE{1'b0}})
  ) else $error("Assertion failed: Read pointers did not reset correctly.");
  
  o_full_on_wreset_check: assert property(
    @(posedge w_clk) disable iff(i_w_rstn) !i_w_rstn |-> !o_full
  ) else $error("Assertion failed: o_full should be low during write reset.");

  o_empty_on_rreset_check: assert property(
    @(posedge r_clk) disable iff(i_r_rstn) !i_r_rstn |-> o_empty 
  ) else $error("Assertion failed: o_empty should be high during read reset.");

  // 7. FIFO Operation Rules
  no_wptr_increment_when_full: assert property (
    @(posedge w_clk) disable iff (!i_w_rstn)
    ($past(o_full) && i_w_inc) |-> ($stable(w_ptr))
  ) else $error("Assertion failed: Write pointer changed when FIFO was full and write attempted.");

  no_rptr_increment_when_empty: assert property (
    @(posedge r_clk) disable iff (!i_r_rstn)
    ($past(o_empty) && i_r_inc) |-> ($stable(rd_ptr))
  ) else $error("Assertion failed: Read pointer changed when FIFO was empty and read attempted.");

endmodule


