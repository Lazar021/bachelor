`ifndef PSOLAF_AXI_FULL_M_MONITOR
`define PSOLAF_AXI_FULL_M_MONITOR

class psolaf_axi_full_m_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   axi_full_monitor_enum tr_state;

   uvm_analysis_port #(psolaf_axi_full_m_seq_item) item_collected_port_full;

   `uvm_component_utils_begin(psolaf_axi_full_m_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface psolaf_if vif;

   // current transaction
   psolaf_axi_full_m_seq_item tr;


   // coverage can go here
   // ...
   // covergroup

   // task sample_phase(uvm_phase phase);
   //    super.sample_phase(phase);

   //    // Accessing internal signal using hierarchical path
   //    // int state_next = psolaf_axi_v1_0.psolaf_top.psolaf.state_next;
   //    // $display("Coverage psolaf.state_next = %d at time %t", state_next, $time);
      
   //    if (psolaf_axi_v1_0.psolaf_top.psolaf.state_next) begin
   //          $display("State Next: %d at time %t", psolaf_axi_v1_0.psolaf_top.psolaf.state_next, $time);
   //    end

   // endtask : sample_phase

   covergroup cg_addr @(negedge(vif.m00_axi_arvalid_o ||  vif.m00_axi_awvalid_o));


      // $display("coverage m00_fsm_state = %b %t",vif.m00_fsm_state,$time);

      option.per_instance = 1;
      ar_addr : coverpoint (vif.m00_axi_araddr_o) {
         option.at_least = 25;
         bins mem_M = {[0 : 1073741823]};
         bins mem_IN = {[1073741824 : 2147483647]};
         bins mem_HAN = {[2147483648 : 3221225471]};
         bins mem_OUT = {[3221225472 : 4294967295]};
      }

      aw_addr : coverpoint (vif.m00_axi_awaddr_o) {
         option.at_least = 5;
         bins mem_M = {[0 : 1073741823]};
         bins mem_IN = {[1073741824 : 2147483647]};
         bins mem_OUT = {[2147483648 : 3221225471]};
      }

      aw_len : coverpoint (vif.m00_axi_awlen_o) {
         option.at_least = 3;
         bins len_1 = {0};
         bins len_2 = {1};
         bins len_2_30 = {[2 : 30]};
         bins len_31_80 = {[31 : 80]};
         bins len_81_126 = {[81 : 126]};
         bins len_127 = {127};
      }

      ar_len : coverpoint (vif.m00_axi_arlen_o) {
         option.at_least = 10;
         bins len_1 = {0};
         bins len_2 = {1};
         bins len_2_30 = {[2 : 30]};
         bins len_31_80 = {[31 : 80]};
         bins len_81_126 = {[81 : 126]};
         bins len_127 = {127};
      }
   endgroup : cg_addr


   covergroup cg_psoalf_state @(new_state_e);
      option.per_instance = 1;
      psolaf_state : coverpoint (vif.m00_fsm_state) {
         option.at_least = 1;
         bins idle         = {7'b0000000};
         bins razdaljina   = {7'b0000001};
         bins addr_set     = {7'b0000010};
         bins erase        = {7'b0000011};
         bins addr_set_p   = {7'b0000100};
         bins mPLast       = {7'b0000101};
         bins tk           = {7'b0000110};
         bins matk         = {7'b0000111};
         bins addr_min     = {7'b0001000};
         bins min          = {7'b0001001};
         bins p_addr       = {7'b0001010};
         bins place        = {7'b0001011};
         bins han          = {7'b0001100};
         bins gr           = {7'b0001101};
         bins par1         = {7'b0001110};
         bins par3         = {7'b0001111};
         bins interp1      = {7'b0010000};
         bins out_asmd     = {7'b0010001};
      }
   endgroup : cg_psoalf_state

   covergroup cg_m00_state @(new_mst_state_e);
      option.per_instance = 1;
      psolaf_state : coverpoint (vif.m00_mst_state_o) {
         option.at_least = 1;
         bins idle_m         = {7'b0000000};
         bins init_write   = {7'b0000001};
         bins init_read_m     = {7'b0000010};
         bins read_m        = {7'b0000011};
         bins erase_first_m   = {7'b0000100};
         bins m_last       = {7'b0000101};
         bins write_p           = {7'b0000110};
         bins m_write_last         = {7'b0000111};
         bins read_m_matk     = {7'b0001000};
         bins place_m          = {7'b0001001};
         bins init_read_han       = {7'b0001010};
         bins read_han        = {7'b0001011};
         bins init_read_opseg          = {7'b0001100};
         bins read_opseg           = {7'b0001101};
         bins read_opseg_2         = {7'b0001110};
         bins init_compare         = {7'b0001111};
         bins write_out      = {7'b0010000};
         bins write_out_2     = {7'b0010001};
         bins m_wrtie_last_addr_setup     = {7'b0010010};
      }
   endgroup : cg_m00_state
   //    covergroup cg_FSM @(negedge(vif.m00_axi_arvalid_o ||  vif.m00_axi_awvalid_o));
   //       // int state_next = psolaf_axi_v1_0.psolaf_top.psolaf.state_next;
      // $display("coverage psolaf.state_next = %d %t",state_next,$time);

      // if (psolaf_axi_v1_0.psolaf_top.psolaf.state_next) begin
      //    $display("State Next: %d at time %t", psolaf_axi_v1_0.psolaf_top.psolaf.state_next, $time);
      // end
   
   
   // option.per_instance = 1;
   //    ar_addr : coverpoint (vif.m00_axi_araddr_o) {
   //       option.at_least = 25;
   //       bins mem_M = {[0 : 1073741823]};
   //       bins mem_IN = {[1073741824 : 2147483647]};
   //       bins mem_HAN = {[2147483648 : 3221225471]};
   //       bins mem_OUT = {[3221225472 : 4294967295]};
   //    }

   //    aw_addr : coverpoint (vif.m00_axi_awaddr_o) {
   //       option.at_least = 5;
   //       bins mem_M = {[0 : 1073741823]};
   //       bins mem_IN = {[1073741824 : 2147483647]};
   //       bins mem_OUT = {[2147483648 : 3221225471]};
   //    }

   //    aw_len : coverpoint (vif.m00_axi_awlen_o) {
   //       option.at_least = 3;
   //       bins len_1 = {0};
   //       bins len_2 = {1};
   //       bins len_2_30 = {[2 : 30]};
   //       bins len_31_80 = {[31 : 80]};
   //       bins len_81_126 = {[81 : 126]};
   //       bins len_127 = {127};
   //    }

   //    ar_len : coverpoint (vif.m00_axi_arlen_o) {
   //       option.at_least = 10;
   //       bins len_1 = {0};
   //       bins len_2 = {1};
   //       bins len_2_30 = {[2 : 30]};
   //       bins len_31_80 = {[31 : 80]};
   //       bins len_81_126 = {[81 : 126]};
   //       bins len_127 = {127};
   //    }
   // endgroup : cg_addr

   // if(coverage_enable)begin
      
   // end

   // function new(virtual interface psolaf_if vif, string name = "psolaf_axi_full_m_monitor", uvm_component parent = null);
   //    super.new(name,parent);    

   //    this.vif = vif;

   //    item_collected_port = new("item_collected_port", this);
   //    if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
   //      `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   //    if(coverage_enable)begin
   //       cg_addr = new(); 
   //    end
   // endfunction

   // iznad je izmenjeno ovo ispod 3.jul.2024  
   // ubacen je interfejs da bi se videli unutrasnji signali duta
   function new(string name = "psolaf_axi_full_m_monitor", uvm_component parent = null);
      super.new(name,parent);      
      item_collected_port_full = new("item_collected_port_full", this);
      if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      if(coverage_enable)begin
         cg_addr = new(); 
         cg_psoalf_state = new();
         cg_m00_state = new();
      end
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

   endfunction : connect_phase

   task  state_refresh();
      forever begin
         if(vif.m00_fsm_state != state_reg)
         begin
            //  $display("psolaf_axi_full_m_monitor promena stanja %b %t",vif.m00_fsm_state,$time);
            -> new_state_e;
         end
         state_reg = vif.m00_fsm_state;

         // $display("psolaf_axi_full_m_monitor vif.m00_mst_state_o %b %t",vif.m00_mst_state_o,$time);
         // $display("psolaf_axi_full_m_monitor mst_state_reg %b %t",mst_state_reg,$time);

         if(vif.m00_mst_state_o != mst_state_reg)
         begin
            // $display("psolaf_axi_full_m_monitor promena axi master stanja %b %t",vif.m00_mst_state_o,$time);
            -> new_mst_state_e;
         end
         mst_state_reg = vif.m00_mst_state_o;
         // @(posedge vif.clk);
         @(negedge vif.clk);

      end
   endtask : state_refresh

   task main_phase(uvm_phase phase);
      int fd,fd1;
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_monitor_write_out.txt","a");
      // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_monitor_port_connection.txt","a");
      $timeformat(-9,2,"ns",20);

      state_refresh();

      forever begin
         tr = psolaf_axi_full_m_seq_item::type_id::create("tr", this);
         
;


         case(tr_state)


            write_out : begin
               //Write OUT
               $display("write_out monitor pre posedge %t",$time);
               @(posedge vif.clk iff (vif.m00_axi_wvalid_o == 1 && vif.m00_axi_wready_i == 1));
               $display("write_out monitor posle posedge %t",$time);
               
               // $display("write_out monitor pre negedge %t",$time);
               // @(negedge vif.clk iff (vif.m00_axi_wvalid_o == 1 && vif.m00_axi_wready_i == 1));
               // $display("write_out monitor posle negedge %t",$time);
               write_index = write_index + 1; 
               
               tr.m00_axi_wdata_s = vif.m00_axi_wdata_o;    
               tr.m00_axi_wlast_s = vif.m00_axi_wlast_o;       


               tr.m00_axi_init_axi_txn_s = vif.m00_axi_init_axi_txn_i;
               tr.m00_axi_txn_done_s = vif.m00_axi_txn_done_o;
               tr.m00_axi_error_s = vif.m00_axi_error_o;
               tr.m00_axi_awid_s = vif.m00_axi_awid_o;
               tr.m00_axi_awaddr_s = vif.m00_axi_awaddr_o;
               tr.m00_axi_awlen_s = vif.m00_axi_awlen_o;
               tr.m00_axi_awsize_s = vif.m00_axi_awsize_o;
               tr.m00_axi_awburst_s = vif.m00_axi_awburst_o;
               tr.m00_axi_awlock_s = vif.m00_axi_awlock_o;
               tr.m00_axi_awcache_s = vif.m00_axi_awcache_o;
               tr.m00_axi_awprot_s = vif.m00_axi_awprot_o;
               tr.m00_axi_awqos_s = vif.m00_axi_awqos_o;
               tr.m00_axi_awuser_s = vif.m00_axi_awuser_o;
               tr.m00_axi_awvalid_s = vif.m00_axi_awvalid_o;
               tr.m00_axi_awready_s = vif.m00_axi_awready_i;
               tr.m00_axi_wdata_s = vif.m00_axi_wdata_o;
               tr.m00_axi_wstrb_s = vif.m00_axi_wstrb_o;
               tr.m00_axi_wlast_s = vif.m00_axi_wlast_o;
               tr.m00_axi_wuser_s = vif.m00_axi_wuser_o;
               tr.m00_axi_wvalid_s = vif.m00_axi_wvalid_o;
               tr.m00_axi_wready_s = vif.m00_axi_wready_i;
               tr.m00_axi_bid_s = vif.m00_axi_bid_i;
               tr.m00_axi_bresp_s = vif.m00_axi_bresp_i;
               tr.m00_axi_buser_s = vif.m00_axi_buser_i;
               tr.m00_axi_bvalid_s = vif.m00_axi_bvalid_i;
               tr.m00_axi_bready_s = vif.m00_axi_bready_o;
               tr.m00_axi_arid_s = vif.m00_axi_arid_o;
               tr.m00_axi_araddr_s = vif.m00_axi_araddr_o;
               tr.m00_axi_arlen_s = vif.m00_axi_arlen_o;
               tr.m00_axi_arsize_s = vif.m00_axi_arsize_o;
               tr.m00_axi_arburst_s = vif.m00_axi_arburst_o;
               tr.m00_axi_arlock_s = vif.m00_axi_arlock_o;
               tr.m00_axi_arcache_s = vif.m00_axi_arcache_o;
               tr.m00_axi_arprot_s = vif.m00_axi_arprot_o;
               tr.m00_axi_arqos_s = vif.m00_axi_arqos_o;
               tr.m00_axi_aruser_s = vif.m00_axi_aruser_o;
               tr.m00_axi_arvalid_s = vif.m00_axi_arvalid_o;
               tr.m00_axi_arready_s = vif.m00_axi_arready_i;
               tr.m00_axi_rid_s = vif.m00_axi_rid_i;
               tr.m00_axi_rdata_s = vif.m00_axi_rdata_i;
               tr.m00_axi_rresp_s = vif.m00_axi_rresp_i;
               tr.m00_axi_rlast_s = vif.m00_axi_rlast_i;
               tr.m00_axi_ruser_s = vif.m00_axi_ruser_i;
               tr.m00_axi_rvalid_s = vif.m00_axi_rvalid_i;
               tr.m00_axi_rready_s = vif.m00_axi_rready_o;

               $fdisplay(fd,"write_out monitor %s",tr.sprint());

               //Odstampaj kakvu transakciju pravi dut da bi znao kako treba da izgleda expected transaction


            end
            default: begin
               $fdisplay(fd," tr_state = %0d %t",tr_state,$time);
               @(posedge vif.clk);
            end
         endcase

          $fdisplay(fd1," write %t",$time);
         item_collected_port_full.write(tr);
      
      end

      //OVDE pomocu memorijskog mapiranja bi mozda trebao da prepoznam kad je
      //upis u MEM_OUT i da prosledim pose scoreboard-u
      //preko drajvera da posaljem odgovor za upis posto monitor ne moze
      //da salje signale nego samo da nadgleda
      //posebna transakcija u drajveru za citanje MEM_OUT memorije 
      //jer se u isto vreme i pise u MEM_OUT memoriju
      //na drajveru saljem signale,a u monitoru cekam na odredjen signal da se dogodi
      // na primer wvalid i wready i onda upisem podatak u MEM_OUT

      //za upisivanje na pocetak MEM_M mozda bih mogao na monitoru geldati signale 
      //i ako vidi na awvalid da tada u sekvenci kaze uradi upis u MEM_M
   endtask : main_phase

endclass : psolaf_axi_full_m_monitor
`endif