`ifndef PSOLAF_AXI_FULL_M_AGENT_PKG
`define PSOLAF_AXI_FULL_M_AGENT_PKG

package psolaf_axi_full_m_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
   import master_configuration_pkg::*;   
   //parameter C_S00_AXI_ADDR_WIDTH = 6;
   //parameter C_S00_AXI_DATA_WIDTH = 32;

   parameter C_M00_TARGET_SLAVE_BASE_ADDR_c = 32'h00000000;
   // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
   parameter C_M00_AXI_BURST_LEN = 128;
   // Thread ID Width
   parameter C_M00_AXI_ID_WIDTH = 1;
   // Width of Address Bus
   parameter C_M00_AXI_ADDR_WIDTH = 32;
   // Width of Data Bus
   parameter C_M00_AXI_DATA_WIDTH = 32;
   // Width of User Write Address Bus
   parameter C_M00_AXI_AWUSER_WIDTH = 0;
   // Width of User Read Address Bus
   parameter C_M00_AXI_ARUSER_WIDTH = 0;
   // Width of User Write Data Bus
   parameter C_M00_AXI_WUSER_WIDTH = 0;
   // Width of User Read Data Bus
   parameter C_M00_AXI_RUSER_WIDTH = 0;
   // Width of User Response Bus
   parameter C_M00_AXI_BUSER_WIDTH = 0;

   parameter   ADDR_LSB = (C_M00_AXI_DATA_WIDTH/32) + 1;
   parameter OUT_SIZE = 100000;
   parameter W_HIGH_M_TOP = 32;
   parameter W_LOW_M_TOP = 0;

  typedef enum {
    AXIF_INIT = 0,
    AXIF_READ_ADDR = 1,
    AXIF_READ = 2,
    AXIF_READ_WRITE_OUT_ADDR = 3,
    AXIF_READ_WRITE_OUT = 4,
    AXIF_READ_WRITE_OUT_SINGLE = 5,
    AXIF_READ_WRITE_ADDR_SETUP = 6,
    AXIF_WRITE_ADDR = 7,
    AXIF_WRITE = 8
  } axi_full_direction_enum; 



  typedef enum {
    //write_addr_out = 0,
    write_out = 0
  } axi_full_monitor_enum; 

  import psolaf_axi_sl_seq_pkg::M_SIZE;
  import psolaf_axi_sl_seq_pkg::IN_SIZE;
  import psolaf_axi_sl_seq_pkg::GAMMA_REG_ADDR_C;
  import psolaf_axi_sl_seq_pkg::start_ev;
  import psolaf_axi_sl_seq_pkg::C_S00_AXI_ADDR_WIDTH;
  import psolaf_axi_sl_seq_pkg::C_S00_AXI_DATA_WIDTH;
  import psolaf_axi_sl_agent_pkg::MEM_HAN;
  import psolaf_axi_sl_agent_pkg::han_val_ready;
  import psolaf_axi_sl_agent_pkg::fp32_to_fixed_han;


  int MEM_M[M_SIZE];
  int MEM_IN[IN_SIZE];
  int MEM_OUT[200000];
  int rdata_cnt = 0;
  int k;
  int wdata_cnt = 0;
  int write_index = 0;
  event new_state_e,new_mst_state_e;
  logic [6 : 0] state_reg;
  logic [6 : 0] mst_state_reg;
  int pit_compare = 0;
  //command-line arguments
  string input_in;

  `include "psolaf_axi_full_m_seq_item.sv"
  `include "psolaf_axi_full_m_sequencer.sv"
  `include "psolaf_axi_full_m_driver.sv"
  `include "psolaf_axi_full_m_monitor.sv"
  `include "psolaf_axi_full_m_agent.sv"


endpackage : psolaf_axi_full_m_agent_pkg
`include "../../psolaf_if.sv"
`endif



