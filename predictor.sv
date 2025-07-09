`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_predictor extends uvm_component;
  `uvm_component_utils(apb_predictor)

  uvm_analysis_imp#(apb_transaction, apb_predictor) analysis_export;
  uvm_analysis_port#(apb_transaction) pre_port;

  apb_transaction pspkt_h;
  bit [31:0] mem [0:256];
  virtual apb_interface vif;

  function new(string name = "apb_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
    pre_port = new("pre_port", this);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set");
  endfunction

  function void write(apb_transaction tr);
    pspkt_h = apb_transaction::type_id::create("pspkt_h");
    if (!tr.pwrite) begin
      pspkt_h.prdata = mem[tr.paddr];
    end else begin
      mem[tr.paddr] = tr.pwdata;
    end

    pspkt_h.copy(tr); // copy fields
    pre_port.write(pspkt_h);
    `uvm_info("PREDICTOR", $sformatf("Predicted: psel=%0d penable=%0d pwrite=%0d paddr=%0d pwdata=%0d prdata=%0d pready=%0d", pspkt_h.psel,pspkt_h.penable,pspkt_h.pwrite,pspkt_h.paddr,pspkt_h.pwdata, pspkt_h.prdata,pspkt_h.pready), UVM_MEDIUM)
  endfunction
endclass
