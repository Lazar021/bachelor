`ifndef CONFIGURATION_PKG_SV
 `define CONFIGURATION_PKG_SV

package configuration_pkg;

   import uvm_pkg::*;      // import the UVM library   
 `include "uvm_macros.svh" // Include the UVM macros

  real alpha_cfg;
  real beta_cfg;
  real gamma_cfg;
  real gamma_rec_cfg;
  int m_size_cfg;
  int in_size_cfg;

`include "psolaf_axi_sl_config.sv"


endpackage : configuration_pkg

`endif

