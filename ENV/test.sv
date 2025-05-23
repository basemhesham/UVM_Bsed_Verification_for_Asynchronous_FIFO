class test extends uvm_test;
  `uvm_component_utils(test)
  environment               environment_instance;

  fifo_reset_sequence                  fifo_reset_sequence_instance;
  fifo_write_reset_sequence            fifo_write_reset_sequence_instance;
  fifo_read_reset_sequence             fifo_read_reset_sequence_instance;
  fill_fifo_reactive_sequence          fill_fifo_reactive_sequence_instance;
  empty_fifo_reactive_sequence         empty_fifo_reactive_sequence_instance;
  attempt_write_to_full_sequence       attempt_write_to_full_sequence_instance;
  attempt_read_from_empty_sequence     attempt_read_from_empty_sequence_instance;
  write_then_read_sequence             write_then_read_sequence_instance;
  concurrent_rw_sequence               concurrent_rw_sequence_instance;
  original_N_writes_sequence           original_N_writes_sequence_instance;
  original_N_reads_sequence            original_N_reads_sequence_instance;
  all_one_sequence                     all_one_sequence_instance;
  all_zero_sequence                    all_zero_sequence_instance;
  virtual intf              test_intf;

  function new(string name = "TEST", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST", "WE Are Compiling The TEST", UVM_NONE)

    environment_instance                         =  environment::type_id::create("environment_instance", this); 

    fifo_reset_sequence_instance                 =  fifo_reset_sequence::type_id::create("fifo_reset_sequence_instance"); 
    fifo_write_reset_sequence_instance           =  fifo_write_reset_sequence::type_id::create("fifo_write_reset_sequence_instance"); 
    fifo_read_reset_sequence_instance            =  fifo_read_reset_sequence::type_id::create("fifo_read_reset_sequence_instance"); 
    fill_fifo_reactive_sequence_instance         =  fill_fifo_reactive_sequence::type_id::create("fill_fifo_reactive_sequence_instance"); 
    empty_fifo_reactive_sequence_instance        =  empty_fifo_reactive_sequence::type_id::create("empty_fifo_reactive_sequence_instance", this); 
    attempt_write_to_full_sequence_instance      =  attempt_write_to_full_sequence::type_id::create("attempt_write_to_full_sequence_instance"); 
    attempt_read_from_empty_sequence_instance    =  attempt_read_from_empty_sequence::type_id::create("attempt_read_from_empty_sequence_instance"); 
    write_then_read_sequence_instance            =  write_then_read_sequence::type_id::create("write_then_read_sequence_instance"); 
    concurrent_rw_sequence_instance              =  concurrent_rw_sequence::type_id::create("concurrent_rw_sequence_instance"); 
    original_N_writes_sequence_instance          =  original_N_writes_sequence::type_id::create("original_N_writes_sequence_instance"); 
    original_N_reads_sequence_instance           =  original_N_reads_sequence::type_id::create("original_N_reads_sequence_instance"); 
    all_one_sequence_instance                    =  all_one_sequence::type_id::create("all_one_sequence_instance"); 
    all_zero_sequence_instance                   =  all_zero_sequence::type_id::create("all_zero_sequence_instance"); 

    if (!uvm_config_db#(virtual intf)::get(this, "", "my_vif", test_intf)) begin
      `uvm_info("TEST", "ERROR INSIDE Test", UVM_NONE)
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);   

     phase.raise_objection(this, "STARTING TEST");

    `uvm_info("TEST", "WE ARE RUNNING THE TEST", UVM_NONE)
    
    fifo_reset_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    fifo_write_reset_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);  
    fifo_read_reset_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);     
    fill_fifo_reactive_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    attempt_write_to_full_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);     
    empty_fifo_reactive_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    attempt_read_from_empty_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);       
    write_then_read_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);    
    concurrent_rw_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);  
    original_N_writes_sequence_instance.start(environment_instance.agent_instance.sequencer_instance);
    original_N_reads_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    all_one_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    all_zero_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    original_N_reads_sequence_instance.start(environment_instance.agent_instance.sequencer_instance); 
    environment_instance.subscriber_instance.display_coverage_percentage(); 

    phase.drop_objection(this, "FINISHING TEST");
  endtask

endclass

