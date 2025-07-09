`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_environment extends uvm_env;
  `uvm_component_utils(apb_environment)

  // Component handles
  apb_agent agt_h;
  apb_scoreboard sco_h;
  apb_predictor pre_h;

  // Constructor
  function new(string name = "apb_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create agent, scoreboard, and predictor
    agt_h = apb_agent::type_id::create("agt_h", this);
    sco_h = apb_scoreboard::type_id::create("sco_h", this);
    pre_h = apb_predictor::type_id::create("pre_h", this);

    `uvm_info(get_type_name(), "Build phase complete.", UVM_MEDIUM)
  endfunction

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitor’s analysis port to predictor and scoreboard
   agt_h.mon_h.mon_port.connect(pre_h.analysis_export);
   agt_h.mon_h.mon_port.connect(sco_h.analysis_export);

    // Connect predictor's output to scoreboard
    pre_h.pre_port.connect(sco_h.pre2sco_expected_export);

    `uvm_info(get_type_name(), "Connect phase complete.", UVM_MEDIUM)
  endfunction

//   // Run phase (if needed for environment-level tasks)
//   virtual task run_phase(uvm_phase phase);
//     phase.raise_objection(this);

//     `uvm_info(get_type_name(),
//       $sformatf("Time = [%0t] Environment run_phase started.", $time),
//       UVM_MEDIUM
//     );

//     // Dummy environment-level activity: just wait 100ns
//     #100ns;

//     `uvm_info(get_type_name(),
//       $sformatf("Time = [%0t] Environment run_phase complete.", $time),
//       UVM_MEDIUM
//     );

//     phase.drop_objection(this);
//   endtask

endclass : apb_environment
