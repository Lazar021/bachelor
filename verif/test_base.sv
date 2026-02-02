`ifndef TEST_BASE_SV
 `define TEST_BASE_SV

//import psolaf_axi_pkg::*;

class test_base extends uvm_test;

   psolaf_axi_sl_env env;
   psolaf_axi_sl_config cfg;

   psolaf_axi_full_m_config m_config;

   `uvm_component_utils(test_base)

   function new(string name = "test_base", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cfg = psolaf_axi_sl_config::type_id::create("cfg");   
      uvm_config_db#(psolaf_axi_sl_config)::set(this, "env", "psolaf_axi_sl_config", cfg); 
      //
      m_config = psolaf_axi_full_m_config::type_id::create("m_config"); 
      uvm_config_db#(psolaf_axi_full_m_config)::set(this, "env", "psolaf_axi_full_m_config", m_config); 
      //   
      env = psolaf_axi_sl_env::type_id::create("env", this);      
   endfunction : build_phase

   function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
   endfunction : end_of_elaboration_phase

endclass : test_base

`endif
