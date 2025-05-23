class sequence_item extends uvm_sequence_item  ;
 `uvm_object_utils(sequence_item)

  rand bit           i_w_rstn_tb ;
  rand bit           i_w_inc_tb  ;
  rand bit           i_r_rstn_tb ;                
  rand bit           i_r_inc_tb  ;                
  rand bit  [15:0]   i_w_data_tb ;
 
  bit       [15:0]   o_r_data_tb ;     
  bit                o_empty_tb  ;     
  bit                o_full_tb   ;
 
 // Constraints
    // 1. Control Write/Read Enable Patterns
    constraint c_write_read_enable {
        i_w_inc_tb dist { 1 := 95, 0 := 5 };
        i_r_inc_tb dist { 1 := 95, 0 := 5 };
        soft (o_empty_tb == 1) -> (i_r_inc_tb == 0);
    }

    // 2. Reset Behavior
    constraint c_reset {
        i_w_rstn_tb dist { 1 := 95, 0 := 5 };
        i_r_rstn_tb dist { 1 := 95, 0 := 5 };

        // Avoid simultaneous resets to test independent domains
        soft (i_w_rstn_tb == 0) -> (i_r_rstn_tb == 1);
        soft (i_r_rstn_tb == 0) -> (i_w_rstn_tb == 1);
    }
	
function  new(string name = "SEQUENCE_ITEM ");
    super.new(name) ; 
endfunction

function void display_Sequence_item(input string name = "SEQUENCE ITEM" ); 

    $display ("*************** This is the %0P **********************",name)      ;  
    $display (" i_w_rstn_tb   =   %0d "  , i_w_rstn_tb  ) ; 
    $display (" i_w_inc_tb    =   %0d "  , i_w_inc_tb   ) ; 
    $display (" i_r_rstn_tb   =   %0d "  , i_r_rstn_tb  ) ; 
    $display (" i_r_inc_tb    =   %0d "  , i_r_inc_tb   ) ; 
    $display (" i_w_data_tb   =   %0h "  , i_w_data_tb  ) ; 
    $display (" o_r_data_tb   =   %0h "  , o_r_data_tb  ) ; 
    $display (" o_empty_tb    =   %0d "  , o_empty_tb   ) ; 
    $display (" o_full_tb     =   %0d "  , o_full_tb   ) ; 
    $display ("**********************************************************")       ;
    
endfunction 

endclass
    


