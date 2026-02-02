`ifndef PSOLAF_AXI_FULL_M_BASE_SEQ_SV
 `define PSOLAF_AXI_FULL_M_BASE_SEQ_SV

class psolaf_axi_full_m_base_seq extends uvm_sequence#(psolaf_axi_full_m_seq_item);

   `uvm_object_utils(psolaf_axi_full_m_base_seq)
   `uvm_declare_p_sequencer(psolaf_axi_full_m_sequencer)

   function new(string name = "psolaf_axi_full_m_base_seq");
      super.new(name);
   endfunction

   // objections are raised in pre_body
   virtual task pre_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
        phase.raise_objection(this, {"Running sequence '", get_full_name(), "'"});
        `uvm_info(get_type_name(),"pre_body BASE FULL MASTER SEQ", UVM_LOW)
      uvm_test_done.set_drain_time(this, 200us);
   endtask : pre_body

   // objections are dropped in post_body
   virtual task post_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
        phase.drop_objection(this, {"Completed sequence '", get_full_name(), "'"});
        `uvm_info(get_type_name(),"post_body    BASE SFULL MASTER SEQ", UVM_LOW)
   endtask : post_body

endclass : psolaf_axi_full_m_base_seq

`endif
