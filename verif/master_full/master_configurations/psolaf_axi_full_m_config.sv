`ifndef PSOLAF_AXI_FULL_M_CONFIG_SV
`define PSOLAF_AXI_FULL_M_CONFIG_SV

//import configurations_pkg::*;


class psolaf_axi_full_m_config extends uvm_object;

   uvm_active_passive_enum is_active = UVM_ACTIVE;
   string input_in;
   string input_m;

   `uvm_object_utils_begin (psolaf_axi_full_m_config)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_object_utils_end

   function new(string name = "psolaf_axi_full_m_config");
      super.new(name);
   endfunction
   
   // Custom initialization function
   function void set_config();

      $display("psolaf_axi_full_m_config input_in_cfg = %f", input_in_cfg);
      $display("psolaf_axi_full_m_config input_m_cfg = %f", input_m_cfg);
      input_in_cfg = input_in;
      input_m_cfg = input_m;
   endfunction

endclass : psolaf_axi_full_m_config
`endif
