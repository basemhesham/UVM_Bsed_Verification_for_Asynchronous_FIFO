class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver)

  // Virtual interface handle
  virtual intf driv_intf;
  
  // Transaction item to be driven
  sequence_item t_drive;
  
  // Reset handling variables
  bit reset_applied = 0;
  int reset_cycles = 5; // Number of cycles to hold reset

  //----------------------------------------------------------------------------
  // UVM Phase Methods
  //----------------------------------------------------------------------------
  
  // Constructor
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build Phase - Get interface handle and create transaction object
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase - Creating driver components", UVM_MEDIUM);
    
    // Get virtual interface from config_db
    if(!uvm_config_db #(virtual intf)::get(this, "", "my_vif", driv_intf))
      `uvm_fatal(get_type_name(), "Failed to get virtual interface from config_db")
    
    // Create transaction object
    t_drive = sequence_item::type_id::create("t_drive");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase - Connecting driver components", UVM_HIGH);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Run Phase - Starting driver operation", UVM_MEDIUM);
    
    // Initialize interface signals to avoid X propagation
    initialize_interface();
    
    // Main driver loop
    forever begin
      seq_item_port.get_next_item(t_drive);
      
      // Display transaction details (uncomment if needed for debug)
      // t_drive.display_Sequence_item("DRIVER");
      
      // Drive the transaction to the DUT
      drive_transaction(t_drive);
      
      // Signal completion to sequencer
      seq_item_port.item_done();
    end
  endtask

  //----------------------------------------------------------------------------
  // Helper Methods
  //----------------------------------------------------------------------------
  
  // Initialize interface signals to avoid X propagation
  task initialize_interface();
    @(posedge driv_intf.w_clk);
    driv_intf.i_w_rstn  <= 1'b0; // Assert reset initially
    driv_intf.i_r_rstn  <= 1'b0;
    driv_intf.i_w_inc   <= 1'b0;
    driv_intf.i_r_inc   <= 1'b0;
    driv_intf.i_w_data  <= '0;
    
    // Hold reset for a few cycles
    repeat(reset_cycles) @(posedge driv_intf.w_clk);
    
    // De-assert reset
    driv_intf.i_w_rstn  <= 1'b1;
    driv_intf.i_r_rstn  <= 1'b1;
    
    // Wait a few more cycles before starting transactions
    repeat(2) @(posedge driv_intf.w_clk);
    reset_applied = 1;
    
    `uvm_info(get_type_name(), "Interface initialized with reset sequence", UVM_MEDIUM);
  endtask
  
  // Drive a transaction to the DUT
  task drive_transaction(sequence_item trans);
    // Wait for clock edge to drive signals
    @(posedge driv_intf.w_clk);
    
    // Drive all signals from the transaction to the interface
    driv_intf.i_w_rstn  <= trans.i_w_rstn_tb;
    driv_intf.i_w_inc   <= trans.i_w_inc_tb;
    driv_intf.i_r_rstn  <= trans.i_r_rstn_tb;
    driv_intf.i_r_inc   <= trans.i_r_inc_tb;
    driv_intf.i_w_data  <= trans.i_w_data_tb;
    
    `uvm_info(get_type_name(), $sformatf("Driving transaction: w_rstn=%0b, w_inc=%0b, r_rstn=%0b, r_inc=%0b, data=0x%0h",
                                         trans.i_w_rstn_tb, trans.i_w_inc_tb, 
                                         trans.i_r_rstn_tb, trans.i_r_inc_tb, 
                                         trans.i_w_data_tb), UVM_HIGH);
  endtask

endclass
