`ifndef PSOLAF_AXI_FULL_M_SEQUENCER_SV
 `define PSOLAF_AXI_FULL_M_SEQUENCER_SV

class psolaf_axi_full_m_sequencer extends uvm_sequencer#(psolaf_axi_full_m_seq_item);

   `uvm_component_utils(psolaf_axi_full_m_sequencer)

   function new(string name = "psolaf_axi_full_m_sequencer", uvm_component parent = null);
      super.new(name,parent);
   endfunction

endclass : psolaf_axi_full_m_sequencer

`endif

