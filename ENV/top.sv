// TOP LEVEL TESTBENCH (top.sv) - REVISED FOR PORT CONNECTION
module top();

    import uvm_pkg::*;  
    import pack1::*;     

    bit w_clk, r_clk;

    initial begin
        w_clk = 1'b0;
        r_clk = 1'b0;
    end

    always #15  w_clk = ~w_clk;  // Creates a w_clk with a period of 15 ns 
    always #20 r_clk = ~r_clk;  // Creates an r_clk with a period of 20 ns 

    // Interface instance with parameters
    intf #(
        .D_SIZE(16),
        .F_DEPTH(8),
        .P_SIZE(4)
    ) intf1(w_clk, r_clk); 

    // DUT (Async_fifo) instance with parameters and corrected o_full connection
    Async_fifo Async_fifo_TEST (
        .w_clk(intf1.w_clk),
        .i_w_rstn(intf1.i_w_rstn),
        .i_w_inc(intf1.i_w_inc),
        .r_clk(intf1.r_clk),
        .i_r_rstn(intf1.i_r_rstn),
        .i_r_inc(intf1.i_r_inc),
        .i_w_data(intf1.i_w_data),
        .o_r_data(intf1.o_r_data),
        .o_full(intf1.o_full),   // DUT o_full signal connected to the interface
        .o_empty(intf1.o_empty)
    );

    // Bind the modified assertions module to all instances of Async_fifo
    bind Async_fifo fifo_assertions #(
        .D_SIZE(16),   
        .F_DEPTH(8), 
        .P_SIZE(4)    
    ) fifo_assertions_inst (
        .w_clk(w_clk),
        .i_w_rstn(i_w_rstn),
        .i_w_inc(i_w_inc),
        .o_full(o_full),
        .w_addr(u_fifo_wr.w_addr),
        .w_ptr(u_fifo_wr.w_ptr),
        .gray_w_ptr(u_fifo_wr.gray_w_ptr),
        .sync_rd_ptr(u_fifo_wr.sync_rd_ptr), 
        .i_w_data(i_w_data),
        .r_clk(r_clk),
        .i_r_rstn(i_r_rstn),
        .i_r_inc(i_r_inc),
        .o_empty(o_empty),
        .r_addr(u_fifo_rd.rd_addr),
        .rd_ptr(u_fifo_rd.rd_ptr),
        .gray_rd_ptr(u_fifo_rd.gray_rd_ptr),
        .sync_wr_ptr(u_fifo_rd.sync_wr_ptr),
        .o_r_data(o_r_data),
        .FIFO_MEM(u_fifo_mem.FIFO_MEM)
    );

    initial begin
        uvm_config_db#(virtual intf)::set(null, "*", "my_vif", intf1);   
        run_test("test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end

endmodule
