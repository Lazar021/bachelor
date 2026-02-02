`ifndef PSOLAF_AXI_FULL_M_SEQ_ITEM_SV
 `define PSOLAF_AXI_FULL_M_SEQ_ITEM_SV
 

class psolaf_axi_full_m_seq_item extends uvm_sequence_item;



   rand axi_full_direction_enum dir_full;
   rand logic  m00_axi_init_axi_txn_s;
    logic  m00_axi_txn_done_s;
    logic  m00_axi_error_s;
   //nd logic  m00_axi_aclk_s;
   //nd logic  m00_axi_aresetn_s;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0] m00_axi_awid_s;
    logic  [C_M00_AXI_ADDR_WIDTH - 1 : 0]   m00_axi_awaddr_s;
    logic  [W_HIGH_M_TOP - 1 : W_LOW_M_TOP]   m00_axi_awlen_s;
    logic  [2 : 0]  m00_axi_awsize_s;
    logic  [1 : 0]  m00_axi_awburst_s;
    logic  m00_axi_awlock_s;
    logic  [3 : 0]  m00_axi_awcache_s;
    logic  [2 : 0]  m00_axi_awprot_s;
    logic  [3 : 0]  m00_axi_awqos_s;
    logic  [C_M00_AXI_AWUSER_WIDTH - 1 : 0] m00_axi_awuser_s;
    logic  m00_axi_awvalid_s;
   rand logic  m00_axi_awready_s;
    logic  [C_M00_AXI_DATA_WIDTH - 1 : 0]   m00_axi_wdata_s;
    logic  [(C_M00_AXI_DATA_WIDTH/8 - 1) : 0] m00_axi_wstrb_s;
    logic  m00_axi_wlast_s;
    logic  [C_M00_AXI_WUSER_WIDTH - 1 : 0]  m00_axi_wuser_s;
    logic  m00_axi_wvalid_s;
   rand logic  m00_axi_wready_s;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0] m00_axi_bid_s;
   rand logic  [1 : 0]  m00_axi_bresp_s;
    logic  [C_M00_AXI_BUSER_WIDTH - 1 : 0]  m00_axi_buser_s;
   rand logic  m00_axi_bvalid_s;
    logic  m00_axi_bready_s;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0] m00_axi_arid_s;
    logic  [C_M00_AXI_ADDR_WIDTH - 1 : 0]   m00_axi_araddr_s;
    logic  [W_HIGH_M_TOP - 1 : W_LOW_M_TOP]    m00_axi_arlen_s;
    logic  [2 : 0]  m00_axi_arsize_s;
    logic  [1 : 0]  m00_axi_arburst_s;
    logic  m00_axi_arlock_s;
    logic  [3 : 0]  m00_axi_arcache_s;
    logic  [2 : 0]  m00_axi_arprot_s;
    logic  [3 : 0]  m00_axi_arqos_s;
    logic  [C_M00_AXI_ARUSER_WIDTH - 1 : 0] m00_axi_aruser_s;
    logic  m00_axi_arvalid_s;
   rand logic  m00_axi_arready_s;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0] m00_axi_rid_s;
    logic  [C_M00_AXI_DATA_WIDTH - 1 : 0]   m00_axi_rdata_s;
    logic  [1 : 0]m00_axi_rresp_s;
   rand logic  m00_axi_rlast_s;
    logic  [C_M00_AXI_RUSER_WIDTH - 1 : 0]  m00_axi_ruser_s;
   rand logic  m00_axi_rvalid_s;
    logic  m00_axi_rready_s;

   `uvm_object_utils_begin(psolaf_axi_full_m_seq_item)
      `uvm_field_enum(axi_full_direction_enum,dir_full,UVM_DEFAULT)
      `uvm_field_int(m00_axi_init_axi_txn_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_txn_done_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_error_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awaddr_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awlen_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awsize_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awburst_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awlock_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awcache_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awprot_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awqos_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awuser_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awvalid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_awready_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_wdata_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_wstrb_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_wlast_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_wuser_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_wvalid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_wready_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_bid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_bresp_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_buser_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_bvalid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_bready_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_araddr_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arlen_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arsize_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arburst_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arlock_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arcache_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arprot_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arqos_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_aruser_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arvalid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_arready_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_rid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_rdata_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_rresp_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_rlast_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_ruser_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_rvalid_s,UVM_DEFAULT)
      `uvm_field_int(m00_axi_rready_s,UVM_DEFAULT)
   `uvm_object_utils_end



   function new (string name = "psolaf_axi_full_m_seq_item");
      super.new(name);
   endfunction // new

   constraint dir_afinit {dir_full == AXIF_INIT; }
   constraint dir_afar {dir_full == AXIF_READ_ADDR; }
   constraint dir_afread {dir_full == AXIF_READ; }
   constraint dir_af_write_read_addr {dir_full == AXIF_READ_WRITE_OUT_ADDR; }
   constraint dir_af_write_read {dir_full == AXIF_READ_WRITE_OUT; }
   constraint dir_af_write_read_single {dir_full == AXIF_READ_WRITE_OUT_SINGLE; }
   constraint dir_af_write_addr_setup {dir_full == AXIF_READ_WRITE_ADDR_SETUP; }
   
   constraint init_0 { 
      if(dir_full == AXIF_INIT)
         m00_axi_init_axi_txn_s == 1;
      else
         m00_axi_init_axi_txn_s == 0;
   }
   constraint arready {
      if(dir_full == AXIF_READ_ADDR || dir_full == AXIF_READ_WRITE_OUT_ADDR)
         m00_axi_arready_s == 1;
      else
         m00_axi_arready_s == 0;
   }
   constraint rvalid {
      if((dir_full == AXIF_READ || dir_full == AXIF_READ_WRITE_OUT || dir_full == AXIF_READ_WRITE_OUT_SINGLE || dir_full == AXIF_READ_WRITE_ADDR_SETUP) && rdata_cnt <= k)
         m00_axi_rvalid_s == 1;
      else if((dir_full == AXIF_READ || dir_full == AXIF_READ_WRITE_OUT || dir_full == AXIF_READ_WRITE_OUT_SINGLE || dir_full == AXIF_READ_WRITE_ADDR_SETUP) && rdata_cnt == k)
         m00_axi_rvalid_s == 1;
      else
         m00_axi_rvalid_s == 0;
   }
   constraint rlast {
      if((dir_full == AXIF_READ || dir_full == AXIF_READ_WRITE_OUT || dir_full == AXIF_READ_WRITE_OUT_SINGLE || dir_full == AXIF_READ_WRITE_ADDR_SETUP) && rdata_cnt == k)
         m00_axi_rlast_s == 1;
      else
         m00_axi_rlast_s == 0;
   }
   //WRITE constrains
   constraint awready {
      if(dir_full == AXIF_READ_WRITE_OUT_ADDR)
         m00_axi_awready_s == 1;
      else
         m00_axi_awready_s == 0;
   }
   constraint wready {
      if(dir_full == AXIF_READ_WRITE_OUT || dir_full == AXIF_READ_WRITE_OUT_SINGLE || dir_full == AXIF_READ_WRITE_ADDR_SETUP)
         m00_axi_wready_s == 1;
      else
         m00_axi_wready_s == 0;
   }
   constraint bvalid {
      if(dir_full == AXIF_READ_WRITE_OUT || dir_full == AXIF_READ_WRITE_OUT_SINGLE || dir_full == AXIF_READ_WRITE_ADDR_SETUP)
         m00_axi_bvalid_s == 1;
      else
         m00_axi_bvalid_s == 0;
   }
   constraint bresp {
      if(dir_full == AXIF_READ_WRITE_OUT || dir_full == AXIF_READ_WRITE_OUT_SINGLE || dir_full == AXIF_READ_WRITE_ADDR_SETUP)
         m00_axi_bresp_s == 2'b00;
   }
endclass : psolaf_axi_full_m_seq_item

`endif
