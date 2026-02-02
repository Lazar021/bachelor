`ifndef PSOLAF_AXI_FULL_M_SEQ_PKG_SV
 `define PSOLAF_AXI_FULL_M_SEQ_PKG_SV
package psolaf_axi_full_m_seq_pkg;
   import uvm_pkg::*;      // import the UVM library
 `include "uvm_macros.svh" // Include the UVM macros
  import psolaf_axi_full_m_agent_pkg::psolaf_axi_full_m_seq_item;
  import psolaf_axi_full_m_agent_pkg::psolaf_axi_full_m_sequencer;
  import psolaf_axi_sl_seq_pkg::C_S00_AXI_ADDR_WIDTH;
  import psolaf_axi_sl_seq_pkg::C_S00_AXI_DATA_WIDTH;
  import psolaf_axi_full_m_agent_pkg::C_M00_AXI_DATA_WIDTH;
  import psolaf_axi_full_m_agent_pkg::C_M00_AXI_ADDR_WIDTH;
  import psolaf_axi_full_m_agent_pkg::C_M00_AXI_BURST_LEN;
  import psolaf_axi_full_m_agent_pkg::ADDR_LSB;
  import psolaf_axi_sl_seq_pkg::M_SIZE;
  import psolaf_axi_full_m_agent_pkg::AXIF_INIT;
  import psolaf_axi_full_m_agent_pkg::AXIF_READ_ADDR;
  import psolaf_axi_full_m_agent_pkg::AXIF_READ;
  import psolaf_axi_full_m_agent_pkg::AXIF_WRITE_ADDR;
  import psolaf_axi_full_m_agent_pkg::AXIF_WRITE;
  import psolaf_axi_full_m_agent_pkg::AXIF_READ_WRITE_OUT_ADDR;
  import psolaf_axi_full_m_agent_pkg::AXIF_READ_WRITE_OUT;
  import psolaf_axi_full_m_agent_pkg::AXIF_READ_WRITE_OUT_SINGLE;
  import psolaf_axi_full_m_agent_pkg::AXIF_READ_WRITE_ADDR_SETUP;
  import psolaf_axi_full_m_agent_pkg::MEM_M;
  import psolaf_axi_full_m_agent_pkg::rdata_cnt;
  import psolaf_axi_full_m_agent_pkg::wdata_cnt;
  import psolaf_axi_full_m_agent_pkg::k;
  import psolaf_axi_full_m_agent_pkg::MEM_IN;
  import psolaf_axi_sl_agent_pkg::MEM_HAN;
  import psolaf_axi_sl_agent_pkg::fp32_to_fixed_han;
  import psolaf_axi_sl_agent_pkg::fp32_to_fixed_han_debug;
  import psolaf_axi_full_m_agent_pkg::MEM_OUT;
  import psolaf_axi_sl_seq_pkg::ready_psolaf;
  import psolaf_axi_sl_seq_pkg::end_flag_read;
  import psolaf_axi_sl_seq_pkg::just_read_ready;
  import psolaf_axi_sl_seq_pkg::place_en_v;
  import psolaf_axi_sl_seq_pkg::calc_han_once;
  // command-line arguments
  import master_configuration_pkg::*;
  // import psolaf_axi_full_m_agent_pkg::input_in;
  //import psolaf_axi_full_m_agent_pkg::*;  
  parameter M_SIZE_REG_ADDR_C = 16;
  string input_in_m_seq;
 

 `include "psolaf_axi_full_m_base_seq.sv"
 `include "psolaf_axi_full_m_simple_seq.sv"
endpackage 
`endif
