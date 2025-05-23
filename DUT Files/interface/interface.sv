interface  intf(input logic w_clk, r_clk);       
   
  parameter D_SIZE  = 16 ;                       // data size
  parameter F_DEPTH = 8 ;                        // fifo depth
  parameter P_SIZE  = 4  ;                       // pointer width

  logic                  i_w_rstn;          
  logic                  i_w_inc;                
  logic                  i_r_rstn;
  logic                  i_r_inc; 
  logic  [D_SIZE-1:0]    i_w_data;
  logic  [D_SIZE-1:0]    o_r_data;  
  logic                  o_empty;
  logic                  o_full;
   
endinterface
