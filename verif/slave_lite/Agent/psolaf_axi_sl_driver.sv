`ifndef PSOLAF_AXI_SL_DRIVER_SV
 `define PSOLAF_AXI_SL_DRIVER_SV


class psolaf_axi_sl_driver extends uvm_driver#(psolaf_axi_sl_seq_item);

   `uvm_component_utils(psolaf_axi_sl_driver)
   
   virtual psolaf_if vif;
   
   function new(string name = "psolaf_axi_sl_driver", uvm_component parent = null);
      super.new(name,parent);
      if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
   endfunction : connect_phase



   extern virtual task reset();
   extern virtual task run_phase(uvm_phase phase);
   extern virtual task get_and_drive();
   extern virtual task drive_tr (psolaf_axi_sl_seq_item tr);
   extern virtual task read_han();
   extern virtual task han_comp();

   
   logic [C_S00_AXI_DATA_WIDTH - 1 : 0]   axi_read_place_en;
   logic [C_S00_AXI_DATA_WIDTH - 1 : 0]   axi_read_pit;
   bit start_psolaf;
   real  i_han,n_han = 0;
   real time_step;
   int i = 0;
   real han_val;
   const real dva_pi = 6.28318; 
   
endclass : psolaf_axi_sl_driver

//UVM run_phase
task psolaf_axi_sl_driver::run_phase(uvm_phase phase);
   int fd;

   $timeformat(-9,2,"ns",20);
   reset(); //init
   forever begin
      fork
         get_and_drive(); // thread killed at reset

      join_any
      $fdisplay(fd," pre disable fork %t",$time);
      $fdisplay(fd," disable fork; %t",$time);

   end

endtask : run_phase

// sequencer/driver handshake
task psolaf_axi_sl_driver::get_and_drive();
   int fd1;
   // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_get_and_drive.txt","a");

   $timeformat(-9,2,"ns",20);

      $fdisplay(fd1," pre get_next_item(req) %d",$time);
      seq_item_port.get_next_item(req);
      $fdisplay(fd1," posle get_next_item(req) %d",$time);

      drive_tr(req);
      
      $fdisplay(fd1," pre item_done %d",$time);
      seq_item_port.item_done();

      $fclose(fd1);
endtask : get_and_drive

// drive transaction
task psolaf_axi_sl_driver::drive_tr (psolaf_axi_sl_seq_item tr);

   int fd,fd1;
   // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_lite_read_17.txt","a");
   // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_lite_read_place_en.txt","a");   

   $timeformat(-9,2,"ns",20);

   if(tr.dir == AXIL_WRITE)begin
      vif.s00_axi_awaddr_i <= tr.s00_axi_awaddr_s;
      vif.s00_axi_awvalid_i <= tr.s00_axi_awvalid_s;
      vif.s00_axi_wdata_i <= tr.s00_axi_wdata_s;
      vif.s00_axi_wvalid_i <= tr.s00_axi_wvalid_s;
      vif.s00_axi_wstrb_i <= tr.s00_axi_wstrb_s;
      vif.s00_axi_bready_i <= tr.s00_axi_bready_s;

      wait(vif.s00_axi_awready_o == 1);
      wait(vif.s00_axi_awready_o == 0);
      $fdisplay(fd,"tr.s00_axi_awaddr_s nakon awready_o ************** %d",tr.s00_axi_awaddr_s,$time);
      if(tr.s00_axi_awaddr_s == GAMMA_REC_REG_ADDR_C)begin
         ///OVO NE ISPISUJE IYGLEDA DA NE ULAZI U IF
         $fdisplay(fd,"start_ev %d %t",start_ev,$time);
         ->start_ev;
      end
      vif.s00_axi_awaddr_i <= {C_S00_AXI_ADDR_WIDTH {1'b0}};
      vif.s00_axi_awvalid_i <= 1'b0;
      vif.s00_axi_wdata_i <= {C_S00_AXI_DATA_WIDTH {1'b0}};
      vif.s00_axi_wvalid_i <= 1'b0;
      vif.s00_axi_wstrb_i <= {(C_S00_AXI_DATA_WIDTH/8) {1'b0}};
      wait(vif.s00_axi_bvalid_o == 0);
      $fdisplay(fd,"nakon b_valid %t",$time);
      @(negedge vif.clk);
      vif.s00_axi_bready_i <= 0;
      @(negedge vif.clk);
   end

   $fdisplay(fd1,"pre AXI_READ ifa  %t",$time);

   if(tr.dir == AXIL_READ)begin
      $fdisplay(fd1,"AXI_READ u ifu ================================== %t",$time);
         
            $fdisplay(fd1,"u ifu han_val_ready = %d %t",han_val_ready,$time);
            vif.s00_axi_araddr_i <= tr.s00_axi_araddr_s;
            vif.s00_axi_arvalid_i <= tr.s00_axi_arvalid_s;
            vif.s00_axi_rready_i <= tr.s00_axi_rready_s;
            $fdisplay(fd1,"s00_axi_araddr_s = %d %t",tr.s00_axi_araddr_s,$time);
            wait(vif.s00_axi_arready_o == 1);
            wait(vif.s00_axi_arready_o == 0);
            vif.s00_axi_araddr_i <= {C_S00_AXI_ADDR_WIDTH {1'b0}};
            vif.s00_axi_arvalid_i <= 1'b0;
            
            //PLACE_EN_ADDR_C  = 32 
            if(tr.s00_axi_araddr_s == PLACE_EN_ADDR_C)begin
               @(posedge vif.clk iff vif.s00_axi_rvalid_o  == 1);
               axi_read_place_en = vif.s00_axi_rdata_o;
            end

            //PIT_REG_ADDR_C = 28;
            if(tr.s00_axi_araddr_s == PIT_REG_ADDR_C)begin
               @(posedge vif.clk iff vif.s00_axi_rvalid_o  == 1);
               axi_read_pit = vif.s00_axi_rdata_o;
               han_comp();
               //han_fin = 1;
            end

            //READY_REG_ADDR_C = 24; 
            if(tr.s00_axi_araddr_s == READY_REG_ADDR_C)begin
               @(posedge vif.clk iff vif.s00_axi_rvalid_o  == 1);
               ready_psolaf = vif.s00_axi_rdata_o;
            end

            //END_FLAG_ADDR_C = 40; 
            if(tr.s00_axi_araddr_s == END_FLAG_ADDR_C)begin
               @(posedge vif.clk iff vif.s00_axi_rvalid_o  == 1);
               end_flag_read = vif.s00_axi_rdata_o;
            end

            vif.s00_axi_rready_i <= 1'b0;
            @(negedge vif.clk);


            $fdisplay(fd1,"axi_read_place_en = %b %t",axi_read_place_en,$time);
            
            
            if(axi_read_place_en[0])begin

               $fdisplay(fd1,"pre tr.place_en = 1 %t",$time);
               $display("pre tr.place_en = 1 %t",$time);
               place_en_v = 1;
               calc_han_once = 0;

            end else begin
               place_en_v = 0;
            end 
            
         //end
   end
 
      
   $fdisplay(fd,"AXI Finished Driving tr %d",$time);
   $fclose(fd);
   $fclose(fd1);
endtask : drive_tr

task psolaf_axi_sl_driver::han_comp();
   int fd,fd1;
   // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_han.txt","a");
   // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_hanVal.txt","a");

   $timeformat(-9,2,"ns",20);
   i_han = 0;

   n_han = axi_read_pit * 2 + 1;

   $fdisplay(fd,"axi_read_pit = %d %t",axi_read_pit,$time);
   $fdisplay(fd,"n_han = %d %t",n_han,$time);

   time_step = (i_han+1)/(n_han+1);

   $fdisplay(fd,"time_step = %d %t",time_step,$time);
   
   for(int cnt = 0; cnt <= axi_read_pit; cnt++) begin
      han_val = 0.5 * (1 - $cos(dva_pi*time_step));

      $fdisplay(fd,"han_val = %2.15f %t",han_val,$time);

      i_han = i_han + 1;

      time_step = (i_han+1)/(n_han+1);

      $fdisplay(fd,"time_step = %7.8f %t",time_step,$time);
      


      if(han_val > 0.999999999)begin
         MEM_HAN[cnt] = $shortrealtobits(0.99999997);
         $fdisplay(fd,"MEM_HAN[%0d] = %b %t",cnt,$shortrealtobits(0.99999997),$time);
         $fdisplay(fd,"fp32MEM_HAN[%0d] = %b %t",cnt,fp32_to_fixed_han($shortrealtobits(0.99999997), 0),$time);
      end
      else
         MEM_HAN[cnt] = $shortrealtobits(han_val);
      
      
      $fdisplay(fd,"MEM_HAN[%0d] = %b %t",cnt,$shortrealtobits(han_val),$time);

      $fdisplay(fd,"fp32MEM_HAN[%0d] = %b %t",cnt,fp32_to_fixed_han($shortrealtobits(han_val), 0),$time);
      

   end;
   calc_han_once = 1;

   $fclose(fd);
endtask : han_comp

task psolaf_axi_sl_driver::read_han();

   if(han_val_ready == 0)begin

   end

endtask : read_han
// reset axi lite slave signals
task psolaf_axi_sl_driver::reset();
   `uvm_info(get_type_name(),"RESET OBSERVED", UVM_MEDIUM)
   vif.s00_axi_aresetn_i      <= 1'b0;
   vif.s00_axi_awaddr_i       <= {C_S00_AXI_ADDR_WIDTH {1'b0}};
   vif.s00_axi_awprot_i       <= 3'b0;
   vif.s00_axi_awvalid_i      <= 1'b0;
   vif.s00_axi_awready_o      <= 1'b0;
   vif.s00_axi_wdata_i        <= {C_S00_AXI_DATA_WIDTH {1'b0}};
   vif.s00_axi_wstrb_i        <= {(C_S00_AXI_DATA_WIDTH/8) {1'b0}};
   vif.s00_axi_wvalid_i       <= 1'b0;
   vif.s00_axi_wready_o       <= 1'b0;
   vif.s00_axi_bresp_o        <= 2'b0;
   vif.s00_axi_bvalid_o       <= 1'b0;
   vif.s00_axi_bready_i       <= 1'b0;
   vif.s00_axi_araddr_i       <= {C_S00_AXI_ADDR_WIDTH {1'b0}};
   vif.s00_axi_arprot_i       <= 3'b0;
   vif.s00_axi_arvalid_i      <= 1'b0;
   vif.s00_axi_arready_o      <= 1'b0;
   vif.s00_axi_rdata_o        <= {C_S00_AXI_DATA_WIDTH {1'b0}};
   vif.s00_axi_rresp_o        <= 2'b0;
   vif.s00_axi_rvalid_o       <= 1'b0;
   vif.s00_axi_rready_i       <= 1'b0;
   @(posedge vif.clk); //reset droped
   @(posedge vif.clk);
   @(posedge vif.clk);
   @(posedge vif.clk);
   @(posedge vif.clk);
endtask : reset
`endif

