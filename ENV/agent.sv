class agent extends uvm_agent;
`uvm_component_utils(agent)
monitor   monitor_instance           ;
driver    driver_instance            ;
sequencer sequencer_instance         ; 


function  new(string name = "AGENT", uvm_component parent = null);
    super.new(name,parent) ; 
endfunction 

function void build_phase(uvm_phase phase);
    super.build_phase(phase) ;
    `uvm_info("AGENT","WE Are Compiling The agent",UVM_NONE) ;
    monitor_instance    = monitor::type_id::create("monitor_instance",this)             ; 
    driver_instance    = driver::type_id::create("driver_instance",this)                ; 
    sequencer_instance = sequencer::type_id::create("sequencer_instance",this)          ; 
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase) ; 
    driver_instance.seq_item_port.connect(sequencer_instance.seq_item_export)           ;
endfunction

task run_phase (uvm_phase phase) ; 

    `uvm_info("AGENT","WE ARE RUNNING THE AGENT",UVM_NONE);

endtask 




endclass