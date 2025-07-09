
// or browse Examples
//`include "interface.sv"
//`include "package.sv"
//import apb_pkg::*;

`include "uvm_macros.svh"
import uvm_pkg::*;
  `include "sequence_item.sv"
	`include "sequence.sv"
	`include "apb_sequencer.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "agent.sv"
	`include "predictor.sv"
	`include "scoreboard.sv"
	`include "environment.sv"
	//`include "write_test.sv"
//	`include "apb_read_test.sv"
//	`include "apb_random_write_read.sv"
//	`include "apb_pslverr_check.sv"
	`include "test.sv"
module top;
  logic pclk, prst_n;

  apb_interface vif(pclk, prst_n);  // Interface instantiation
  
  apb_slave dut(vif);  // DUT instantiation
  
  always #5 pclk = ~pclk;  // Clock generation

  initial begin
    $display("Hello");
    pclk = 0;
    #3;prst_n = 0;  //Active low reset
    #10; prst_n = 1;
    
    #500; prst_n = 0;
    #150; prst_n = 1;
  end
  
//   initial begin
// //     uvm_config_db#(virtual apb_interface)::set(null, "*", "vif", vif);
//     uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "vif", vif);
//     run_test("write_test");
    
//   end
    
//   initial begin
// //     uvm_config_db#(virtual apb_interface)::set(null, "*", "vif", vif);
//     uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "vif", vif);
//     run_test("read_test");
//   end
  
     
//   initial begin
// //     uvm_config_db#(virtual apb_interface)::set(null, "*", "vif", vif);
//     uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "vif", vif);
//     run_test("random_write_read_test");
//   end
//    initial begin
// //     uvm_config_db#(virtual apb_interface)::set(null, "*", "vif", vif);
//      uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "vif", vif);
//      run_test("slave_error_check");
//   end
  initial begin
  uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "vif", vif);
  run_test("apb_full_test");
end

  initial begin
    $dumpfile("apb_protocol.vcd");
    $dumpvars();
  end
endmodule