`ifndef PSOLAF_AXI_SL_SEQ_ITEM_SV
 `define PSOLAF_AXI_SL_SEQ_ITEM_SV


class psolaf_axi_sl_seq_item extends uvm_sequence_item;

   rand axi_direction_enum dir;

   rand logic [C_S00_AXI_ADDR_WIDTH -1 : 0] s00_axi_awaddr_s;
   rand logic [2 : 0] s00_axi_awprot_s;
   rand logic s00_axi_awvalid_s;
   rand logic s00_axi_awready_s;
   rand logic [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_wdata_s;
   rand logic [(C_S00_AXI_DATA_WIDTH/8) - 1 : 0] s00_axi_wstrb_s;
   rand logic s00_axi_wvalid_s;
   rand logic s00_axi_wready_s;
   rand logic [1 : 0] s00_axi_bresp_s;
   rand logic s00_axi_bvalid_s;
   rand logic s00_axi_bready_s;
   rand logic [C_S00_AXI_ADDR_WIDTH - 1 : 0] s00_axi_araddr_s;
   rand logic [2 : 0] s00_axi_arprot_s;
   rand logic s00_axi_arvalid_s;
   rand logic s00_axi_arready_s;
   rand logic [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_rdata_s;
   rand logic [1 : 0] s00_axi_rresp_s;
   rand logic s00_axi_rvalid_s;
   rand logic s00_axi_rready_s;
   rand logic s00_busy_s;


   `uvm_object_utils_begin(psolaf_axi_sl_seq_item)
      `uvm_field_enum(axi_direction_enum,dir,UVM_DEFAULT)
      `uvm_field_int(s00_axi_awaddr_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_awprot_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_awvalid_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_awready_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_wdata_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_wstrb_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_wvalid_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_wready_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_bresp_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_bvalid_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_bready_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_araddr_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_arprot_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_arready_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_rdata_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_rresp_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_rvalid_s,UVM_DEFAULT)
      `uvm_field_int(s00_axi_rready_s,UVM_DEFAULT)
      `uvm_field_int(s00_busy_s,UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "psolaf_axi_sl_seq_item");
      super.new(name);
   endfunction // new

endclass : psolaf_axi_sl_seq_item

`endif
