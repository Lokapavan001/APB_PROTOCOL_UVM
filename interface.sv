`ifndef APB_INTERFACE
`define APB_INTERFACE
interface apb_interface(input pclk,rst_n);
  logic psel;
  logic penable;
  logic [31:0]paddr;
  logic [31:0]pwdata;
  logic pwrite;
  logic [31:0]prdata;
  logic pready;
  logic pslverr;
  
  clocking cb_driver @(negedge pclk);
  
   //default input #2ns output #3ns
   output psel,penable,pwrite,pwdata,paddr;
   input pready,pslverr,prdata;
  endclocking
  
  clocking cb_monitor @(negedge pclk);
  //default input #2ns output #3ns
     
   input psel,penable,pwrite,pwdata,paddr;
   input pready,pslverr,prdata;
  endclocking
  
  
  modport mp_master( output psel,penable,pwrite,pwdata,paddr,
   input pready,pslverr,prdata);
  modport mp_slave(input psel,penable,pwrite,pwdata,paddr,output pready,pslverr,prdata);
  
endinterface
`endif