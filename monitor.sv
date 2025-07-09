`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual apb_interface vif;
  apb_transaction tr_h;
  
  uvm_analysis_port#(apb_transaction) mon_port;
 // uvm_analysis_port#(apb_transaction) ms_port;
  
  
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    tr_h = new();
    mon_port = new("mon_port", this);
   // ms_port = new("ms_port", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
//     mon_port = new("mon_port", this);
    if(!uvm_config_db#(virtual apb_interface) :: get(this, "", "vif", vif)) begin
//     if(!uvm_config_db#(virtual apb_interface) :: get(this, "", "mon_if", vif)) begin
      `uvm_fatal(get_type_name(), "Not set at top level Monitor");
    end
  endfunction
  
  virtual task run_phase (uvm_phase phase);
//     phase.raise_objection(this);
//     tr_h = apb_transaction::type_id::create("tr_h");
    forever begin
      @(vif.cb_monitor) begin
        if(vif.cb_monitor.psel && !vif.cb_monitor.penable) begin
          @(vif.cb_monitor);
          if(vif.cb_monitor.psel && vif.cb_monitor.penable) begin
//             @(vif.cb_monitor);
            wait(vif.cb_monitor.pready);
            tr_h.psel 	 = vif.psel;
        	tr_h.penable = vif.penable;
        	tr_h.pwrite  = vif.pwrite;
        	tr_h.pwdata  = vif.pwdata;
        	tr_h.paddr   = vif.paddr;
        	tr_h.prdata  = vif.prdata;
        	tr_h.pready  = vif.pready;
        	tr_h.pslverr = vif.pslverr;
            
            `uvm_info(get_type_name(), $sformatf("Time = [%0t] psel = %0b, penable = %0b, pwrite = %0b, paddr = %0d, pwdata = %0d, prdata = %0d, pready = %0b, pslverr = %0b", $time, tr_h.psel, tr_h.penable, tr_h.pwrite,tr_h.paddr, tr_h.pwdata, tr_h.prdata, tr_h.pready, tr_h.pslverr),UVM_MEDIUM)
          end
          mon_port.write(tr_h);
         // ms_port.write(tr_h);
//           ->e1;
        end
    end
    end
//     phase.drop_objection(this);
  endtask
endclass : apb_monitor