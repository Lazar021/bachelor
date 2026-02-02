`ifndef PSOLAF_AXI_SL_MONITOR
`define PSOLAF_AXI_SL_MONITOR

class psolaf_axi_sl_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   uvm_analysis_port #(psolaf_axi_sl_seq_item) item_collected_port_lite;

   `uvm_component_utils_begin(psolaf_axi_sl_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface psolaf_if vif;

   // current transaction
   psolaf_axi_sl_seq_item curr_it;

   // coverage can go here
   // ...
   covergroup cg_axi_lite_addr @(posedge(vif.s00_axi_awready_o || vif.s00_axi_arready_o));
      option.per_instance = 1;
      lite_aw_addr : coverpoint (vif.s00_axi_awaddr_i) {
         option.at_least = 1;
         bins m_size = {16};
         bins gamma = {8};
         bins alpha = {0};
         bins beta = {4};
         bins in_size = {12};

      }

      lite_ar_addr : coverpoint (vif.s00_axi_araddr_i) {
         option.at_least = 1;
         bins pit_reg = {28};
         bins place_en = {32};
         bins raedy_reg = {24};
         bins end_flag = {40};
      }
   endgroup : cg_axi_lite_addr

   function new(string name = "psolaf_axi_sl_monitor", uvm_component parent = null);
      super.new(name,parent);      
      item_collected_port_lite = new("item_collected_port_lite", this);
      if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      if(coverage_enable)begin
         cg_axi_lite_addr = new(); 
      end
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
   endfunction : connect_phase

   task main_phase(uvm_phase phase);
      forever begin
         curr_it = psolaf_axi_sl_seq_item::type_id::create("curr_it", this);

         @(posedge vif.clk iff (vif.s00_axi_arready_o == 1 && vif.s00_axi_arvalid_i == 1));
         curr_it.s00_axi_araddr_s = vif.s00_axi_araddr_i;
         
         item_collected_port_lite.write(curr_it);

         @(posedge vif.clk iff (vif.s00_axi_rvalid_o == 1 && vif.s00_axi_rready_i == 1));

         curr_it.s00_axi_awaddr_s = vif.s00_axi_awaddr_i;
         curr_it.s00_axi_awprot_s = vif.s00_axi_awprot_i;
         curr_it.s00_axi_awvalid_s = vif.s00_axi_awvalid_i;
         curr_it.s00_axi_awready_s = vif.s00_axi_awready_o;
         curr_it.s00_axi_wdata_s = vif.s00_axi_wdata_i;
         curr_it.s00_axi_wstrb_s = vif.s00_axi_wstrb_i;
         curr_it.s00_axi_wvalid_s = vif.s00_axi_wvalid_i;
         curr_it.s00_axi_wready_s = vif.s00_axi_wready_o;
         curr_it.s00_axi_bresp_s = vif.s00_axi_bresp_o;
         curr_it.s00_axi_bvalid_s = vif.s00_axi_bvalid_o;
         curr_it.s00_axi_bready_s = vif.s00_axi_bready_i;
         curr_it.s00_axi_araddr_s = vif.s00_axi_araddr_i;
         curr_it.s00_axi_arprot_s = vif.s00_axi_arprot_i;
         curr_it.s00_axi_arvalid_s = vif.s00_axi_arvalid_i;
         curr_it.s00_axi_arready_s = vif.s00_axi_arready_o;
         curr_it.s00_axi_rdata_s = vif.s00_axi_rdata_o;
         curr_it.s00_axi_rresp_s = vif.s00_axi_rresp_o;
         curr_it.s00_axi_rvalid_s = vif.s00_axi_rvalid_o;
         curr_it.s00_axi_rready_s = vif.s00_axi_rready_i;

         item_collected_port_lite.write(curr_it);
      end
   endtask : main_phase

endclass : psolaf_axi_sl_monitor
`endif