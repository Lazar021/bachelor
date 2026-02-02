`ifndef TEST_SIMPLE_SV
 `define TEST_SIMPLE_SV


//import psolaf_axi_pkg::*;

class test_simple extends test_base;

   `uvm_component_utils(test_simple)

   psolaf_axi_sl_simple_seq simple_seq;
   psolaf_axi_full_m_simple_seq m_simple_seq;

   function new(string name = "test_simple", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      simple_seq = psolaf_axi_sl_simple_seq::type_id::create("simple_seq");
      m_simple_seq = psolaf_axi_full_m_simple_seq::type_id::create("m_simple_seq");
   endfunction : build_phase

   task main_phase(uvm_phase phase);
      int fd56;
      // fd56 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_start_test.txt","w");       
      if(fd56)
         $display("file debug_start_test was open successfully %0d",fd56);
      else
         $display("file debug_start_test was NOT open successfully %0d",fd56);
      $timeformat(-9,2,"ns",20);
      phase.raise_objection(this);
      `uvm_info(get_type_name(),"main_phase TEST_SIMPLE OBSERVED", UVM_LOW)
      $fdisplay(fd56,"pre psolaf_slave_lite start %d",$time);

      fork
               $display("pre psolaf_slave_lite start %d***********************************************************",$time);
               simple_seq.start(env.psolaf_slave_agent.seqr);
               $fdisplay(fd56,"psolaf_slave_lite start %d",$time);
               $display("psolaf_slave_lite start %d***********************************************************",$time);
               m_simple_seq.start(env.psolaf_master_agent.seqr);
               //$fdisplay(fd56,"psolaf_master_full start %d",$time);
      join
      $fdisplay(fd56,"posle fork_join %d",$time);
      $fclose(fd56);
      phase.drop_objection(this);
   endtask : main_phase

endclass

`endif
