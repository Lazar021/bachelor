`ifndef MASTER_CONFIGURATION_PKG_SV
 `define MASTER_CONFIGURATION_PKG_SV

package master_configuration_pkg;

   import uvm_pkg::*;      // import the UVM library   
 `include "uvm_macros.svh" // Include the UVM macros

//command-line arguments
string input_in_cfg;
string input_m_cfg;

`include "psolaf_axi_full_m_config.sv"


endpackage : master_configuration_pkg

`endif

