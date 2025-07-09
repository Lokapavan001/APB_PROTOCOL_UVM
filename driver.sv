`include "uvm_macros.svh"
import uvm_pkg::*;

// ------------------------------------------------------------
// APB Driver Class
// ------------------------------------------------------------
class apb_driver extends uvm_driver#(apb_transaction);
  `uvm_component_utils(apb_driver)

  virtual apb_interface vif;
  apb_transaction tr_h;
  int wait_cycle = 0;

  // Constructor
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase: get virtual interface
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr_h = apb_transaction::type_id::create("tr_h");
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set via config DB in driver");
  endfunction

  // Reset logic: drive default (IDLE) values during reset
  virtual task reset_logic;
    do begin
      `uvm_info(get_type_name(), $sformatf("Time = [%0t] [APB_DRIVER] Reset active", $time), UVM_MEDIUM)
      vif.cb_driver.psel    <= 0;
      vif.cb_driver.penable <= 0;
      vif.cb_driver.pwrite  <= 0;
      vif.cb_driver.paddr   <= 0;
      vif.cb_driver.pwdata  <= 0;
      @(vif.cb_driver);
    end
    while (!vif.rst_n || vif.rst_n === 1'bx);
    `uvm_info(get_type_name(), $sformatf("Time = [%0t] [APB_DRIVER] Reset complete", $time), UVM_MEDIUM)
  endtask

  // Run phase: main transaction loop
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    reset_logic();
    wait (vif.rst_n);

    forever begin
      seq_item_port.get_next_item(tr_h);
      `uvm_info(get_type_name(), "Transaction received from sequencer", UVM_MEDIUM)

      drive_transfer();

      seq_item_port.item_done();
    end
  endtask

  // Task to drive a single APB transfer
  task drive_transfer();
    // ---------------------------
    // IDLE phase
    // ---------------------------
    @(vif.cb_driver);
    vif.cb_driver.psel    <= 0;
    vif.cb_driver.penable <= 0;

    // ---------------------------
    // SETUP phase
    // ---------------------------
    @(vif.cb_driver);
    vif.cb_driver.psel    <= 1;
    vif.cb_driver.penable <= 0;
    vif.cb_driver.pwrite  <= tr_h.pwrite;
    vif.cb_driver.paddr   <= tr_h.paddr;
    vif.cb_driver.pwdata  <= tr_h.pwdata;

    // ---------------------------
    // ACCESS phase
    // ---------------------------
    @(vif.cb_driver);
    vif.cb_driver.penable <= 1;

    // Wait for pready or timeout
    for (wait_cycle = 0; wait_cycle < 5; wait_cycle++) begin
      @(posedge vif.pclk);
      if (vif.cb_driver.pready)
        break;
    end

    if (!vif.cb_driver.pready) begin
      `uvm_error(get_type_name(), "[APB_DRIVER] pready not asserted within 5 cycles")
    end

    // Logging driven signals for debug
    `uvm_info(get_type_name(),
      $sformatf("Driven signals: psel=%0b penable=%0b pwrite=%0b paddr=%0d pwdata=%0d prdata=%0d pready=%0b pslverr=%0b",tr_h.psel, tr_h.penable, tr_h.pwrite,tr_h.paddr, tr_h.pwdata, tr_h.prdata,
        tr_h.pready,tr_h.pslverr), UVM_MEDIUM)

    // ---------------------------
    // Return to IDLE after transaction
    // ---------------------------
    @(vif.cb_driver);
    vif.cb_driver.psel    <= 0;
    vif.cb_driver.penable <= 0;
  endtask

endclass : apb_driver
