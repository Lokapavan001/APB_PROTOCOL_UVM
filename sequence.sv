`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_sequence extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(apb_sequence)

  apb_transaction tr_h;
  bit [4:0] count;
  logic mode;
  bit error;

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction

  virtual task body;
    repeat (count) begin
      tr_h = apb_transaction::type_id::create("tr_h");
      start_item(tr_h);

      if (mode == 1 && error == 0) begin // Write operation
        if (tr_h.randomize() with { pwrite == 1; }) begin
          `uvm_info(get_type_name(), $sformatf("Time = [%0t] Start of Write Transaction", $time), UVM_MEDIUM);
        end else
          `uvm_error(get_type_name(), "Randomization failed: write");
      end

      else if (mode == 0 && error == 0) begin // Read operation
        if (tr_h.randomize() with { pwrite == 0; pwdata == 0; }) begin
          `uvm_info(get_type_name(), $sformatf("Time = [%0t] Start of Read Transaction", $time), UVM_MEDIUM);
        end else
          `uvm_error(get_type_name(), "Randomization failed: read");
      end

      else if (mode ==0 &&error == 1) begin // Check for slave error
        if (tr_h.randomize() with { paddr == 32'hFFFF_FFFF; }) begin
          if (tr_h.pwrite == 0) tr_h.pwdata = 0;
          `uvm_info(get_type_name(), $sformatf("Time = [%0t] Checking Slave Error", $time), UVM_MEDIUM);
        end else
          `uvm_error(get_type_name(), "Randomization failed: slave error");
      end
      else begin 
        if (tr_h.randomize()) begin
         if (tr_h.pwrite == 0) tr_h.pwdata = 0;
          `uvm_info(get_type_name(), $sformatf("Time = [%0t] Random read/write transaction", $time), UVM_MEDIUM);
        end else
          `uvm_error(get_type_name(), "Randomization failed: random");
      end

      `uvm_info(get_type_name(),
        $sformatf(
          "Sequence Time = [%0t] psel=%0b penable=%0b pwrite=%0b paddr=%0d pwdata=%0d prdata=%0d pready=%0b pslverr=%0b",
          $time, tr_h.psel, tr_h.penable, tr_h.pwrite, tr_h.paddr, tr_h.pwdata, tr_h.prdata, tr_h.pready, tr_h.pslverr
        ),UVM_MEDIUM);

      finish_item(tr_h);
      #15;
      
    end
  endtask
endclass : apb_sequence
