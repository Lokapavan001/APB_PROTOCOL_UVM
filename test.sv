class apb_full_test extends uvm_test;
  `uvm_component_utils(apb_full_test)
  
  apb_environment env_h;
  apb_sequence seq_h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    env_h = apb_environment::type_id::create("env_h", this);
  endfunction

  task run_phase(uvm_phase phase);
//     super.run_phase(phase);
    phase.raise_objection(this);

    // Call different test scenarios here
//    `uvm_info(get_type_name(), "Starting WRITE test scenario", UVM_MEDIUM);
//    run_write_test();

//    `uvm_info(get_type_name(), "Starting READ test scenario", UVM_MEDIUM);
//    run_read_test();

    `uvm_info(get_type_name(), "Starting RANDOM test scenario", UVM_MEDIUM);
    run_random_write_read_test();

//    `uvm_info(get_type_name(), "Starting SLAVE ERROR CHECK scenario", UVM_MEDIUM);
//    run_slave_error_check_test();
    phase.drop_objection(this);
  endtask

//  task run_write_test();
//    // Do all the write tests here!
//     `uvm_info(get_type_name(), "Running inside WRITE test", UVM_MEDIUM)
//    seq_h = apb_sequence::type_id::create("seq_h");
//    seq_h.count = 20;
//    seq_h.mode = 1;
//    seq_h.error = 0;
//    seq_h.start(env_h.agt_h.seqr_h);  // Start on sequencer
//    `uvm_info(get_type_name(), "End of WRITE test", UVM_MEDIUM)
//  endtask

//  task run_read_test();
//    // Do all the read tests here!
//    `uvm_info(get_type_name(), "Running inside Read test", UVM_MEDIUM)
//    seq_h = apb_sequence::type_id::create("seq_h");
//    seq_h.count = 20;
//    seq_h.mode = 0;
//    seq_h.error = 0;
//    seq_h.start(env_h.agt_h.seqr_h);  // Start on sequencer
//    `uvm_info(get_type_name(), "End of Read test", UVM_MEDIUM)
//  endtask

  task run_random_write_read_test();
    // Random read/write test logic
    `uvm_info(get_type_name(), "Running Random Write read test", UVM_MEDIUM)
    seq_h = apb_sequence::type_id::create("seq_h");
    seq_h.count = 20;
    seq_h.mode = 1;
    seq_h.error = 1;
    seq_h.start(env_h.agt_h.seqr_h);  // Start on sequencer
    `uvm_info(get_type_name(), "End of Random Write read test", UVM_MEDIUM)
  endtask

//  task run_slave_error_check_test();
//    // Slave error scenario logic
//    `uvm_info(get_type_name(), "Running check_pslverr", UVM_MEDIUM)
//    seq_h = apb_sequence::type_id::create("seq_h");
//    seq_h.count = 8;
//    seq_h.mode = 0;
//    seq_h.error = 1;
//    seq_h.start(env_h.agt_h.seqr_h);  // Start on sequencer
//    `uvm_info(get_type_name(), "End of check_pslverr", UVM_MEDIUM)
//  endtask
endclass