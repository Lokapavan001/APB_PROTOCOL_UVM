`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_transaction extends uvm_sequence_item;
  bit psel;
  bit penable;
  rand bit pwrite;
  rand bit[31:0] pwdata;
  rand bit[31:0] paddr;
  bit[31:0] prdata;
  bit pready;
  bit pslverr;
  
  `uvm_object_utils_begin(apb_transaction)
  `uvm_field_int(psel, UVM_ALL_ON)
  `uvm_field_int(penable, UVM_ALL_ON)
  `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_field_int(pwdata, UVM_ALL_ON)
  `uvm_field_int(paddr, UVM_ALL_ON)
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_field_int(pready, UVM_ALL_ON)
  `uvm_field_int(pslverr, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  constraint c_pwrite {soft pwrite dist {1 := 1, 0 := 1};}
  constraint c_paddr {soft paddr inside {[0:127]}; !(paddr inside {0, 4, 8, 12});}
//   constraint c_paddr {soft paddr inside {[0:127]};}
  constraint c_pwdata {soft pwdata inside {[1:255]};}
  
  function void display(input string name = "");
    `uvm_info(get_full_name(), $sformatf("Time = [%0t] [%0s] psel = %0d, penable = %0d, pwrite = %0b, paddr = %0d, pwdata = %0d, prdata = %0d, pready = %0b, pslverr = %0b",$time, name, psel, penable, pwrite, paddr, pwdata, prdata, pready, pslverr), UVM_MEDIUM)
  endfunction
  
endclass : apb_transaction