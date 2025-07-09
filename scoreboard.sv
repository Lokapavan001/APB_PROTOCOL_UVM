class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp#(apb_transaction, apb_scoreboard) analysis_export;
  uvm_analysis_imp#(apb_transaction, apb_scoreboard) pre2sco_expected_export;

  apb_transaction mspkt_h;
  apb_transaction pspkt_h;

  bit mon_ready = 0;
  bit pre_ready = 0;
  
  virtual apb_interface vif;
  
  covergroup cg_cover;
    option.per_instance = 1;
    cp1 : coverpoint vif.paddr{bins b1 = {[0:127]}; bins b2 = {32'hffff_ffff};}
    cp2 : coverpoint vif.pwdata {bins b3 = {[0:255]};}
    cp3 : coverpoint vif.prdata {bins b4 = {[0:255]};}
    cp4 : coverpoint vif.psel {bins b5 = {1}; bins b6 = {0};}
    cp5 : coverpoint vif.pwrite {bins b7 = {1}; bins b8 = {0};}
    cp2_x_cp5 : cross cp2, cp5;
    cp3_x_cp5 : cross cp3, cp5;
  endgroup

  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    cg_cover = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);                   
    pre2sco_expected_export = new("pre2sco_expected_export", this);

    `uvm_info(get_type_name(), $sformatf("Scoreboard inside build phase"), UVM_MEDIUM)
    
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin

      `uvm_fatal(get_type_name(), "Virtual interface not set via config DB driver");
    end
  endfunction

  function void write(apb_transaction t);
    mspkt_h = t;
    mon_ready = 1;
    pspkt_h = t;
    pre_ready = 1;

    check_compare();
  endfunction


  function void check_compare();
    if(vif.psel && vif.penable && vif.pready)
      cg_cover.sample();
    if (mon_ready && pre_ready) begin
      if (pspkt_h.pwrite == 1'b0) begin
        if (mspkt_h.prdata == pspkt_h.prdata) begin
          `uvm_info(get_type_name(), $sformatf("Time = [%0t] Scoreboard PASS: MON_prdata = %0d, PRE_prdata = %0d", $time, mspkt_h.prdata, pspkt_h.prdata), UVM_MEDIUM)
          `uvm_info(get_type_name(), $sformatf("----------------------------------------------------------------------"), UVM_MEDIUM)
        end else begin
          `uvm_error(get_type_name(), $sformatf("Time = [%0t] Scoreboard FAIL: MON_prdata = %0d, PRE_prdata = %0d", $time, mspkt_h.prdata, pspkt_h.prdata))
          `uvm_info(get_type_name(), $sformatf("----------------------------------------------------------------------"), UVM_MEDIUM)
        end
      end else begin
        `uvm_info(get_type_name(), $sformatf("Time = [%0t] Write Transaction Completed", $time), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("------------------------------------------------------------------------"), UVM_MEDIUM)
      end
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    phase.drop_objection(this);
  endtask
endclass : apb_scoreboard
