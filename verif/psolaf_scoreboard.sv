`ifndef PSOLAF_SCOREBOARD_SV
 `define PSOLAF_SCOREBOARD_SV

`uvm_analysis_imp_decl(_full)
`uvm_analysis_imp_decl(_lite)
class psolaf_scoreboard extends uvm_scoreboard;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   int do_compare = 0;

   // command-line arguments
   string output_iniGr_arg3;
   string output_write_out_arg4;
   string output_read_out_arg5;
   string pit_arg6;

   // This TLM port is used to connect the scoreboard to the monitor
   uvm_analysis_imp_full#(psolaf_axi_full_m_seq_item, psolaf_scoreboard) item_collected_imp_full;

   uvm_analysis_imp_lite#(psolaf_axi_sl_seq_item, psolaf_scoreboard) item_collected_imp_lite;

   int num_of_tr;
   int br_poziva;
   event br_poziva_ev;
   int br_poziva_write_pit;

   //protected psolaf_axi_full_m_seq_item gold_before[$];
   psolaf_axi_full_m_seq_item gold_before[$];
   psolaf_axi_sl_seq_item gold_lite_arr[$];
   
   extern virtual task read_mem_out( psolaf_axi_full_m_seq_item tr_gold);
   extern virtual task read_pit(psolaf_axi_sl_seq_item tr_gold); 

   //extern virtual task read_mem_out();

   `uvm_component_utils_begin(psolaf_scoreboard)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
      `uvm_field_string(output_iniGr_arg3, UVM_DEFAULT)
      `uvm_field_string(output_write_out_arg4, UVM_DEFAULT)
      `uvm_field_string(output_read_out_arg5, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "psolaf_scoreboard", uvm_component parent = null);
      super.new(name,parent);
      item_collected_imp_full = new("item_collected_imp_full", this);
      item_collected_imp_lite = new("item_collected_imp_lite", this);
   endfunction : new



   // function write (psolaf_axi_full_m_seq_item tr);
   function write_full (psolaf_axi_full_m_seq_item tr);
  
      psolaf_axi_full_m_seq_item tr_clone;
      psolaf_axi_full_m_seq_item tr_gold_before;
      int w_data_diff;
      logic  [C_M00_AXI_ADDR_WIDTH - 1 : 0] tr_addr_tmp;
      //tr_clone = psolaf_axi_full_m_seq_item::type_id::create("tr_clone");
      br_poziva++;
      //->br_poziva_ev;
      `uvm_info(get_type_name(),$sformatf("gold_before.size() = %d",gold_before.size()), UVM_LOW);
      tr_gold_before = gold_before.pop_front();

      $cast(tr_clone, tr.clone());

      if(checks_enable) begin    
            //POGELDAJ pored adresa duzinu za citanje je u jednoj transakciji 83 a u drugoj 0
         `uvm_info(get_type_name(),$sformatf("checks_enable = %d br_poziva = %d psolaf_scoreboard============ ",checks_enable,br_poziva), UVM_LOW);
         //tr_addr_tmp = tr_clone.m00_axi_araddr_s & 32'hC0000000;
         //if(tr_addr_tmp == 32'hC0000000)begin 
         //   `uvm_info(get_type_name(),$sformatf("read adresa pocinje sa C = %h ++++++++++++   ++++++++++++++",tr_clone.m00_axi_araddr_s), UVM_LOW);
         `uvm_info(get_type_name(),$sformatf("tr_clone.m00_axi_arlen_s = %d",tr_clone.m00_axi_arlen_s), UVM_LOW);

         `uvm_info(get_type_name(),$sformatf("tr_gold_before.m00_axi_arlen_s = %d",tr_gold_before.m00_axi_arlen_s), UVM_LOW);
         `uvm_info(get_type_name(),$sformatf("Posle tr_gold_before.m00_axi_arlen_s =",), UVM_LOW);
         

         
         if(tr_clone.m00_axi_arlen_s == 0)begin
            `uvm_info(get_type_name(),$sformatf("arlen = %h ++++++++++++   ++++++++++++++",tr_clone.m00_axi_arlen_s), UVM_LOW);
         end
         else
         begin

            if(!tr_gold_before.compare(tr_clone))begin
               //`uvm_error("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_before.convert2string(),tr_clone.convert2string()));
               `uvm_info(get_type_name(),$sformatf("gold_before_size = %d ++++++++++++++++++++++++++",gold_before.size()), UVM_LOW);
               //`uvm_error("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_before.sprint(),tr_clone.sprint()));
               if(tr_gold_before.m00_axi_awaddr_s != tr_clone.m00_axi_awaddr_s )begin
                  `uvm_fatal("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_before.sprint(),tr_clone.sprint()));
               end
               if(tr_gold_before.m00_axi_araddr_s != tr_clone.m00_axi_araddr_s )begin
                  `uvm_fatal("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_before.sprint(),tr_clone.sprint()));
               end

               //w_data_diff = abs(tr_gold_before.m00_axi_wdata_s - tr_clone.m00_axi_wdata_s);
               w_data_diff = (tr_gold_before.m00_axi_wdata_s > tr_clone.m00_axi_wdata_s) ? (tr_gold_before.m00_axi_wdata_s - tr_clone.m00_axi_wdata_s) : (tr_clone.m00_axi_wdata_s - tr_gold_before.m00_axi_wdata_s);
               `uvm_info(get_type_name(),$sformatf("w_data_diff = %d ++++++++++++++++++++++++++",w_data_diff), UVM_LOW);
               //if(w_data_diff > 300)begin
               // if(w_data_diff > 1500)begin
               // if(w_data_diff > 3000)begin
               // if(w_data_diff > 5000)begin
               if(w_data_diff > 10000)begin
                  `uvm_fatal("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_before.sprint(),tr_clone.sprint()));
               end
            end   
         end      
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_full

   // function write(psolaf_axi_sl_seq_item tr);
   function write_lite(psolaf_axi_sl_seq_item tr);
      psolaf_axi_sl_seq_item  tr_clone_lite;
      psolaf_axi_sl_seq_item  tr_gold_slave;

      $timeformat(-9,2,"ns",20);
      if(tr.s00_axi_araddr_s == 28 && pit_compare == 0)begin
         $display("tr.s00_axi_araddr_s %d",tr.s00_axi_araddr_s);
         
         do_compare = 1;
         $display("do_compare %d %t",do_compare,$time);
      end
      else
      begin
         $cast(tr_clone_lite, tr.clone());
         
         if(checks_enable) begin
            // $display("pit_compare %d",pit_compare);
            // $display("do_compare %d",do_compare);
            if(pit_compare == 0 && do_compare == 1)begin
               tr_gold_slave = gold_lite_arr.pop_front();
               // $display("gold_lite_arr.size() %d",gold_lite_arr.size());

               $display("pit gold %s",tr_gold_slave.sprint());
               br_poziva_write_pit++;
               // $display("br_poziva_write_pit %d",br_poziva_write_pit);


               if(!tr_gold_slave.compare(tr_clone_lite))begin
                  //`uvm_error("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_before.convert2string(),tr_clone_lite.convert2string()));
                  `uvm_info(get_type_name(),$sformatf("gold_before_size = %d ++++++++++++++++++++++++++",gold_lite_arr.size()), UVM_LOW);
                  `uvm_info(get_type_name(),$sformatf("compararisson faild but rdata is same %s does not match %s",tr_gold_slave.sprint(),tr_clone_lite.sprint()), UVM_LOW);

                  if(tr_gold_slave.s00_axi_rdata_s != tr_clone_lite.s00_axi_rdata_s)begin
                     $display("time = %t",$time);
                     `uvm_fatal("scoreboard mismatch",$sformatf("%s does not match %s",tr_gold_slave.sprint(),tr_clone_lite.sprint()));
                  end
               end else begin
                  $display("tr_gold_slave == tr_clone_lite %d %t",tr_gold_slave.compare(tr_clone_lite),$time);
               end

               do_compare = 0;
               pit_compare = 1;
            end
         end
         
      end
   endfunction : write_lite

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      /************Geting from configuration database*******************/
      //arg 3
      if (!uvm_config_db#(string)::get(this, "", "output_iniGr_top", output_iniGr_arg3))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument output_iniGr_top must be set:",get_full_name(),".arg"})
      //arg 4
      if (!uvm_config_db#(string)::get(this, "", "output_write_out_top", output_write_out_arg4))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument output_write_out_top must be set:",get_full_name(),".arg"})
      //arg 5
      if (!uvm_config_db#(string)::get(this, "", "output_read_out_top", output_read_out_arg5))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument output_read_out_top must be set:",get_full_name(),".arg"})
      //arg 6
      if (!uvm_config_db#(string)::get(this, "", "check_pit_top", pit_arg6))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument check_pit_top must be set:",get_full_name(),".arg"})
      
      $display("psolaf_axi_sl_env output_iniGr_arg3 : %s", output_iniGr_arg3);
      $display("psolaf_axi_sl_env output_write_out_arg4 : %s", output_write_out_arg4);
      $display("psolaf_axi_sl_env output_read_out_arg5 : %s", output_read_out_arg5);
      $display("psolaf_axi_sl_env pit_arg6 : %s", pit_arg6);
   endfunction : build_phase


   task main_phase(uvm_phase phase);
      //TEST 11.mart 2024
      psolaf_axi_full_m_seq_item tr_gold;
      psolaf_axi_sl_seq_item tr_gold_lite;
      tr_gold = psolaf_axi_full_m_seq_item::type_id::create("tr_gold");
      tr_gold_lite = psolaf_axi_sl_seq_item::type_id::create("tr_gold_lite");
      read_mem_out(tr_gold);
      read_pit(tr_gold_lite);
      //read_mem_out();
   endtask : main_phase



   function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("Calc scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
   endfunction : report_phase

endclass : psolaf_scoreboard



task psolaf_scoreboard::read_mem_out(psolaf_axi_full_m_seq_item tr_gold); 
//task psolaf_scoreboard::read_mem_out(); 
      int fd,fd1,fd2,fd3,fd4,fd5,fd6,fd7,fd8;
      int val,ini_k,iniGr_val,endGr_val;
      int data_available_write;
      int data_available;
      int init_flag;
      //int axi_araddr_incr;
      int adr,tmp,adr_read;
      real val_out,val_read_out;
      string str,ini_s;
      
      parameter C_TRANSACTIONS_NUM = $clog2(C_M00_AXI_BURST_LEN-1);

      logic  [C_M00_AXI_ADDR_WIDTH - 3 : 0]   m00_axi_awaddr_tmp,m00_axi_araddr_tmp;
      //logic  [C_TRANSACTIONS_NUM - 1 : 0]   axi_araddr_incr;
      logic  [C_M00_AXI_ADDR_WIDTH - 1 : 0]   axi_araddr_incr,axi_awaddr_incr;
      int   m00_axi_awaddr_int,m00_axi_araddr_int;
      int cnt = 0;

      

      int i = 0;
      // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debugOutTrCheck.txt","w");
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debugOutSvakiProlazYo2.txt","r");
      // fd2 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debugIniGrYo2.txt","r");
      // fd3 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debugOutReadSvakiProlazYo2.txt","r");
      // fd4 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_addr_scbd.txt","a");
      // fd5 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_tr_gold_scbd.txt","a");
      // fd6 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_awaddr_scbd.txt","a");
      // fd7 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_tr_gold_scbd_enddd.txt","a");
      // fd7 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_data_avalible_write.txt","a");

      // reading from a filet which name is in argument
      $display("scoreboard psolaf_axi_sl_env output_iniGr_arg3 : %s", output_iniGr_arg3);
      $display("scoreboard psolaf_axi_sl_env output_write_out_arg4 : %s", output_write_out_arg4);
      $display("scoreboard psolaf_axi_sl_env output_read_out_arg5 : %s", output_read_out_arg5);
      
      $display("scoreboard psolaf_axi_sl_env pit_arg6 : %s", pit_arg6);
      
      // fd2 = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/",output_iniGr_arg3,".txt"},"r");
      // fd = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/",output_write_out_arg4,".txt"},"r");
      // fd3 = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/",output_read_out_arg5,".txt"},"r");
      
      
      // fd2 = $fopen({"../../../../../debug_txt/",output_iniGr_arg3,".txt"},"r");
      // fd = $fopen({"../../../../../debug_txt/",output_write_out_arg4,".txt"},"r");
      // fd3 = $fopen({"../../../../../debug_txt/",output_read_out_arg5,".txt"},"r");
    
      fd2 = $fopen({"../../../../../../esl/verif/golden_vector_source/",output_iniGr_arg3,".txt"},"r");
      fd = $fopen({"../../../../../../esl/verif/golden_vector_source/",output_write_out_arg4,".txt"},"r");
      fd3 = $fopen({"../../../../../../esl/verif/golden_vector_source/",output_read_out_arg5,".txt"},"r");
      
      //   /media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/test_psolaf
         if(fd)
            $display("debugIniGrYo2 file was open successfully %0d =====================================================",fd);
         else
            $display("debugIniGrYo2 file was NOT open successfully %0d =====================================================",fd);
      


         if(fd4)
            $display("debug_addr_scbd file was open successfully %0d =====================================================",fd4);
         else
            $display("debug_addr_scbd file was NOT open successfully %0d =====================================================",fd4);
      

      while($fscanf(fd2,"%s = %d",ini_s,iniGr_val) == 2) begin

         psolaf_axi_full_m_seq_item tr_gold_clone;
         // Create a new object using the constructor
         tr_gold_clone = psolaf_axi_full_m_seq_item::type_id::create("tr_gold_clone", this);


         // Check if the object creation was successful
         if (tr_gold_clone != null) begin
            // Perform a deep copy of tr_gold to tr_clone
            $cast(tr_gold_clone, tr_gold.clone());

         end else begin
            // Handle error or debug
            $display("Error: Unable to allocate memory for tr_gold_clone");
         end

         $fdisplay(fd4,"iniGr_val = ",iniGr_val);



         if($fscanf(fd2,"%s = %d",ini_s,endGr_val) == 2)begin

                $fdisplay(fd4,"endGr_val = ",endGr_val);
            // end
         end 
         else
         begin
            `uvm_info(get_type_name(),$sformatf("citanje endGr zavrseno nema vise elemenata u fajlu IniGr"), UVM_LOW);
         end


         
         tr_gold_clone.dir_full = AXIF_INIT;
         tr_gold_clone.m00_axi_init_axi_txn_s = 0;
         tr_gold_clone.m00_axi_txn_done_s = 0;
         tr_gold_clone.m00_axi_error_s = 0;
         tr_gold_clone.m00_axi_awid_s = 0;
         tr_gold_clone.m00_axi_awsize_s = 3'b010;
         tr_gold_clone.m00_axi_awburst_s = 2'b01;
         tr_gold_clone.m00_axi_awlock_s = 0;
         tr_gold_clone.m00_axi_awcache_s = 4'b0000;
         tr_gold_clone.m00_axi_awprot_s = 3'b000;
         tr_gold_clone.m00_axi_awqos_s = 4'b0000;
         tr_gold_clone.m00_axi_awuser_s = 2'b00;
         tr_gold_clone.m00_axi_awvalid_s = 0;
         tr_gold_clone.m00_axi_awready_s = 0;
         tr_gold_clone.m00_axi_wstrb_s = 4'b0000;
         tr_gold_clone.m00_axi_wuser_s = 2'b00;
         tr_gold_clone.m00_axi_wready_s = 1;
         tr_gold_clone.m00_axi_wvalid_s = 1;
         tr_gold_clone.m00_axi_bid_s = 0;
         tr_gold_clone.m00_axi_bresp_s = 2'b00;
         tr_gold_clone.m00_axi_buser_s = 2'b00;
         tr_gold_clone.m00_axi_bvalid_s = 0;
         tr_gold_clone.m00_axi_bready_s = 0;
         tr_gold_clone.m00_axi_arid_s = 0;
         tr_gold_clone.m00_axi_arsize_s = 3'b010;
         tr_gold_clone.m00_axi_arburst_s = 2'b01;
         tr_gold_clone.m00_axi_arlock_s = 0;
         tr_gold_clone.m00_axi_arcache_s = 4'b0000;
         tr_gold_clone.m00_axi_arprot_s = 3'b000;
         tr_gold_clone.m00_axi_arqos_s = 4'b0000;
         tr_gold_clone.m00_axi_aruser_s = 2'b00;
         tr_gold_clone.m00_axi_arvalid_s = 0;
         tr_gold_clone.m00_axi_arready_s = 0;
         tr_gold_clone.m00_axi_rid_s = 0;
         tr_gold_clone.m00_axi_rresp_s = 2'b00;
         tr_gold_clone.m00_axi_rlast_s = 1'b0;
         tr_gold_clone.m00_axi_ruser_s = 2'b00;
         tr_gold_clone.m00_axi_rvalid_s = 1'b1;
         tr_gold_clone.m00_axi_rready_s = 1'b1;
         

         

         data_available = (endGr_val - iniGr_val) - 1;

         data_available_write = endGr_val - iniGr_val;


         write_index = 0;

         if(data_available_write > C_M00_AXI_BURST_LEN - 1) begin
            tr_gold_clone.m00_axi_awlen_s = C_M00_AXI_BURST_LEN - 1;
            //IZMENA 3. maj 2024

            axi_awaddr_incr = (C_M00_AXI_BURST_LEN) * (C_M00_AXI_DATA_WIDTH/8);
         end else begin
            tr_gold_clone.m00_axi_awlen_s = data_available_write;
            axi_awaddr_incr = data_available_write * (C_M00_AXI_DATA_WIDTH/8);
         end


         m00_axi_awaddr_int = ((iniGr_val - 1) * (C_M00_AXI_DATA_WIDTH/8)) + axi_awaddr_incr;
         m00_axi_awaddr_tmp = m00_axi_awaddr_int[C_M00_AXI_ADDR_WIDTH - 3 : 0];
         tr_gold_clone.m00_axi_awaddr_s = {2'b10,m00_axi_awaddr_tmp};
         
     // CITA dizajn podatak 0 jer nije nista upisano na tu lokaciju a u tb jeste

         $fdisplay(fd4,"iniGr_val = %0d",iniGr_val);
         $fdisplay(fd4,"endGr_val = %0d",endGr_val);
         $fdisplay(fd4,"data_available_write = %d %t",data_available_write,$time);
         $fdisplay(fd4,"tr_gold_clone.m00_axi_awaddr_s = %h",tr_gold_clone.m00_axi_awaddr_s);

         
         
         if(data_available > C_M00_AXI_BURST_LEN - 1) begin
            tr_gold_clone.m00_axi_arlen_s = C_M00_AXI_BURST_LEN - 1;
            axi_araddr_incr = (C_M00_AXI_BURST_LEN) * (C_M00_AXI_DATA_WIDTH/8);
         end else begin
            tr_gold_clone.m00_axi_arlen_s = data_available;
            axi_araddr_incr = data_available * (C_M00_AXI_DATA_WIDTH/8);
         end


         //PODESI araddr
         m00_axi_araddr_int = ((iniGr_val - 1) * (C_M00_AXI_DATA_WIDTH/8)) + axi_araddr_incr;
         m00_axi_araddr_tmp = m00_axi_araddr_int[C_M00_AXI_ADDR_WIDTH - 3 : 0];
         tr_gold_clone.m00_axi_araddr_s = {2'b11,m00_axi_araddr_tmp};

         init_flag = 0;

         if(data_available_write > C_M00_AXI_BURST_LEN - 1) begin
               while(data_available_write > C_M00_AXI_BURST_LEN - 1) begin

                  
                  //IZMENA 3. maj 2024
                  for(i = 0;i <= tr_gold_clone.m00_axi_awlen_s;i++) begin
                  //IZMENA 25. april 2024
                  //for(i = 0;i < tr_gold_clone.m00_axi_awlen_s;i++) begin

                     psolaf_axi_full_m_seq_item tr_gold_clone_2;

                     tr_gold_clone_2 = psolaf_axi_full_m_seq_item::type_id::create("tr_gold_clone_2", this);

                     if (tr_gold_clone_2 != null) begin
                        // Perform a deep copy of tr_gold to tr_clone
                        $cast(tr_gold_clone_2, tr_gold_clone.clone());

                     end else begin
                        // Handle error or debug
                        $display("Error: Unable to allocate memory for tr_gold_clone");
                     end

                     // $display("vrednosti %d ", i);
                     // $fscanf(fd,"out[%d] = %2.31f",adr,val_out);

                     // Izmena 3.jul2024
                     $fscanf(fd,"out[%d] = %2.30f",adr,val_out);
                     
                     $fscanf(fd3,"out[%d] = %2.30f",adr_read,val_read_out);

                     $fdisplay(fd4,"out = %2.30f",val_out);

                     // $fscanf(fd3,"out[%d] = %2.31f",adr_read,val_read_out);

                     // $fdisplay(fd4,"out = %2.31f",val_out);
                     // $display("vrednosti wdata_s ", fp32_to_fixed_han($shortrealtobits(val_out),0));
                     // tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han($shortrealtobits(val_out),0);
                     // tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han($shortrealtobits(val_read_out),0);
                     // Izmena 3.jul2024
                     tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han($shortrealtobits(val_out),1);
                     tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han($shortrealtobits(val_read_out),1);
                     
                     //IZMENA 25. april 2024
                     if(i == tr_gold_clone.m00_axi_awlen_s - 1)begin
                        tr_gold_clone_2.m00_axi_wlast_s = 1;
                        tr_gold_clone_2.m00_axi_rlast_s = 1;
                        write_index = 0;
                     end else begin
                        tr_gold_clone_2.m00_axi_wlast_s = 0;
                        tr_gold_clone_2.m00_axi_rlast_s = 0;
                     end

                     $fdisplay(fd4,"tr_gold_clone.m00_axi_wdata_s = %b",tr_gold_clone_2.m00_axi_wdata_s);
                     $fdisplay(fd4,"tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);



                     if(i == 0 && init_flag == 0)begin
                        init_flag = 1;
                        gold_before.push_back(tr_gold_clone_2);
                        $fdisplay(fd4,"INIT tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);
                        gold_before.push_back(tr_gold_clone_2);
                        $fdisplay(fd4,"INIT tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);
                     end
                     gold_before.push_back(tr_gold_clone_2);


                     tr_gold_clone_2 = null;
                        
                  end

                     // data_available_write = data_available_write - (C_M00_AXI_BURST_LEN - 1);
                     //Izmena 4. maj 2024
                     $fdisplay(fd7,"data_available_write = %d %t",data_available_write,$time);
                     data_available_write = data_available_write - C_M00_AXI_BURST_LEN;
                     $fdisplay(fd7,"data_available_write = %d %t",data_available_write,$time);
                     //data_available_write = data_available_write - write_index;
                     data_available = data_available - (C_M00_AXI_BURST_LEN - 1);


                     if(data_available_write > C_M00_AXI_BURST_LEN - 1) begin
                        axi_awaddr_incr = (C_M00_AXI_BURST_LEN) * (C_M00_AXI_DATA_WIDTH/8);
                     end else begin
                        axi_awaddr_incr = data_available_write * (C_M00_AXI_DATA_WIDTH/8);
                     end

                     if(data_available > C_M00_AXI_BURST_LEN - 1) begin
                        axi_araddr_incr = (C_M00_AXI_BURST_LEN) * (C_M00_AXI_DATA_WIDTH/8);
                     end else begin
                        axi_araddr_incr = data_available * (C_M00_AXI_DATA_WIDTH/8);
                     end
                     
                     $fdisplay(fd4,"C_M00_AXI_BURST_LEN = %h",C_M00_AXI_BURST_LEN);
                     $fdisplay(fd4,"C_M00_AXI_DATA_WIDTH/8 = %h",(C_M00_AXI_DATA_WIDTH/8));
                     $fdisplay(fd4,"(C_M00_AXI_BURST_LEN) * (C_M00_AXI_DATA_WIDTH/8); = %h",(C_M00_AXI_BURST_LEN) * (C_M00_AXI_DATA_WIDTH/8));
                     $fdisplay(fd4,"tr_gold_clone.m00_axi_awaddr_s = %h",tr_gold_clone.m00_axi_awaddr_s);
                     $fdisplay(fd4,"axi_araddr_incr = %h",axi_araddr_incr);
                     $fdisplay(fd4,"tr_gold_clone.m00_axi_awaddr_s + axi_awaddr_incr[C_M00_AXI_ADDR_WIDTH - 1 : 0] = %h",tr_gold_clone.m00_axi_awaddr_s + axi_awaddr_incr[C_M00_AXI_ADDR_WIDTH - 1 : 0]);
                     tr_gold_clone.m00_axi_awaddr_s = tr_gold_clone.m00_axi_awaddr_s + axi_awaddr_incr[C_M00_AXI_ADDR_WIDTH - 1 : 0];
                     tr_gold_clone.m00_axi_araddr_s = tr_gold_clone.m00_axi_araddr_s + axi_araddr_incr[C_M00_AXI_ADDR_WIDTH - 1 : 0];

                     $fdisplay(fd4,"tr_gold_clone.m00_axi_awaddr_s = %h",tr_gold_clone.m00_axi_awaddr_s);
                     $fdisplay(fd4,"write_index = %d",write_index);
                     $fdisplay(fd4,"data_available_write = %d",data_available_write);

               end

                  tr_gold_clone.m00_axi_awlen_s = data_available_write;
                  tr_gold_clone.m00_axi_arlen_s = data_available;
                  //Izmenjeno 4. maj 2024
                  for(i = 0;i <= tr_gold_clone.m00_axi_awlen_s;i++) begin

                     psolaf_axi_full_m_seq_item tr_gold_clone_2;
                     // Create a new object using the constructor
                     tr_gold_clone_2 = psolaf_axi_full_m_seq_item::type_id::create("tr_gold_clone_2", this);


                     // Check if the object creation was successful
                     if (tr_gold_clone_2 != null) begin
                        // Perform a deep copy of tr_gold to tr_clone
                        $cast(tr_gold_clone_2, tr_gold_clone.clone());


                     //Treba da promenis da upisuje jednu manje kad je vise od 128 elemenata
                     end else begin
                        // Handle error or debug
                        $display("Error: Unable to allocate memory for tr_gold_clone");
                     end

                     // $display("vrednosti %d ", i);
                     // $fscanf(fd,"out[%d] = %2.31f",adr,val_out);

                     // Izmena 3.jul2024
                     $fscanf(fd,"out[%d] = %2.30f",adr,val_out);
                     
                     $fscanf(fd3,"out[%d] = %2.31f",adr_read,val_read_out);

                     $fdisplay(fd4,"out = %2.31f",val_out);
                     // $display("vrednosti wdata_s ", fp32_to_fixed_han($shortrealtobits(val_out),0));
                     // tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han($shortrealtobits(val_out),0);
                     // tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han($shortrealtobits(val_read_out),0
                     
                     //  Izmena 3.jul2024
                     tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han($shortrealtobits(val_out),1);
                     tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han($shortrealtobits(val_read_out),1);
                     
                     if(i == tr_gold_clone.m00_axi_awlen_s)begin
                        tr_gold_clone_2.m00_axi_wlast_s = 1;
                        tr_gold_clone_2.m00_axi_rlast_s = 1;
                        write_index = 0;
                     end else begin
                        tr_gold_clone_2.m00_axi_wlast_s = 0;
                        tr_gold_clone_2.m00_axi_rlast_s = 0;
                     end

                     $fdisplay(fd4,"tr_gold_clone.m00_axi_wdata_s = %b",tr_gold_clone_2.m00_axi_wdata_s);
                     $fdisplay(fd4,"tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);

                     gold_before.push_back(tr_gold_clone_2);

                     // Destroy the object after pushing it to the array
                     tr_gold_clone_2 = null;
                     $fdisplay(fd4,"=========aAA==============================================",);
                     $fdisplay(fd4,"=======================================================",);
                     
                     //if(cnt == 0)  
                  end
         
         end else begin
               //AKO JE KRACE OD C_M00_AXI_BURST_LEN


                  tr_gold_clone.m00_axi_awlen_s = data_available_write;
                  tr_gold_clone.m00_axi_arlen_s = data_available;

                  for(i = 0;i <= tr_gold_clone.m00_axi_awlen_s;i++) begin
                     psolaf_axi_full_m_seq_item tr_gold_clone_2;
                     // Create a new object using the constructor
                     tr_gold_clone_2 = psolaf_axi_full_m_seq_item::type_id::create("tr_gold_clone_2", this);


                     // Check if the object creation was successful
                     if (tr_gold_clone_2 != null) begin
                        // Perform a deep copy of tr_gold to tr_clone
                        $cast(tr_gold_clone_2, tr_gold_clone.clone());

                     end else begin
                        // Handle error or debug
                        $display("Error: Unable to allocate memory for tr_gold_clone");
                     end

                     // $display("vrednosti %d ", i);
                     // $fscanf(fd,"out[%d] = %2.31f",adr,val_out);

                     // Izmena 3.jul2024
                     $fscanf(fd,"out[%d] = %2.30f",adr,val_out);
                     
                     $fscanf(fd3,"out[%d] = %2.30f",adr_read,val_read_out);

                     $fdisplay(fd4,"out = %2.30f",val_out);

                     // $fscanf(fd3,"out[%d] = %2.31f",adr_read,val_read_out);

                     // $fdisplay(fd4,"out = %2.31f",val_out);
                     // tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han($shortrealtobits(val_out),0);
                     // tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han($shortrealtobits(val_read_out),0);


                     // Izmena 3.jul2024
                     tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han($shortrealtobits(val_out),1);
                     tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han($shortrealtobits(val_read_out),1);

                     // tr_gold_clone_2.m00_axi_wdata_s = fp32_to_fixed_han_debug($shortrealtobits(val_out),1);
                     // tr_gold_clone_2.m00_axi_rdata_s = fp32_to_fixed_han_debug($shortrealtobits(val_read_out),1);

                     $fdisplay(fd4,"$shortrealtobits(val_out) = %b",$shortrealtobits(val_out));
                     $fdisplay(fd4,"fp32_to_fixed_han_debug($shortrealtobits(val_out),1) = %b",fp32_to_fixed_han($shortrealtobits(val_out),1));
                     if(i == tr_gold_clone.m00_axi_awlen_s)begin
                        tr_gold_clone_2.m00_axi_wlast_s = 1;
                        tr_gold_clone_2.m00_axi_rlast_s = 1;
                        write_index = 0;
                     end else begin
                        tr_gold_clone_2.m00_axi_wlast_s = 0;
                        tr_gold_clone_2.m00_axi_rlast_s = 0;
                     end

                     $fdisplay(fd4,"INIT tr_gold_clone.m00_axi_wdata_s = %b",tr_gold_clone_2.m00_axi_wdata_s);
                     $fdisplay(fd4,"INIT tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);


                     // Push the cloned object to the array
                     if(i == 0 && init_flag == 0)begin
                        init_flag = 1;
                        $fdisplay(fd4,"init_flag = %h %t",init_flag,$time);
                        gold_before.push_back(tr_gold_clone_2);
                        $fdisplay(fd4,"tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);
                        gold_before.push_back(tr_gold_clone_2);
                        $fdisplay(fd4,"tr_gold_clone.m00_axi_wdata_s = %h",tr_gold_clone_2.m00_axi_wdata_s);
                     end
                     gold_before.push_back(tr_gold_clone_2);

                     // Destroy the object after pushing it to the array
                     tr_gold_clone_2 = null;
                     $fdisplay(fd4,"=========aAA==============================================",);
                     $fdisplay(fd4,"=======================================================",);
                     
                     //if(cnt == 0)  
                  end
         end
         
         
         tr_gold_clone = null; // Set to null to avoid dangling reference
         cnt++;
         //Napisi vrednost za wdata tako sto ces imati petlju u kojoj ces
         //citati vrednosti iz mem_out sto ce biti vrednosti iz proslih ciklusa
         // i iz fajla debugOutReadSvakiProlaz vrednsoti
         //koje ce predstavljati trenutne vrednosti koje je dut izracunao
         //u ovom ciklusu
      end

      
      //$display("pise %s = %d",str,val);
      $fclose(fd);
      $fclose(fd1);
      $fclose(fd2);
      $fclose(fd3);
      $fclose(fd4);
      $fclose(fd5);
      $fclose(fd6);
endtask : read_mem_out



task psolaf_scoreboard::read_pit(psolaf_axi_sl_seq_item tr_gold); 
   int fd;
      int pit_val;
   string pit_s;
   fd = $fopen({"../../../../../../esl/verif/golden_vector_source/",pit_arg6,".txt"},"r");

   if(fd)
      $display("debugPitB file was open successfully %0d =====================================================",fd);
   else
      $display("debugPitB file was NOT open successfully %0d =====================================================",fd);

   $display("scoreboard psolaf_axi_sl_env pit_arg6 : %s", pit_arg6);

   while($fscanf(fd,"%s = %d",pit_s,pit_val) == 2) begin
      psolaf_axi_sl_seq_item tr_gold_s_clone;
      
      tr_gold_s_clone = psolaf_axi_sl_seq_item::type_id::create("tr_gold_s_clone", this);

      if (tr_gold_s_clone != null) begin
         // Perform a deep copy of tr_gold to tr_clone
         $cast(tr_gold_s_clone, tr_gold.clone());

      end else begin
         // Handle error or debug
         $display("Error: Unable to allocate memory for tr_gold_s_clone");
      end

      tr_gold_s_clone.dir = AXIL_READ;
      tr_gold_s_clone.s00_axi_awaddr_s = 5'b00000;
      tr_gold_s_clone.s00_axi_awprot_s = 2'b00;
      tr_gold_s_clone.s00_axi_awvalid_s = 0;
      tr_gold_s_clone.s00_axi_awready_s = 0;
      tr_gold_s_clone.s00_axi_wdata_s = 32'h00000000;
      tr_gold_s_clone.s00_axi_wstrb_s = 3'b000;
      tr_gold_s_clone.s00_axi_wvalid_s = 0;
      tr_gold_s_clone.s00_axi_wready_s = 0;
      tr_gold_s_clone.s00_axi_bresp_s = 2'b00;
      tr_gold_s_clone.s00_axi_bvalid_s = 0;
      tr_gold_s_clone.s00_axi_bready_s = 0;
      tr_gold_s_clone.s00_axi_araddr_s = 5'b00000;
      tr_gold_s_clone.s00_axi_arprot_s = 2'b00;
      tr_gold_s_clone.s00_axi_arvalid_s = 0; 
      tr_gold_s_clone.s00_axi_arready_s = 0;
      tr_gold_s_clone.s00_axi_rdata_s = pit_val[C_S00_AXI_DATA_WIDTH - 1 : 0];
      tr_gold_s_clone.s00_axi_rresp_s = 2'b00;
      tr_gold_s_clone.s00_axi_rvalid_s = 1;
      tr_gold_s_clone.s00_axi_rready_s = 1;

      gold_lite_arr.push_back(tr_gold_s_clone);
   end
endtask : read_pit

`endif



// coverage mozes da probas signal da izvuces iz psolaf modula
// ili neke zanimljive dogadjaje da ispratis kao sto je citanje jednog elementa
// ili upis maksimalnih vrednosti

// regresija se pravi sto napises tcl skriptu pa prosledis druge fajlove ulazne
// yo bullock chocolate i onda i za scoreboard moras proslediti posebne vrednosti 
// za gold vektor

// regresisa sa drugim seedom pri randomizaciji