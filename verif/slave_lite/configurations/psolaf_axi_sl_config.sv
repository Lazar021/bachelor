`ifndef PSOLAF_AXI_SL_CONFIG_SV
 `define PSOLAF_AXI_SL_CONFIG_SV


class psolaf_axi_sl_config extends uvm_object;

   uvm_active_passive_enum is_active = UVM_ACTIVE;
   real alpha;
   real beta;
   real gamma;
   real gamma_rec;
   int m_size;
   int in_size;

   `uvm_object_utils_begin (psolaf_axi_sl_config)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
      `uvm_field_real(alpha, UVM_DEFAULT)
      `uvm_field_real(beta, UVM_DEFAULT)
      `uvm_field_real(gamma, UVM_DEFAULT)
   `uvm_object_utils_end

   function new(string name = "psolaf_axi_sl_config");
      super.new(name);
   endfunction

   // function void build_phase(uvm_phase phase);
   //    super.build_phase(phase);

   //    /************Geting from configuration database*******************/

   //    if(!uvm_config_db#(real)::get(this, "", "alpha_top_arg6", alpha))
   //      `uvm_fatal("NOALPHA",{"psolaf_axi_sl_config Argument alpha must be set: ",get_full_name(),".arg"})
   //      $display("psolaf_axi_sl_config alpha = %f",alpha);
   //    /*****************************************************************/
      
   // endfunction : build_phase

   // Custom initialization function
   function void set_config();
      // if (!uvm_config_db#(real)::get(this, "", "alpha_top_arg6", alpha)) begin
      //    `uvm_fatal("NOALPHA",{"psolaf_axi_sl_config Argument alpha must be set: ", get_full_name(), ".arg"})
      // end
      $display("psolaf_axi_sl_config alpha_cfg = %f", alpha_cfg);
      $display("psolaf_axi_sl_config alpha = %f", alpha);
      alpha_cfg = alpha;
      beta_cfg = beta;
      gamma_cfg = gamma;
      gamma_rec_cfg = gamma_rec;
      m_size_cfg = m_size;
      in_size_cfg = in_size;
   endfunction

endclass : psolaf_axi_sl_config
`endif
