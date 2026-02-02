`ifndef PSOLAF_AXI_SL_AGENT_PKG
`define PSOLAF_AXI_SL_AGENT_PKG


package psolaf_axi_sl_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
   import configuration_pkg::*;   
   import psolaf_axi_sl_seq_pkg::*;
   


      int MEM_HAN[5000];
      bit han_val_ready;
      

      `define FP32_MANT_FRAC_BITS  23
      `define FP32_EXPO_BITS       8

      //MOZDA JE GRESA U EXPO I MANT IZNAD PA ZNAK KAD OBRCE NA KRAJU POGRESI ZBOG NJIH
      `define FP32_EXPO_MASK       ((1 << `FP32_EXPO_BITS) - 1)
      `define FP32_MANT_MASK       ((1 << `FP32_MANT_FRAC_BITS) - 1)
      `define FP32_MANT_INT_BIT    (1 << `FP32_MANT_FRAC_BITS)
      `define FP32_SIGN_BIT        (1 << (`FP32_MANT_FRAC_BITS + `FP32_EXPO_BITS))
      `define FP32_EXPO_BIAS       (127)
      `define FRAC_BITS_HAN    (31)
// izmena 3.jul 2024 unisenje posebnog frac za out
      `define FRAC_BITS_OUT    (30)
      `define FRAC_BITS_IN    (25)
      `define FRAC_BITS_DIFF_HAN       (`FP32_MANT_FRAC_BITS - `FRAC_BITS_HAN)
      `define FRAC_BITS_DIFF_IN       (`FP32_MANT_FRAC_BITS - `FRAC_BITS_IN)

      `define FRAC_BITS_DIFF_OUT       (`FP32_MANT_FRAC_BITS - `FRAC_BITS_OUT)

   
   function bit[C_S00_AXI_DATA_WIDTH -1 : 0] fp32_to_fixed_han(bit [C_S00_AXI_DATA_WIDTH -1 : 0] fl,int mem_type);
   
   

      int expo;
      int mant,sign;
      int shift;
      int shifted_right,shifted_left;
      int discard,round,sticky,odd;
      int res;
      bit [C_S00_AXI_DATA_WIDTH -1 : 0] shifted_left_bit;
      expo = (fl >> `FP32_MANT_FRAC_BITS) & `FP32_EXPO_MASK;
      mant = expo ? ((fl & `FP32_MANT_MASK) | `FP32_MANT_INT_BIT) : 0;
      sign = fl & `FP32_SIGN_BIT;
      case(mem_type)
            0 : // HAN
                  shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_HAN;
            
            1 : // OUT  
                  shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_OUT;
            2 : 
                  shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_IN;
            default :
                   shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_IN;
      endcase

      if(shift < 0) begin
            shift = (shift < (-31)) ? (-31) : shift;
      end else begin
            shift = (shift > (31)) ? (31) : shift;
      end
      shifted_right = mant >> (-shift);
      shifted_left = mant << shift;


      discard = mant << (32 + shift);
      round = (discard & 32'h80000000) ? 1 : 0;
      sticky = (discard & 32'h7fffffff) ? 1 : 0;

      
      odd = shifted_right & 1;
      shifted_right = (round & (sticky | odd)) ? (shifted_right + 1) : shifted_right;

      res = (shift < 0) ? shifted_right : shifted_left;
      

      return (sign < 0) ? (-res) : res;
   endfunction

function bit[C_S00_AXI_DATA_WIDTH -1 : 0] fp32_to_fixed_han_debug(bit [C_S00_AXI_DATA_WIDTH -1 : 0] fl,int mem_type);

      int expo;
      int mant,sign;
      int shift;
      int shifted_right,shifted_left;
      int discard,round,sticky,odd;
      int res;
      bit [C_S00_AXI_DATA_WIDTH -1 : 0] shifted_left_bit;
      expo = (fl >> `FP32_MANT_FRAC_BITS) & `FP32_EXPO_MASK;

      mant = expo ? ((fl & `FP32_MANT_MASK) | `FP32_MANT_INT_BIT) : 0;
      $display("mant = %b", mant);
      sign = fl & `FP32_SIGN_BIT;
      $display("sign = %b", sign);
      case(mem_type)
            0 : 
                  shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_HAN;
            1 : // OUT  
                  shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_OUT;
            2 : 
                  shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_IN;
            default :
                   shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF_IN;
      endcase
      //shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF;
      //shift = -5;
      $display("shift = %b", shift);
      if(shift < 0) begin
            shift = (shift < (-31)) ? (-31) : shift;
            // $display("shift manje od nule = %b", shift);
      end else begin
            shift = (shift > (31)) ? (31) : shift;
            // $display("shift vece od nule = %b", shift);
      end
      $display("shift = %b", shift);
      shifted_right = mant >> (-shift);
      $display("shifted_right = %b", shifted_right);
      shifted_left = mant << shift;
      $display("shifted_left = %b", shifted_left);
      $display("mant = %d", mant);
      $display("shift = %d", shift);
      $display("shifted_left = %d", shifted_left);

      discard = mant << (32 + shift);
      $display("discard = %b", discard);
      round = (discard & 32'h80000000) ? 1 : 0;
      $display("round = %b", round);
      sticky = (discard & 32'h7fffffff) ? 1 : 0;
      $display("sticky = %b", sticky);

      
      odd = shifted_right & 1;
      $display("odd = %b", odd);
      shifted_right = (round & (sticky | odd)) ? (shifted_right + 1) : shifted_right;
      $display("shifted_right = %b", shifted_right);

      res = (shift < 0) ? shifted_right : shifted_left;
      $display("res = %b", res);
      
      return (sign < 0) ? (-res) : res;
   //endtask
   endfunction


   `include "psolaf_axi_sl_seq_item.sv"
   `include "psolaf_axi_sl_sequencer.sv"
   `include "psolaf_axi_sl_driver.sv"
   `include "psolaf_axi_sl_monitor.sv"
   `include "psolaf_axi_sl_agent.sv"


endpackage : psolaf_axi_sl_agent_pkg

`endif



