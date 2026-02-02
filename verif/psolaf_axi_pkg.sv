`ifndef PSOLAF_AXI_PKG_SV
`define PSOLAF_AXI_PKG_SV

package psolaf_axi_pkg;

 import uvm_pkg::*;
`include "uvm_macros.svh"





//======================== SLAVE =============================

import configuration_pkg::*;
import psolaf_axi_sl_seq_pkg::*;
//import psolaf_axi_full_m_seq_pkg::*;

import psolaf_axi_sl_agent_pkg::*;
import master_configuration_pkg::*;
import psolaf_axi_full_m_agent_pkg::*;
import psolaf_axi_full_m_seq_pkg::*;




//import psolaf_axi_full_m_agent_pkg::psolaf_axi_full_m_agent;
`include "psolaf_scoreboard.sv"
`include "psolaf_axi_sl_env.sv"
//`include "psolaf_axi_sl_config.sv"
`include "test_base.sv"
`include "test_simple.sv"
// `include "psolaf_verif_top.sv"



endpackage : psolaf_axi_pkg
`include "psolaf_if.sv"
`endif