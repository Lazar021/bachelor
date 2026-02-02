`ifndef PSOLAF_IF_SV
 `define PSOLAF_IF_SV


typedef enum logic [6:0] {
    idle = 7'b0000000,
    razdaljina = 7'b0000001,
    addr_set = 7'b0000010,
    erase = 7'b0000011,
    addr_set_p = 7'b0000100,
    mPLast = 7'b0000101,
    tk = 7'b0000110,
    matk = 7'b0000111,
    addr_min = 7'b0001000,
    min = 7'b0001001,
    p_addr = 7'b0001010,
    place = 7'b0001011,
    han = 7'b0001100,
    gr = 7'b0001101,
    par1 = 7'b0001110,
    par3 = 7'b0001111,
    interp1 = 7'b0010000,
    out_asmd = 7'b0010001
} state_type;

typedef enum logic [6:0] {
    idle_m = 7'b0000000,
    init_write = 7'b0000001,
    init_read_m = 7'b0000010,
    read_m = 7'b0000011,
    erase_first_m = 7'b0000100,
    m_last = 7'b0000101,
    write_p = 7'b0000110,
    m_write_last = 7'b0000111,
    read_m_matk = 7'b0001000,
    place_m = 7'b0001001,
    init_read_han = 7'b0001010,
    read_han = 7'b0001011,
    init_read_opseg = 7'b0001100,
    read_opseg = 7'b0001101,
    read_opseg_2 = 7'b0001110,
    init_compare = 7'b0001111,
    write_out = 7'b0010000,
    write_out_2 = 7'b0010001,
    m_wrtie_last_addr_setup = 7'b0010010
} mst_state_type;



interface psolaf_if (input clk, logic rst);

    // Users to add parameters here
    //Oduzimaju se gornja dva bita od ADDR_W da bi znali u koju memoriju ide
    parameter ADDR_W                       = 16; //12 je dosta za 1500  tj 4095 podataka

    //IN memorija 
    parameter SIZE_IN_TOP                  = 10000;
    parameter W_HIGH_IN_TOP                = 1;
    parameter W_LOW_IN_TOP                 = -25;
    //OPSEG memorija
    parameter SIZE_OPSEG_TOP               = 5000;
    parameter W_HIGH_OPSEG_ADDR_TOP        = 14;
    parameter W_HIGH_OPSEG_TOP             = 1;
    parameter W_LOW_OPSEG_TOP              = -25;
    //M memorija
    //kod ove memorije pogledaj kako kada su vrednosti preko 20k kako se cita in memorija
    parameter SIZE_M_TOP                  = 1000;
    parameter SIZE_ADDR_W_M               = 14;
    parameter W_HIGH_M_TOP                = 32;
    parameter W_LOW_M_TOP                 = 0;
    //HAN memorija
    parameter W_HAN_TOP		             = 32;
    //OUT memorija
    parameter SIZE_OUT_TOP                = 15000;
    parameter SIZE_ADDR_W_OUT             = 14;
//    izmena 2.jul2024
    // parameter W_HIGH_OUT_TOP              = 1;
    // parameter W_LOW_OUT_TOP               = -31;

    parameter W_HIGH_OUT_TOP              = 2;
    parameter W_LOW_OUT_TOP               = -30;
    
    // User parameters ends
    // Do not modify the parameters beyond this line


    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter C_S00_AXI_DATA_WIDTH		= 32;
    parameter C_S00_AXI_ADDR_WIDTH		= 6;

    // Parameters of Axi Master Bus Interface M00_AXI
    parameter C_M00_AXI_BURST_LEN				= 128;
    parameter C_M00_AXI_ID_WIDTH				= 1;
    parameter C_M00_AXI_ADDR_WIDTH				= 32;
    parameter C_M00_AXI_DATA_WIDTH				= 32;
    parameter C_M00_AXI_AWUSER_WIDTH			= 1;
    parameter C_M00_AXI_ARUSER_WIDTH			= 1;
    parameter C_M00_AXI_WUSER_WIDTH				= 1;
    parameter C_M00_AXI_RUSER_WIDTH				= 1;
    parameter C_M00_AXI_BUSER_WIDTH				= 1;

    // Ports of Axi Slave Bus Interface S00_AXI
    logic                                       s00_axi_aclk_i;
    logic                                       s00_axi_aresetn_i;
    logic [C_S00_AXI_ADDR_WIDTH - 1 : 0]        s00_axi_awaddr_i;
    logic [2 : 0]                               s00_axi_awprot_i;
    logic                                       s00_axi_awvalid_i;
    logic                                       s00_axi_awready_o;
    logic [C_S00_AXI_DATA_WIDTH - 1 : 0]        s00_axi_wdata_i;
    logic [(C_S00_AXI_DATA_WIDTH/8) - 1 : 0]    s00_axi_wstrb_i;
    logic                                       s00_axi_wvalid_i;
    logic                                       s00_axi_wready_o;
    logic [1 : 0]                               s00_axi_bresp_o;
    logic                                       s00_axi_bvalid_o;
    logic                                       s00_axi_bready_i;
    logic [C_S00_AXI_ADDR_WIDTH - 1 : 0]        s00_axi_araddr_i;
    logic [2 : 0]                               s00_axi_arprot_i;
    logic                                       s00_axi_arvalid_i;
    logic                                       s00_axi_arready_o;
    logic [C_S00_AXI_DATA_WIDTH - 1 : 0]        s00_axi_rdata_o;
    logic [1 : 0]                               s00_axi_rresp_o;
    logic                                       s00_axi_rvalid_o;
    logic                                       s00_axi_rready_i;

    // Ports of Axi Master Bus Interface M00_AXI
    logic                                       m00_axi_init_axi_txn_i;
    logic                                       m00_axi_txn_done_o;
    logic                                       m00_axi_error_o;
    logic                                       m00_axi_aclk_i;
    logic                                       m00_axi_aresetn_i;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0]         m00_axi_awid_o;
    logic  [C_M00_AXI_ADDR_WIDTH - 1 : 0]       m00_axi_awaddr_o;
    logic  [W_HIGH_M_TOP - 1 : W_LOW_M_TOP]     m00_axi_awlen_o;
    logic  [2 : 0]                              m00_axi_awsize_o;
    logic  [1 : 0]                              m00_axi_awburst_o;
    logic                                       m00_axi_awlock_o;
    logic  [3 : 0]                              m00_axi_awcache_o;
    logic  [2 : 0]                              m00_axi_awprot_o;
    logic  [3 : 0]                              m00_axi_awqos_o;
    logic  [C_M00_AXI_AWUSER_WIDTH - 1 : 0]     m00_axi_awuser_o;
    logic                                       m00_axi_awvalid_o;
    logic                                       m00_axi_awready_i;
    logic  [C_M00_AXI_DATA_WIDTH - 1 : 0]       m00_axi_wdata_o;
    logic  [(C_M00_AXI_DATA_WIDTH/8 - 1) : 0]   m00_axi_wstrb_o;
    logic                                       m00_axi_wlast_o;
    logic  [C_M00_AXI_WUSER_WIDTH - 1 : 0]      m00_axi_wuser_o;
    logic                                       m00_axi_wvalid_o;
    logic                                       m00_axi_wready_i;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0]         m00_axi_bid_i;
    logic  [1 : 0]                              m00_axi_bresp_i;
    logic  [C_M00_AXI_BUSER_WIDTH - 1 : 0]      m00_axi_buser_i;
    logic                                       m00_axi_bvalid_i;
    logic                                       m00_axi_bready_o;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0]         m00_axi_arid_o;
    logic  [C_M00_AXI_ADDR_WIDTH - 1 : 0]       m00_axi_araddr_o;
    logic  [W_HIGH_M_TOP - 1 : W_LOW_M_TOP]     m00_axi_arlen_o;
    logic  [2 : 0]                              m00_axi_arsize_o;
    logic  [1 : 0]                              m00_axi_arburst_o;
    logic                                       m00_axi_arlock_o;
    logic  [3 : 0]                              m00_axi_arcache_o;
    logic  [2 : 0]                              m00_axi_arprot_o;
    logic  [3 : 0]                              m00_axi_arqos_o;
    logic  [C_M00_AXI_ARUSER_WIDTH - 1 : 0]     m00_axi_aruser_o;
    logic                                       m00_axi_arvalid_o;
    logic                                       m00_axi_arready_i;
    logic  [C_M00_AXI_ID_WIDTH - 1 : 0]         m00_axi_rid_i;
    logic  [C_M00_AXI_DATA_WIDTH - 1 : 0]       m00_axi_rdata_i;
    logic  [1 : 0]                              m00_axi_rresp_i;
    logic                                       m00_axi_rlast_i;
    logic  [C_M00_AXI_RUSER_WIDTH - 1 : 0]      m00_axi_ruser_i;
    logic                                       m00_axi_rvalid_i;
    logic                                       m00_axi_rready_o;

    // internal DUT signals for coverage
    state_type                                  m00_fsm_state; 
    mst_state_type                              m00_mst_state_o;

endinterface : psolaf_if
`endif