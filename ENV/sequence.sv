////////////////////////////fifo_reset_sequence/////////////////////////////////////////
class fifo_reset_sequence extends uvm_sequence;
  `uvm_object_utils(fifo_reset_sequence)
  sequence_item t;

  function new(string name = "fifo_reset_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b0;
                                t.i_r_rstn_tb == 1'b0;
                                t.i_w_inc_tb == 0;
                                t.i_r_inc_tb == 0;});
    t.display_Sequence_item("fifo_reset_sequence");
    finish_item(t);
  endtask
endclass

////////////////////////////fifo_write_reset_sequence/////////////////////////////////////////
class fifo_write_reset_sequence extends uvm_sequence;
  `uvm_object_utils(fifo_write_reset_sequence)
  sequence_item t;

  function new(string name = "fifo_write_reset_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b0;
                                t.i_r_rstn_tb == 1'b1;
                                t.i_w_inc_tb == 0;});
    t.display_Sequence_item("fifo_write_reset_sequence");
    finish_item(t);
  endtask
endclass

////////////////////////////fifo_read_reset_sequence/////////////////////////////////////////
class fifo_read_reset_sequence extends uvm_sequence;
  `uvm_object_utils(fifo_read_reset_sequence)
  sequence_item t;

  function new(string name = "fifo_read_reset_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                t.i_r_rstn_tb == 1'b0;
                                t.i_r_inc_tb == 0;});
    t.display_Sequence_item("fifo_read_reset_sequence");
    finish_item(t);
  endtask
endclass

////////////////////////////fill_fifo_reactive_sequence/////////////////////////////////////////
class fill_fifo_reactive_sequence extends uvm_sequence;
  `uvm_object_utils(fill_fifo_reactive_sequence)
  sequence_item t;

  function new(string name = "fill_fifo_reactive_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 1;
                                  t.i_r_inc_tb == 0;});
      t.display_Sequence_item("fill_fifo_reactive_sequence");
      finish_item(t);
    end
  endtask
endclass

////////////////////////////empty_fifo_reactive_sequence/////////////////////////////////////////
class empty_fifo_reactive_sequence extends uvm_sequence;
  `uvm_object_utils(empty_fifo_reactive_sequence)
  sequence_item t;

  function new(string name = "empty_fifo_reactive_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 0;
                                  t.i_r_inc_tb == 1;});
      t.display_Sequence_item("empty_fifo_reactive_sequence");
      finish_item(t);
    end
  endtask
endclass

////////////////////////////attempt_write_to_full_sequence/////////////////////////////////////////
class attempt_write_to_full_sequence extends uvm_sequence;
  `uvm_object_utils(attempt_write_to_full_sequence)
  sequence_item t;

  function new(string name = "attempt_write_to_full_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                t.i_r_rstn_tb == 1'b1;
                                t.i_w_inc_tb == 1;});
    t.display_Sequence_item("attempt_write_to_full_sequence");
    finish_item(t);
  endtask
endclass

////////////////////////////attempt_read_from_empty_sequence/////////////////////////////////////////
class attempt_read_from_empty_sequence extends uvm_sequence;
  `uvm_object_utils(attempt_read_from_empty_sequence)
  sequence_item t;

  function new(string name = "attempt_read_from_empty_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                t.i_r_rstn_tb == 1'b1;
                                t.i_r_inc_tb == 1;});
    t.display_Sequence_item("attempt_read_from_empty_sequence");
    finish_item(t);
  endtask
endclass

////////////////////////////write_then_read_sequence/////////////////////////////////////////
class write_then_read_sequence extends uvm_sequence;
  `uvm_object_utils(write_then_read_sequence)
  sequence_item t;

  function new(string name = "write_then_read_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 1;
                                  t.i_r_inc_tb == 0;});
      t.display_Sequence_item("write_then_read_sequence (write)");
      finish_item(t);
    end
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 0;
                                  t.i_r_inc_tb == 1;});
      t.display_Sequence_item("write_then_read_sequence (read)");
      finish_item(t);
    end
  endtask
endclass

////////////////////////////concurrent_rw_sequence/////////////////////////////////////////
class concurrent_rw_sequence extends uvm_sequence;
  `uvm_object_utils(concurrent_rw_sequence)
  sequence_item t;

  function new(string name = "concurrent_rw_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 1;
                                  t.i_r_inc_tb == 1;});
      t.display_Sequence_item("concurrent_rw_sequence");
      finish_item(t);
    end
  endtask
endclass

////////////////////////////original_N_writes_sequence/////////////////////////////////////////
class original_N_writes_sequence extends uvm_sequence;
  `uvm_object_utils(original_N_writes_sequence)
  sequence_item t;

  function new(string name = "original_N_writes_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 1;
                                  t.i_r_inc_tb == 0;});
      t.display_Sequence_item("original_N_writes_sequence");
      finish_item(t);
    end
  endtask
endclass

////////////////////////////original_N_reads_sequence/////////////////////////////////////////
class original_N_reads_sequence extends uvm_sequence;
  `uvm_object_utils(original_N_reads_sequence)
  sequence_item t;

  function new(string name = "original_N_reads_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    for (int i = 0; i < 8; i++) begin
      start_item(t);
      assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                  t.i_r_rstn_tb == 1'b1;
                                  t.i_w_inc_tb == 0;
                                  t.i_r_inc_tb == 1;});
      t.display_Sequence_item("original_N_reads_sequence");
      finish_item(t);
    end
  endtask
endclass
////////////////////////////all_one_sequence/////////////////////////////////////////
class all_one_sequence extends uvm_sequence;
  `uvm_object_utils(all_one_sequence)
  sequence_item t;

  function new(string name = "attempt_read_from_empty_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                t.i_r_rstn_tb == 1'b1;
                                t.i_w_inc_tb  == 1'b1;
                                t.i_w_data_tb ==16'hFFFF;});

    t.display_Sequence_item("attempt_read_from_empty_sequence");
    finish_item(t);
  endtask
endclass
////////////////////////////all_zero_sequence/////////////////////////////////////////
class all_zero_sequence extends uvm_sequence;
  `uvm_object_utils(all_zero_sequence)
  sequence_item t;

  function new(string name = "attempt_read_from_empty_sequence");
    super.new(name);
  endfunction

  task pre_body();
    t = sequence_item::type_id::create("t");
  endtask

  task body();
    start_item(t);
    assert (t.randomize() with {t.i_w_rstn_tb == 1'b1;
                                t.i_r_rstn_tb == 1'b1;
                                t.i_r_inc_tb  == 1'b1;
                                t.i_w_data_tb ==16'hFFFF;});

    t.display_Sequence_item("attempt_read_from_empty_sequence");
    finish_item(t);
  endtask
endclass

