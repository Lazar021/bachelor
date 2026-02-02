`ifndef PSOLAF_AXI_FULL_M_DRIVER_SV
 `define PSOLAF_AXI_FULL_M_DRIVER_SV



class psolaf_axi_full_m_driver extends uvm_driver#(psolaf_axi_full_m_seq_item);



   `uvm_component_utils(psolaf_axi_full_m_driver)
   
   virtual psolaf_if vif;
   
   function new(string name = "psolaf_axi_full_m_driver", uvm_component parent = null);
      super.new(name,parent);
      if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
   endfunction : connect_phase



   extern virtual task reset();
   extern virtual task reset_read();
   extern virtual task reset_write();
   extern virtual task run_phase(uvm_phase phase);
   extern virtual task get_and_drive();
   extern virtual task drive_tr (psolaf_axi_full_m_seq_item tr);
   // extern virtual task read_file(); 

   logic                                        axi_arv_arr_flag;
   logic                                        axi_awv_awr_flag;
   int                                          axi_arlen_cntr;
   int                                          axi_awlen_cntr;
   logic [C_M00_AXI_ADDR_WIDTH - 1 : 0]         axi_araddr;
   logic [C_M00_AXI_ADDR_WIDTH - 1 : 0]         axi_awaddr;
   int                                          MEM_IN[IN_SIZE];
   int                                          MEM_OUT[OUT_SIZE];

   logic [ADDR_LSB - 1 : 0]                              en_code;
   logic [C_M00_AXI_ADDR_WIDTH - $bits(en_code) - ADDR_LSB : 0]    mem_addr;
   
   logic [C_M00_AXI_ADDR_WIDTH - $bits(en_code) - ADDR_LSB : 0]    mem_addr_wr;
   logic [ADDR_LSB - 1 : 0]                              en_code_wr;
   logic                                         mem_wr,axi_wready;
   logic   en_w_m,en_w_opseg,en_w_out;

   logic en_m,en_opseg,en_hanning,en_out;
   event mem_addr_event,rdata_event;


endclass : psolaf_axi_full_m_driver

//UVM run_phase
task psolaf_axi_full_m_driver::run_phase(uvm_phase phase);
   $timeformat(-9,2,"ns",20);
   //reset(); //init
   reset_read();
   reset_write();
   @start_ev;
   forever begin
      fork
         get_and_drive(); // thread killed at reset
      join_any

   end

endtask : run_phase

// sequencer/driver handshake
task psolaf_axi_full_m_driver::get_and_drive();
   $timeformat(-9,2,"ns",20);

   seq_item_port.get(req);
   $display("Posle** seq_item_port.get(req); %t",$time);

   $display("PRE** drive_tr(req); %t",$time);
   drive_tr(req);

   $display("PRE** PUT request %t",$time);
   seq_item_port.put(req);
   $display("POSLE** PUT request %t",$time);

endtask : get_and_drive

// drive transaction
task psolaf_axi_full_m_driver::drive_tr (psolaf_axi_full_m_seq_item tr);
   
   $timeformat(-9,2,"ns",20);

   axi_arv_arr_flag = 0;


   case(tr.dir_full)
      AXIF_INIT: begin
         $display("AXIF_INIT %t",$time);
         vif.m00_axi_init_axi_txn_i <= tr.m00_axi_init_axi_txn_s;
         @(negedge vif.clk);
         @(negedge vif.clk);
      end
      AXIF_READ_ADDR : begin
         $display("AXIF_READ_ADDR 9_sep %t",$time);
         @(posedge vif.clk iff vif.m00_axi_arvalid_o  == 1);
         tr.m00_axi_araddr_s = vif.m00_axi_araddr_o;
         tr.m00_axi_arlen_s = vif.m00_axi_arlen_o;
         tr.m00_axi_arsize_s = vif.m00_axi_arsize_o;
         tr.m00_axi_arburst_s = vif.m00_axi_arburst_o;
         vif.m00_axi_init_axi_txn_i <= tr.m00_axi_init_axi_txn_s;
         vif.m00_axi_arready_i <= tr.m00_axi_arready_s;
         $display("posle iff** vif.m00_axi_arready_i 9_sep = %d %t",vif.m00_axi_arready_i,$time);
         @(posedge vif.clk);

      end
      AXIF_READ : begin
         $display("AXIF_READ 9_sep %t",$time);
         vif.m00_axi_arready_i <= tr.m00_axi_arready_s;
         vif.m00_axi_rdata_i <= tr.m00_axi_rdata_s;
         vif.m00_axi_rvalid_i <= tr.m00_axi_rvalid_s;
         vif.m00_axi_rlast_i <= tr.m00_axi_rlast_s;
         @(posedge vif.clk iff vif.m00_axi_rready_o == 1);
         if(tr.m00_axi_rlast_s == 1)begin
            reset_read();
         end
      end
      AXIF_READ_WRITE_OUT_ADDR : begin
         $display("AXIF_READ_WRITE_OUT_ADDR 9_sep %t",$time);
         fork
            begin
               $display("PRE** vif.m00_axi_arvalid_o 9_sep = %d %t",vif.m00_axi_arvalid_o,$time);
               @(posedge vif.clk iff vif.m00_axi_arvalid_o  == 1);
               $display("POSLE** vif.m00_axi_arvalid_o 9_sep = %d %t",vif.m00_axi_arvalid_o,$time);
               tr.m00_axi_araddr_s = vif.m00_axi_araddr_o;
               tr.m00_axi_arlen_s = vif.m00_axi_arlen_o;
               tr.m00_axi_arsize_s = vif.m00_axi_arsize_o;
               tr.m00_axi_arburst_s = vif.m00_axi_arburst_o;
               vif.m00_axi_init_axi_txn_i <= tr.m00_axi_init_axi_txn_s;
               $display("AXIF_READ_WRITE_OUT_ADDR vif.m00_axi_init_axi_txn_i 9_sep = %d %t",vif.m00_axi_init_axi_txn_i,$time);
               vif.m00_axi_arready_i <= tr.m00_axi_arready_s;
               $display("AXIF_READ_WRITE_OUT_ADDR pre posedge vif.m00_axi_arready_i 9_sep = %d %t",vif.m00_axi_arready_i,$time);
               @(posedge vif.clk);
               $display("AXIF_READ_WRITE_OUT_ADDR posedge vif.m00_axi_arready_i 9_sep = %d %t",vif.m00_axi_arready_i,$time);
               $display("AXIF_READ_WRITE_OUT_ADDR posedge vif.m00_axi_init_axi_txn_i 9_sep = %d %t",vif.m00_axi_init_axi_txn_i,$time);

            end   
            
            begin
               @(posedge vif.clk iff vif.m00_axi_awvalid_o  == 1);
               tr.m00_axi_awaddr_s = vif.m00_axi_awaddr_o;
               tr.m00_axi_awlen_s = vif.m00_axi_awlen_o;
               tr.m00_axi_awsize_s = vif.m00_axi_awsize_o;
               tr.m00_axi_awburst_s = vif.m00_axi_awburst_o;
               vif.m00_axi_awready_i <= tr.m00_axi_awready_s;
               $display("AXIF_READ_WRITE_OUT_ADDR vif.m00_axi_awaddr_o = %h %t",vif.m00_axi_awaddr_o,$time);
               $display("AXIF_READ_WRITE_OUT_ADDR vif.m00_axi_awready_i = %d %t",vif.m00_axi_awready_i,$time);
               $display("AXIF_READ_WRITE_OUT_ADDR tr.m00_axi_awready_s = %d %t",tr.m00_axi_awready_s,$time);
               @(posedge vif.clk);
               $display("AXIF_READ_WRITE_OUT_ADDR posedge vif.m00_axi_awready_i = %d %t",vif.m00_axi_awready_i,$time);
               $display("AXIF_READ_WRITE_OUT_ADDR posedge tr.m00_axi_awready_s = %d %t",tr.m00_axi_awready_s,$time);
            end  
            
         join
         $display("AXIF_READ_WRITE_OUT_ADDR posle join %t",$time);

      end
      AXIF_READ_WRITE_OUT : begin
         $display("AXIF_READ_WRITE_OUT %t",$time);
         fork
            begin 
               vif.m00_axi_arready_i <= tr.m00_axi_arready_s;
               vif.m00_axi_rdata_i <= tr.m00_axi_rdata_s;
               vif.m00_axi_rvalid_i <= tr.m00_axi_rvalid_s;
               vif.m00_axi_rlast_i <= tr.m00_axi_rlast_s;
               $display("vif.m00_axi_rready_o = %h %t",vif.m00_axi_rready_o,$time); 
               @(posedge vif.clk iff vif.m00_axi_rready_o == 1);
               $display("posle posedge vif.m00_axi_rready_o = %h %t",vif.m00_axi_rready_o,$time); 
               // @(negedge vif.clk iff vif.m00_axi_rready_o == 1);
               $display("posle negedge vif.m00_axi_rready_o = %h %t",vif.m00_axi_rready_o,$time); 
               if(tr.m00_axi_rlast_s == 1)begin
                  reset_read();
               end
            end

            //Write OUT
            begin 
               vif.m00_axi_awready_i <= tr.m00_axi_awready_s;
               $display("tr.m00_axi_awready_s = %h %t",tr.m00_axi_awready_s,$time); 
                $display("PRE vif.m00_axi_wvalid_o = %d %t",vif.m00_axi_wvalid_o,$time);
               // Kasnjenje izmenjeno na negedge 22. juna 2024
               @(posedge vif.clk iff vif.m00_axi_wvalid_o == 1);
               // @(negedge vif.clk iff vif.m00_axi_wvalid_o == 1);
                $display("POSLE vif.m00_axi_wvalid_o = %d %t",vif.m00_axi_wvalid_o,$time);
               vif.m00_axi_wready_i <= tr.m00_axi_wready_s; 
               // Kasnjenje dodato 22. juna 2024 probati ako ne radi sa neg edge wvalid
               // ostaviti posedge i dodati ovaj ispod negedge
               // @negedge vif.clk;
               //Izmena 18. jun 2024 
               tr.m00_axi_wdata_s = vif.m00_axi_wdata_o; 
               $display("vif.m00_axi_wdata_o = %h %t",vif.m00_axi_wdata_o,$time);  
               $display("tr.m00_axi_wdata_s = %h %t",tr.m00_axi_wdata_s,$time); 
               tr.m00_axi_wlast_s <= vif.m00_axi_wlast_o;   
               //Izmena 18. jun 2024 
               tr.m00_axi_wvalid_s <= vif.m00_axi_wvalid_o;
               if(vif.m00_axi_wlast_o == 1)begin
                  pit_compare = 0;
                  // $display("pit_compare = %d %t",pit_compare,$time);
                  $display("Drajver vif.m00_axi_wlast_o == 1");
                  // vif.m00_axi_wready_i  <= 1'b0;
                  // vif.m00_axi_bvalid_i  <= tr.m00_axi_bvalid_s;
                  @(posedge vif.clk);
                  vif.m00_axi_bvalid_i  <= tr.m00_axi_bvalid_s;
                  vif.m00_axi_wready_i  <= 1'b0;
                  @(posedge vif.clk iff vif.m00_axi_bready_o == 1);
                  reset();
               end
            end

         join
      end

      AXIF_READ_WRITE_OUT_SINGLE : begin
         $display("AXIF_READ_WRITE_OUT_SINGLE %t",$time);
         fork
            //read OUT
            begin 
               vif.m00_axi_arready_i <= tr.m00_axi_arready_s;
               vif.m00_axi_rdata_i <= tr.m00_axi_rdata_s;
               vif.m00_axi_rvalid_i <= tr.m00_axi_rvalid_s;
               vif.m00_axi_rlast_i <= tr.m00_axi_rlast_s;
               @(posedge vif.clk iff vif.m00_axi_rready_o == 1);
               if(tr.m00_axi_rlast_s == 1)begin
                  reset_read();
               end
            end

            //Write OUT
            begin 
               vif.m00_axi_awready_i <= tr.m00_axi_awready_s;
               $display("as tr.m00_axi_awready_s = %h %t",tr.m00_axi_awready_s,$time); 
               $display("PRE vif.m00_axi_wvalid_o = %d %t",vif.m00_axi_wvalid_o,$time);
               @(posedge vif.clk iff vif.m00_axi_wvalid_o == 1);
               $display("POSLE vif.m00_axi_wvalid_o = %d %t",vif.m00_axi_wvalid_o,$time);
               vif.m00_axi_wready_i <= tr.m00_axi_wready_s;
               tr.m00_axi_wdata_s <= vif.m00_axi_wdata_o; 
               $display("tr.m00_axi_wready_s = %h %t",tr.m00_axi_wready_s,$time); 
               @(negedge vif.clk);
               tr.m00_axi_wlast_s <= vif.m00_axi_wlast_o;  
               $display("posle dodele wlast = %d %t",vif.m00_axi_wlast_o,$time);     
               @(posedge vif.clk);
               $display("posle dodele tr.m00_axi_wlast_s = %d %t",tr.m00_axi_wlast_s,$time);     
               if(tr.m00_axi_wlast_s == 1)begin
                  $display("U if-u vif.m00_axi_wlast_o = %d %t",vif.m00_axi_wlast_o,$time);  
                  vif.m00_axi_wready_i  <= 1'b0;
                  vif.m00_axi_bvalid_i  <= tr.m00_axi_bvalid_s;
                  @(posedge vif.clk);
                  $display("U if-u vif.m00_axi_bvalid_i = %d %t",vif.m00_axi_bvalid_i,$time);
                  @(posedge vif.clk iff vif.m00_axi_bready_o == 1);
                  $display("U if-u vif.m00_axi_bready_o = %d %t",vif.m00_axi_bready_o,$time);
                  reset();
               end
            end

         join
      end

      AXIF_READ_WRITE_ADDR_SETUP : begin
         $display("AXIF_READ_WRITE_ADDR_SETUP %t",$time);
         fork
            //read OUT
            begin 
               
               $display("vif.m00_axi_rvalid_i 9_sep = %d %t",vif.m00_axi_rvalid_i,$time);
               $display("vif.m00_axi_rready_o 9_sep = %d %t",vif.m00_axi_rready_o,$time);
               $display("vif.m00_axi_rlast_i 9_sep = %d %t",vif.m00_axi_rlast_i,$time);
               vif.m00_axi_arready_i <= tr.m00_axi_arready_s;
               vif.m00_axi_rdata_i <= tr.m00_axi_rdata_s;
               vif.m00_axi_rvalid_i <= tr.m00_axi_rvalid_s;
               vif.m00_axi_rlast_i <= tr.m00_axi_rlast_s;
               @(posedge vif.clk iff vif.m00_axi_rready_o == 1);
               if(tr.m00_axi_rlast_s == 1)begin
                  reset_read();
               end
            end

            //Write OUT
            begin 
               vif.m00_axi_awready_i <= tr.m00_axi_awready_s;
               $display("vif.m00_axi_awready_i 9_sep = %d %t",vif.m00_axi_awready_i,$time);
               $display("tr.m00_axi_awready_s 9_sep = %d %t",tr.m00_axi_awready_s,$time);
                $display("PRE vif.m00_axi_wvalid_o 9_sep = %d %t",vif.m00_axi_wvalid_o,$time);
               @(posedge vif.clk iff vif.m00_axi_wvalid_o == 1);
                $display("POSLE vif.m00_axi_wvalid_o 9_sep = %d %t",vif.m00_axi_wvalid_o,$time);
               vif.m00_axi_wready_i <= tr.m00_axi_wready_s;
               $display("tr.m00_axi_wready_s 9_sep = %d %t",tr.m00_axi_wready_s,$time);
               //Izmena 18. jun 2024 
               tr.m00_axi_wdata_s = vif.m00_axi_wdata_o; 
               $display("vif.m00_axi_wdata_o 9_sep = %h %t",vif.m00_axi_wdata_o,$time);  
               $display("tr.m00_axi_wdata_s 9_sep = %h %t",tr.m00_axi_wdata_s,$time); 
               tr.m00_axi_wlast_s <= vif.m00_axi_wlast_o;  
               $display("vif.m00_axi_wlast_o 9_sep = %h %t",vif.m00_axi_wlast_o,$time);  
               //Izmena 18. jun 2024 
               tr.m00_axi_wvalid_s <= vif.m00_axi_wvalid_o;
               $display("vif.m00_axi_wvalid_o 9_sep = %h %t",vif.m00_axi_wvalid_o,$time); 
               $display("tr.m00_axi_wdata_s 9_sep = %h %t",tr.m00_axi_wdata_s,$time); 
               if(vif.m00_axi_wlast_o == 1)begin
                  vif.m00_axi_wready_i  <= 1'b0;
                  $display("unutar wlast tr.m00_axi_wready_s 9_sep = %d %t",tr.m00_axi_wready_s,$time);

                  vif.m00_axi_bvalid_i  <= tr.m00_axi_bvalid_s;
                  @(posedge vif.clk);
                  @(posedge vif.clk iff vif.m00_axi_bready_o == 1);
                  reset();
               end
            end

         join
      end
      default: begin
         vif.m00_axi_init_axi_txn_i <= tr.m00_axi_init_axi_txn_s;
      end
   endcase

endtask : drive_tr


// reset axi full master read signals
task psolaf_axi_full_m_driver::reset_read();
   `uvm_info(get_type_name(),"RESET OBSERVED", UVM_MEDIUM)
   vif.m00_axi_init_axi_txn_i      <= 1'b0;
   vif.m00_axi_txn_done_o        <= 1'b0;
   vif.m00_axi_error_o           <= 1'b0;
   //vif.m00_axi_aresetn_i         <= 1'b0;
   // vif.m00_axi_awid_o            <= {C_M00_AXI_ID_WIDTH {1'b0}};
   // //vif.m00_axi_awaddr_o          <= {C_M00_AXI_ADDR_WIDTH {1'b0}};
   // vif.m00_axi_awlen_o           <= {W_HIGH_M_TOP {1'b0}};
   // vif.m00_axi_awsize_o          <= 3'b0;
   // vif.m00_axi_awburst_o         <= 2'b0;
   // vif.m00_axi_awlock_o          <= 1'b0;
   // vif.m00_axi_awcache_o         <= 4'b0;
   // vif.m00_axi_awprot_o          <= 3'b0;
   // vif.m00_axi_awqos_o           <= 4'b0;
   // vif.m00_axi_awuser_o          <= {C_M00_AXI_AWUSER_WIDTH {1'b0}};
   // vif.m00_axi_awvalid_o         <= 1'b0;
   // vif.m00_axi_awready_i         <= 1'b0;
   // vif.m00_axi_wdata_o           <= {C_M00_AXI_DATA_WIDTH {1'b0}};
   // vif.m00_axi_wstrb_o           <= {C_M00_AXI_DATA_WIDTH/8  {1'b0}};
   // vif.m00_axi_wlast_o           <= 1'b0;
   // vif.m00_axi_wuser_o           <= {C_M00_AXI_WUSER_WIDTH {1'b0}};
   // vif.m00_axi_wvalid_o          <= 1'b0;
   // vif.m00_axi_wready_i          <= 1'b0;
   // vif.m00_axi_bid_i             <= {C_M00_AXI_ID_WIDTH {1'b0}};
   // vif.m00_axi_bresp_i           <= 3'b0;
   // vif.m00_axi_buser_i           <= {C_M00_AXI_BUSER_WIDTH {1'b0}};
   // vif.m00_axi_bvalid_i          <= 1'b0;
   // vif.m00_axi_bready_o          <= 1'b0;
   //vif.m00_axi_arid_o            <= {C_M00_AXI_ID_WIDTH {1'b0}};
   //vif.m00_axi_araddr_o          <= {C_M00_AXI_ADDR_WIDTH {1'b0}};
   //vif.m00_axi_arlen_o           <= {W_HIGH_M_TOP {1'b0}};
   //vif.m00_axi_arsize_o          <= 3'b0;
   //vif.m00_axi_arburst_o         <= 2'b0;
   vif.m00_axi_arlock_o          <= 1'b0;
   vif.m00_axi_arcache_o         <= 4'b0;
   vif.m00_axi_arprot_o          <= 3'b0;
   vif.m00_axi_arqos_o           <= 4'b0;
   vif.m00_axi_aruser_o          <= {C_M00_AXI_ARUSER_WIDTH {1'b0}};
   vif.m00_axi_arvalid_o         <= 1'b0;
   vif.m00_axi_arready_i         <= 1'b0;
   vif.m00_axi_rid_i             <= {C_M00_AXI_ID_WIDTH {1'b0}};
   vif.m00_axi_rdata_i           <= {C_M00_AXI_DATA_WIDTH {1'b0}};
   vif.m00_axi_rresp_i           <= 2'b0;
   vif.m00_axi_rlast_i           <= 1'b0;
   vif.m00_axi_ruser_i           <= {C_M00_AXI_RUSER_WIDTH {1'b0}};
   vif.m00_axi_rvalid_i          <= 1'b0;
   vif.m00_axi_rready_o          <= 1'b0;
   $display("driver tr pre reset dropa");
   //@(posedge vif.rst); //reset droped
   @(posedge vif.clk); //reset droped
   //@(posedge vif.clk);
   //@(posedge vif.clk);
   //@(posedge vif.clk);
   //@(posedge vif.clk);
    $display("driver tr posle reset dropa");
endtask : reset_read

// reset axi full master write signals
task psolaf_axi_full_m_driver::reset_write();
   `uvm_info(get_type_name(),"RESET OBSERVED", UVM_MEDIUM)
   vif.m00_axi_init_axi_txn_i      <= 1'b0;
   vif.m00_axi_txn_done_o        <= 1'b0;
   vif.m00_axi_error_o           <= 1'b0;
   //vif.m00_axi_aresetn_i         <= 1'b0;
   vif.m00_axi_awid_o            <= {C_M00_AXI_ID_WIDTH {1'b0}};
   //vif.m00_axi_awaddr_o          <= {C_M00_AXI_ADDR_WIDTH {1'b0}};
   //vif.m00_axi_awlen_o           <= {W_HIGH_M_TOP {1'b0}};
   //vif.m00_axi_awsize_o          <= 3'b0;
   //vif.m00_axi_awburst_o         <= 2'b0;
   vif.m00_axi_awlock_o          <= 1'b0;
   vif.m00_axi_awcache_o         <= 4'b0;
   vif.m00_axi_awprot_o          <= 3'b0;
   vif.m00_axi_awqos_o           <= 4'b0;
   vif.m00_axi_awuser_o          <= {C_M00_AXI_AWUSER_WIDTH {1'b0}};
   vif.m00_axi_awvalid_o         <= 1'b0;
   vif.m00_axi_awready_i         <= 1'b0;
   vif.m00_axi_wdata_o           <= {C_M00_AXI_DATA_WIDTH {1'b0}};
   vif.m00_axi_wstrb_o           <= {C_M00_AXI_DATA_WIDTH/8  {1'b0}};
   vif.m00_axi_wlast_o           <= 1'b0;
   vif.m00_axi_wuser_o           <= {C_M00_AXI_WUSER_WIDTH {1'b0}};
   vif.m00_axi_wvalid_o          <= 1'b0;
   vif.m00_axi_wready_i          <= 1'b0;
   vif.m00_axi_bid_i             <= {C_M00_AXI_ID_WIDTH {1'b0}};
   vif.m00_axi_bresp_i           <= 3'b0;
   vif.m00_axi_buser_i           <= {C_M00_AXI_BUSER_WIDTH {1'b0}};
   vif.m00_axi_bvalid_i          <= 1'b0;
   vif.m00_axi_bready_o          <= 1'b0;
   // vif.m00_axi_arid_o            <= {C_M00_AXI_ID_WIDTH {1'b0}};
   // //vif.m00_axi_araddr_o          <= {C_M00_AXI_ADDR_WIDTH {1'b0}};
   // vif.m00_axi_arlen_o           <= {W_HIGH_M_TOP {1'b0}};
   // //vif.m00_axi_arsize_o          <= 3'b0;
   // //vif.m00_axi_arburst_o         <= 2'b0;
   // vif.m00_axi_arlock_o          <= 1'b0;
   // vif.m00_axi_arcache_o         <= 4'b0;
   // vif.m00_axi_arprot_o          <= 3'b0;
   // vif.m00_axi_arqos_o           <= 4'b0;
   // vif.m00_axi_aruser_o          <= {C_M00_AXI_ARUSER_WIDTH {1'b0}};
   // vif.m00_axi_arvalid_o         <= 1'b0;
   // vif.m00_axi_arready_i         <= 1'b0;
   // vif.m00_axi_rid_i             <= {C_M00_AXI_ID_WIDTH {1'b0}};
   // vif.m00_axi_rdata_i           <= {C_M00_AXI_DATA_WIDTH {1'b0}};
   // vif.m00_axi_rresp_i           <= 2'b0;
   // vif.m00_axi_rlast_i           <= 1'b0;
   // vif.m00_axi_ruser_i           <= {C_M00_AXI_RUSER_WIDTH {1'b0}};
   // vif.m00_axi_rvalid_i          <= 1'b0;
   // vif.m00_axi_rready_o          <= 1'b0;
   $display("driver tr pre reset dropa");
   //@(posedge vif.rst); //reset droped
   @(posedge vif.clk); //reset droped
   //@(posedge vif.clk);
   //@(posedge vif.clk);
   //@(posedge vif.clk);
   //@(posedge vif.clk);
    $display("driver tr posle reset dropa");
endtask : reset_write

// reset axi full master write signals
task psolaf_axi_full_m_driver::reset();
   `uvm_info(get_type_name(),"RESET OBSERVED", UVM_MEDIUM)
   vif.m00_axi_init_axi_txn_i      <= 1'b0;
   vif.m00_axi_txn_done_o        <= 1'b0;
   vif.m00_axi_error_o           <= 1'b0;
   //vif.m00_axi_aresetn_i         <= 1'b0;
   vif.m00_axi_awid_o            <= {C_M00_AXI_ID_WIDTH {1'b0}};
   //vif.m00_axi_awaddr_o          <= {C_M00_AXI_ADDR_WIDTH {1'b0}};
   //vif.m00_axi_awlen_o           <= {W_HIGH_M_TOP {1'b0}};
   //vif.m00_axi_awsize_o          <= 3'b0;
   //vif.m00_axi_awburst_o         <= 2'b0;
   vif.m00_axi_awlock_o          <= 1'b0;
   //vif.m00_axi_awcache_o         <= 4'b0;
   vif.m00_axi_awprot_o          <= 3'b0;
   vif.m00_axi_awqos_o           <= 4'b0;
   //vif.m00_axi_awuser_o          <= {C_M00_AXI_AWUSER_WIDTH {1'b0}};
   vif.m00_axi_awvalid_o         <= 1'b0;
   vif.m00_axi_awready_i         <= 1'b0;
   vif.m00_axi_wdata_o           <= {C_M00_AXI_DATA_WIDTH {1'b0}};
   // vif.m00_axi_wstrb_o           <= {C_M00_AXI_DATA_WIDTH/8  {1'b0}};
   vif.m00_axi_wlast_o           <= 1'b0;
   vif.m00_axi_wuser_o           <= {C_M00_AXI_WUSER_WIDTH {1'b0}};
   vif.m00_axi_wvalid_o          <= 1'b0;
   vif.m00_axi_wready_i          <= 1'b0;
   vif.m00_axi_bid_i             <= {C_M00_AXI_ID_WIDTH {1'b0}};
   vif.m00_axi_bresp_i           <= 3'b0;
   vif.m00_axi_buser_i           <= {C_M00_AXI_BUSER_WIDTH {1'b0}};
   vif.m00_axi_bvalid_i          <= 1'b0;
   vif.m00_axi_bready_o          <= 1'b0;
   vif.m00_axi_arid_o            <= {C_M00_AXI_ID_WIDTH {1'b0}};
   //vif.m00_axi_araddr_o          <= {C_M00_AXI_ADDR_WIDTH {1'b0}};
   vif.m00_axi_arlen_o           <= {W_HIGH_M_TOP {1'b0}};
   //vif.m00_axi_arsize_o          <= 3'b0;
   //vif.m00_axi_arburst_o         <= 2'b0;
   vif.m00_axi_arlock_o          <= 1'b0;
   vif.m00_axi_arcache_o         <= 4'b0;
   vif.m00_axi_arprot_o          <= 3'b0;
   vif.m00_axi_arqos_o           <= 4'b0;
   vif.m00_axi_aruser_o          <= {C_M00_AXI_ARUSER_WIDTH {1'b0}};
   vif.m00_axi_arvalid_o         <= 1'b0;
   vif.m00_axi_arready_i         <= 1'b0;
   vif.m00_axi_rid_i             <= {C_M00_AXI_ID_WIDTH {1'b0}};
   vif.m00_axi_rdata_i           <= {C_M00_AXI_DATA_WIDTH {1'b0}};
   vif.m00_axi_rresp_i           <= 2'b0;
   vif.m00_axi_rlast_i           <= 1'b0;
   vif.m00_axi_ruser_i           <= {C_M00_AXI_RUSER_WIDTH {1'b0}};
   vif.m00_axi_rvalid_i          <= 1'b0;
   vif.m00_axi_rready_o          <= 1'b0;
   $display("driver tr pre reset dropa");
   //@(posedge vif.rst); //reset droped
   @(posedge vif.clk); //reset droped
   //@(posedge vif.clk);
   //@(posedge vif.clk);
   //@(posedge vif.clk);
   //@(posedge vif.clk);
    $display("driver tr posle reset dropa");
endtask : reset

`endif

