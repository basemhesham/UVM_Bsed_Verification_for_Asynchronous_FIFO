class monitor extends uvm_monitor;

`uvm_component_utils(monitor)
virtual intf moni_intf                      ;
sequence_item t_mon                         ; 
uvm_analysis_port #(sequence_item) mon_mail ;

function  new(string name = "MONITOR", uvm_component parent = null);
    super.new(name,parent) ; 
endfunction 

function void build_phase(uvm_phase phase);
    super.build_phase(phase) ;
    `uvm_info("MONITOR","WE Are Compiling The Monitor",UVM_NONE);
    
    if(!uvm_config_db #(virtual intf)::get(this,"","my_vif",moni_intf))
        `uvm_info("MONITOR","ERROR INSIDE MONITOR",UVM_NONE);
    t_mon = sequence_item::type_id::create("t_mon")         ; 
    mon_mail = new("mon_mail",this)                         ; 
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase) ; 
endfunction

task run_phase (uvm_phase phase) ; 

    `uvm_info("MONITOR","WE ARE RUNNING THE MONITOR",UVM_NONE)                    ;
    `uvm_info("MONITOR","Monitor Starting To Recieve Data From the DUT",UVM_NONE) ;
      #10
      forever  begin 
      $display("Monitor Is Waiting For Packet ......")    ;    
                                 
      @(moni_intf.w_clk);
      t_mon.i_w_rstn_tb    <=   moni_intf.i_w_rstn    ;    
      t_mon.i_w_inc_tb     <=   moni_intf.i_w_inc     ; 
      t_mon.i_r_rstn_tb    <=   moni_intf.i_r_rstn    ;  
      t_mon.i_r_inc_tb     <=   moni_intf.i_r_inc     ; 
      t_mon.i_w_data_tb   <=   moni_intf.i_w_data     ; 

      t_mon.o_r_data_tb   <=   moni_intf.o_r_data     ;  
      t_mon.o_empty_tb    <=   moni_intf.o_empty      ;  
      t_mon.o_full_tb     <=   moni_intf.o_full       ;  

      //t_mon.display_Sequence_item("Monitor")              ;        
      `uvm_info("MONITOR","Monitor has Recieveed the data from the DUT",UVM_NONE) ;
      mon_mail.write(t_mon)                               ;  

    end 

endtask 

endclass
