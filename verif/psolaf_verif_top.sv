`include "psolaf_axi_pkg.sv"
module psolaf_verif_top;

   import uvm_pkg::*;     // import the UVM library
   `include "uvm_macros.svh" // Include the UVM macros

   import psolaf_axi_pkg::*;

   // arguments from reggression tcl script
   string input_in_top;
   string input_m_top;
   string output_iniGr_top;
   string output_write_out_top;
   string output_read_out_top; 
   string check_pit_top; 
   real alpha_top;
   real beta_top;
   real gamma_top;
   real gamma_rec_top;
   int m_size_top;
   int in_size_top;

   logic clk;
   logic  rst;

   // interface
   psolaf_if psolaf_vif(clk, rst);

   // DUT
   psolaf_axi_v1_0 #(
            //Users to add parameters here
            //Oduzimaju se gornja dva bita od ADDR_W da bi znali u koju memoriju ide
            .ADDR_W(16), //12 je dosta za 1500  tj 4095 podataka

            //IN memorija 
            .SIZE_IN_TOP(10000),
            .W_HIGH_IN_TOP(1),
            .W_LOW_IN_TOP(-25),
            //OPSEG memorija
            .SIZE_OPSEG_TOP(5000),          
            .W_HIGH_OPSEG_ADDR_TOP(14),     
            .W_HIGH_OPSEG_TOP(1),           
            .W_LOW_OPSEG_TOP(-25),          
            //M memorija
            //kod ove memorije pogledaj kako kada su vrednosti preko 20k kako se cita in memorija
            .SIZE_M_TOP(1000),           
            .SIZE_ADDR_W_M(14),          
            .W_HIGH_M_TOP(32),           
            .W_LOW_M_TOP(0),             
            //HAN memorija
            .W_HAN_TOP(32),
            //OUT memorija
            .SIZE_OUT_TOP(15000), 
            .SIZE_ADDR_W_OUT(14), 
            // izmena 3. jul 2024
            // .W_HIGH_OUT_TOP(1),   
            // .W_LOW_OUT_TOP(-31),  
            
            .W_HIGH_OUT_TOP(2),   
            .W_LOW_OUT_TOP(-30), 
            // User parameters ends
            // Do not modify the parameters beyond this line


            // Parameters of Axi Slave Bus Interface S00_AXI
            .C_S00_AXI_DATA_WIDTH(32),
            .C_S00_AXI_ADDR_WIDTH(6),


            // Parameters of Axi Master Bus Interface M00_AXI
            //.C_M00_AXI_TARGET_SLAVE_BASE_ADDR(20'h40000),
            .C_M00_AXI_BURST_LEN		 (psolaf_vif.C_M00_AXI_BURST_LEN),
            .C_M00_AXI_ID_WIDTH		 (psolaf_vif.C_M00_AXI_ID_WIDTH),
            .C_M00_AXI_ADDR_WIDTH	 (psolaf_vif.C_M00_AXI_ADDR_WIDTH),
            .C_M00_AXI_DATA_WIDTH	 (psolaf_vif.C_M00_AXI_DATA_WIDTH),
            .C_M00_AXI_AWUSER_WIDTH	 (psolaf_vif.C_M00_AXI_AWUSER_WIDTH),
            .C_M00_AXI_ARUSER_WIDTH	 (psolaf_vif.C_M00_AXI_ARUSER_WIDTH),
            .C_M00_AXI_WUSER_WIDTH	 (psolaf_vif.C_M00_AXI_WUSER_WIDTH),
            .C_M00_AXI_RUSER_WIDTH	 (psolaf_vif.C_M00_AXI_RUSER_WIDTH),
            .C_M00_AXI_BUSER_WIDTH	 (psolaf_vif.C_M00_AXI_BUSER_WIDTH)
   ) DUT (
            .s00_axi_aclk        ( clk ),
            //.s00_axi_aresetn    ( psolaf_vif.s00_axi_aresetn_i ),
            .s00_axi_aresetn    ( rst ),
            .s00_axi_awaddr     ( psolaf_vif.s00_axi_awaddr_i ),
            .s00_axi_awprot     ( psolaf_vif.s00_axi_awprot_i ),
            .s00_axi_awvalid    ( psolaf_vif.s00_axi_awvalid_i ),
            .s00_axi_awready    ( psolaf_vif.s00_axi_awready_o ),
            .s00_axi_wdata      ( psolaf_vif.s00_axi_wdata_i ),
            .s00_axi_wstrb      ( psolaf_vif.s00_axi_wstrb_i ),
            .s00_axi_wvalid     ( psolaf_vif.s00_axi_wvalid_i ),
            .s00_axi_wready     ( psolaf_vif.s00_axi_wready_o ),
            .s00_axi_bresp      ( psolaf_vif.s00_axi_bresp_o ),
            .s00_axi_bvalid     ( psolaf_vif.s00_axi_bvalid_o ),     
            .s00_axi_bready     ( psolaf_vif.s00_axi_bready_i ),     
            .s00_axi_araddr     ( psolaf_vif.s00_axi_araddr_i ),     
            .s00_axi_arprot     ( psolaf_vif.s00_axi_arprot_i ),     
            .s00_axi_arvalid    ( psolaf_vif.s00_axi_arvalid_i ),        
            .s00_axi_arready    ( psolaf_vif.s00_axi_arready_o ),        
            .s00_axi_rdata      ( psolaf_vif.s00_axi_rdata_o ),      
            .s00_axi_rresp      ( psolaf_vif.s00_axi_rresp_o ),      
            .s00_axi_rvalid     ( psolaf_vif.s00_axi_rvalid_o ),     
            .s00_axi_rready     ( psolaf_vif.s00_axi_rready_i ),

            .m00_axi_init_axi_txn   ( psolaf_vif.m00_axi_init_axi_txn_i ),
            .m00_axi_txn_done       ( psolaf_vif.m00_axi_txn_done_o ),
            .m00_axi_error          ( psolaf_vif.m00_axi_error_o ),
            .m00_axi_aclk           ( clk ),
            .m00_axi_aresetn        ( rst ),
            .m00_axi_awid           ( psolaf_vif.m00_axi_awid_o ),
            .m00_axi_awaddr         ( psolaf_vif.m00_axi_awaddr_o ),
            .m00_axi_awlen          ( psolaf_vif.m00_axi_awlen_o ),
            .m00_axi_awsize         ( psolaf_vif.m00_axi_awsize_o ),
            .m00_axi_awburst        ( psolaf_vif.m00_axi_awburst_o ),
            .m00_axi_awlock         ( psolaf_vif.m00_axi_awlock_o ),
            .m00_axi_awcache        ( psolaf_vif.m00_axi_awcache_o ),
            .m00_axi_awprot         ( psolaf_vif.m00_axi_awprot_o ),
            .m00_axi_awqos          ( psolaf_vif.m00_axi_awqos_o ),
            .m00_axi_awuser         ( psolaf_vif.m00_axi_awuser_o ),
            .m00_axi_awvalid        ( psolaf_vif.m00_axi_awvalid_o ),
            .m00_axi_awready        ( psolaf_vif.m00_axi_awready_i ),
            .m00_axi_wdata          ( psolaf_vif.m00_axi_wdata_o ),
            .m00_axi_wstrb          ( psolaf_vif.m00_axi_wstrb_o ),
            .m00_axi_wlast          ( psolaf_vif.m00_axi_wlast_o ),
            .m00_axi_wuser          ( psolaf_vif.m00_axi_wuser_o ),
            .m00_axi_wvalid         ( psolaf_vif.m00_axi_wvalid_o ),
            .m00_axi_wready         ( psolaf_vif.m00_axi_wready_i ),
            .m00_axi_bid            ( psolaf_vif.m00_axi_bid_i ),
            .m00_axi_bresp          ( psolaf_vif.m00_axi_bresp_i ),
            .m00_axi_buser          ( psolaf_vif.m00_axi_buser_i ),
            .m00_axi_bvalid         ( psolaf_vif.m00_axi_bvalid_i ),
            .m00_axi_bready         ( psolaf_vif.m00_axi_bready_o ),
            .m00_axi_arid           ( psolaf_vif.m00_axi_arid_o ),
            .m00_axi_araddr         ( psolaf_vif.m00_axi_araddr_o ),
            .m00_axi_arlen          ( psolaf_vif.m00_axi_arlen_o ),
            .m00_axi_arsize         ( psolaf_vif.m00_axi_arsize_o ),
            .m00_axi_arburst        ( psolaf_vif.m00_axi_arburst_o ),
            .m00_axi_arlock         ( psolaf_vif.m00_axi_arlock_o ),
            .m00_axi_arcache        ( psolaf_vif.m00_axi_arcache_o ),
            .m00_axi_arprot         ( psolaf_vif.m00_axi_arprot_o ),
            .m00_axi_arqos          ( psolaf_vif.m00_axi_arqos_o ),
            .m00_axi_aruser         ( psolaf_vif.m00_axi_aruser_o ),
            .m00_axi_arvalid        ( psolaf_vif.m00_axi_arvalid_o ),
            .m00_axi_arready        ( psolaf_vif.m00_axi_arready_i ),
            .m00_axi_rid            ( psolaf_vif.m00_axi_rid_i ),
            .m00_axi_rdata          ( psolaf_vif.m00_axi_rdata_i ),
            .m00_axi_rresp          ( psolaf_vif.m00_axi_rresp_i ),
            .m00_axi_rlast          ( psolaf_vif.m00_axi_rlast_i ),
            .m00_axi_ruser          ( psolaf_vif.m00_axi_ruser_i ),
            .m00_axi_rvalid         ( psolaf_vif.m00_axi_rvalid_i ),
            .m00_axi_rready         ( psolaf_vif.m00_axi_rready_o ),
            
            
            .state_tb_o             (psolaf_vif.m00_fsm_state ),
            .mst_state_tb_o         (psolaf_vif.m00_mst_state_o )
   ); 

   // bind psolaf_axi_v1_0 psolaf_vif (
   //          .state_next(psolaf_axi_v1_0.state_next)
   // );




   // run test
   initial begin      
      if ($value$plusargs("input_in=%s", input_in_top)) begin
         // input_in_m_seq = input_in_top;
         uvm_config_db#(string)::set(null, "*", "input_in_top", input_in_top);
         $display("Argument 1 input_in : %s", input_in_top);
      end else begin
         $display("Argument 1 input_in not provided");
      end

      if ($value$plusargs("input_m=%s", input_m_top)) begin
         uvm_config_db#(string)::set(null, "*", "input_m_top", input_m_top);
         $display("Argument 2 input_m : %s", input_m_top);
      end else begin
         $display("Argument 2 input_m not provided");
      end
      
      if ($value$plusargs("output_iniGr=%s", output_iniGr_top)) begin
         uvm_config_db#(string)::set(null, "*", "output_iniGr_top", output_iniGr_top);
         $display("Argument 3 output_iniGr_top : %s", output_iniGr_top);
      end else begin
         $display("Argument 3 output_iniGr_top not provided");
      end

      if ($value$plusargs("output_write_out=%s", output_write_out_top)) begin
         uvm_config_db#(string)::set(null, "*", "output_write_out_top", output_write_out_top);
         $display("Argument 4 output_write_out_top : %s", output_write_out_top);
      end else begin
         $display("Argument 4 output_write_out_top not provided");
      end

      if ($value$plusargs("output_read_out=%s", output_read_out_top)) begin
         uvm_config_db#(string)::set(null, "*", "output_read_out_top", output_read_out_top);
         $display("Argument 5 output_read_out_top : %s", output_read_out_top);
      end else begin
         $display("Argument 5 output_read_out_top not provided");
      end

      if ($value$plusargs("check_pit=%s", check_pit_top)) begin
         uvm_config_db#(string)::set(null, "*", "check_pit_top", check_pit_top);
         $display("Argument 6 check_pit_top : %s", check_pit_top);
      end else begin
         $display("Argument 6 check_pit_top not provided");
      end

      if ($value$plusargs("alpha=%f", alpha_top)) begin
         uvm_config_db#(real)::set(null, "*", "alpha_top", alpha_top);
         $display("Argument 6 alpha_top : %f", alpha_top);
      end else begin
         $display("Argument 6 alpha_top not provided");
      end

      if ($value$plusargs("beta=%f", beta_top)) begin
         uvm_config_db#(real)::set(null, "*", "beta_top", beta_top);
         $display("Argument 7 beta_top : %f", beta_top);
      end else begin
         $display("Argument 7 beta_top not provided");
      end

      if ($value$plusargs("gamma=%f", gamma_top)) begin
         uvm_config_db#(real)::set(null, "*", "gamma_top", gamma_top);
         $display("Argument 8 gamma_top : %f", gamma_top);
      end else begin
         $display("Argument 8 gamma_top not provided");
      end

      if ($value$plusargs("gamma_rec=%f", gamma_rec_top)) begin
         uvm_config_db#(real)::set(null, "*", "gamma_rec_top", gamma_rec_top);
         $display("Argument 11 gamma_rec_top : %f", gamma_rec_top);
      end else begin
         $display("Argument 11 gamma_rec_top not provided");
      end

      if ($value$plusargs("m_size=%d", m_size_top)) begin
         uvm_config_db#(int)::set(null, "*", "m_size_top", m_size_top);
         $display("Argument 9 m_size_top : %d", m_size_top);
      end else begin
         $display("Argument 9 m_size_top not provided");
      end

      if ($value$plusargs("in_size=%d", in_size_top)) begin
         uvm_config_db#(int)::set(null, "*", "in_size_top", in_size_top);
         $display("Argument 10 in_size_top : %d", in_size_top);
      end else begin
         $display("Argument 10 in_size_top not provided");
      end

      //uvm_config_db#(virtual psolaf_if)::set(null, "uvm_test_top.env", "psolaf_if", psolaf_vif);
      uvm_config_db#(virtual psolaf_if)::set(null, "*", "psolaf_if", psolaf_vif);
      //run_test();
      //run_test("test_simple_2");
      //`uvm_info(get_type_name(),"BEFORE RUN TEST_SIMPLE", UVM_LOW)
      `uvm_info("PSOLAF_VERIF_TOP","BEFORE RUN TEST_SIMPLE", UVM_LOW)
      run_test("test_simple");
   end

   // clock and reset init.
   initial begin
      clk <= 0;
      rst <= 0;
      #250 rst <= 1;
   end

   // clock generation
   always #50 clk = ~clk;

endmodule : psolaf_verif_top
