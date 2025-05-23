class subscriber extends uvm_component;
  `uvm_component_utils(subscriber)

  uvm_analysis_imp #(sequence_item, subscriber) subs_mail;

  sequence_item t_subscriber_groub;

  int covered;
  int total;

  covergroup groub1;
   write_reset: coverpoint t_subscriber_groub.i_w_rstn_tb
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
	read_reset: coverpoint t_subscriber_groub.i_r_rstn_tb
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
	
    write_increment: coverpoint t_subscriber_groub.i_w_inc_tb
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
	
	read_increment: coverpoint t_subscriber_groub.i_r_inc_tb
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
	full_flag: coverpoint t_subscriber_groub.o_full_tb
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
	empty_flag: coverpoint t_subscriber_groub.o_empty_tb
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }

    write_data: coverpoint t_subscriber_groub.i_w_data_tb {
     option.auto_bin_max = 1000;
      bins all_zero    = {16'h0};
      bins all_one     = {16'hFFFF};
      
      bins others = default;
    }

    read_data: coverpoint t_subscriber_groub.o_r_data_tb {
      bins all_zero    = {16'h0};
      bins all_one     = {16'hFFFF};
      
      bins others = default;
    }   

  endgroup

  function new(string name = "SUBSCRIBER", uvm_component parent = null);
    super.new(name, parent);
    groub1 = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SUBSCRIBER", "Building the Subscriber", UVM_NONE)
    subs_mail = new("subs_mail", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("SUBSCRIBER", "Running the Subscriber", UVM_NONE)
  endtask

  function void write(sequence_item t_subs);
    //t_subs.display_Sequence_item("SUBSCRIBER");
    t_subscriber_groub = t_subs;
    groub1.sample(); 
  endfunction

  task display_coverage_percentage();
    real coverage_percentage;
    coverage_percentage = groub1.get_coverage(covered, total);
    $display("Coverage Percentage: %0.2f%%", coverage_percentage);
    $display("Covered Bins: %0d", covered);
    $display("Total Bins: %0d", total);
  endtask

endclass


