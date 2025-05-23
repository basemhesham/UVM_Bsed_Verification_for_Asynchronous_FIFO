class environment extends uvm_env;
`uvm_component_utils(environment)
subscriber subscriber_instance         ; 
agent      agent_instance              ; 


function  new(string name = "ENVIRONMENT", uvm_component parent = null);
    super.new(name,parent) ; 
endfunction 

function void build_phase(uvm_phase phase);
    super.build_phase(phase) ;
    `uvm_info("ENVIRONMENT","WE Are Compiling The Environment",UVM_NONE);

    subscriber_instance = subscriber::type_id::create("subscriber_instance",this)  ; 
    agent_instance      = agent::type_id::create("agent_instance",this)            ; 

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase) ; 
    agent_instance.monitor_instance.mon_mail.connect(subscriber_instance.subs_mail)  ; 
endfunction

task run_phase (uvm_phase phase) ; 

    `uvm_info("ENVIRONMENT","WE ARE RUNNING THE ENVIRONMENT",UVM_NONE);

endtask 



endclass
