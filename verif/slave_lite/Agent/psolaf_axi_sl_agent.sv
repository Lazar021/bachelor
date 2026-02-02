`ifndef PSOLAF_AXI_SL_AGENT
`define PSOLAF_AXI_SL_AGENT

class psolaf_axi_sl_agent extends uvm_agent;

   // components
   psolaf_axi_sl_driver drv;
   psolaf_axi_sl_sequencer seqr;
   psolaf_axi_sl_monitor mon_sl;
   virtual interface psolaf_if vif;
   // configuration
   psolaf_axi_sl_config cfg;
   int value;   
   `uvm_component_utils_begin (psolaf_axi_sl_agent)
      `uvm_field_object(cfg, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "psolaf_axi_sl_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      /************Geting from configuration database*******************/
      if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      
      if(!uvm_config_db#(psolaf_axi_sl_config)::get(this, "", "psolaf_axi_sl_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})

      // if(!uvm_config_db#(real)::get(this, "", "alpha_top_arg6", alpha))
      //   `uvm_fatal("NOALPHA",{"Argument alpha must be set: ",get_full_name(),".arg"})
      /*****************************************************************/
      
      /************Setting to configuration database********************/
            uvm_config_db#(virtual psolaf_if)::set(this, "*", "psolaf_if", vif);
      /*****************************************************************/
      
      mon_sl = psolaf_axi_sl_monitor::type_id::create("mon_sl", this);
      if(cfg.is_active == UVM_ACTIVE) begin
         drv = psolaf_axi_sl_driver::type_id::create("drv", this);
         seqr = psolaf_axi_sl_sequencer::type_id::create("seqr", this);
      end
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(cfg.is_active == UVM_ACTIVE) begin
         drv.seq_item_port.connect(seqr.seq_item_export);
      end
   endfunction : connect_phase

endclass : psolaf_axi_sl_agent

`endif