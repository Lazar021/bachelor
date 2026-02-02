`ifndef PSOLAF_AXI_SL_SEQ_PKG_SV
 `define PSOLAF_AXI_SL_SEQ_PKG_SV
package psolaf_axi_sl_seq_pkg;
   import uvm_pkg::*;      // import the UVM library
 `include "uvm_macros.svh" // Include the UVM macros


   import configuration_pkg::*;
   
   parameter C_S00_AXI_ADDR_WIDTH = 6;
   parameter C_S00_AXI_DATA_WIDTH = 32;

   // AXI direction - read or write
   typedef enum {
      AXIL_READ = 0,
      AXIL_WRITE = 1
   } axi_direction_enum;
   event start_ev;
   bit place_en_v;
   bit calc_han_once;
   int ready_psolaf;
   int just_read_ready;
   bit end_flag_read;




  parameter M_SIZE_REG_ADDR_C = 16;
  parameter GAMMA_REG_ADDR_C = 8;
  parameter GAMMA_REC_REG_ADDR_C = 60;
  parameter M_SIZE = 1500;
//   parameter IN_SIZE = 27753;
  // int M_SIZE = m_size_cfg;
  parameter IN_SIZE = 150000;
  parameter PLACE_EN_ADDR_C  = 32;
  parameter PIT_REG_ADDR_C = 28;
  parameter READY_REG_ADDR_C = 24;
  parameter END_FLAG_ADDR_C = 40;

 `include "../Agent/psolaf_axi_sl_seq_item.sv" 
 `include "../Agent/psolaf_axi_sl_sequencer.sv" 

 `include "psolaf_axi_sl_base_seq.sv"
 `include "psolaf_axi_sl_simple_seq.sv"
endpackage : psolaf_axi_sl_seq_pkg
`endif
