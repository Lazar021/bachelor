`ifndef PSOLAF_AXI_SL_SIMPLE_SEQ_SV
 `define PSOLAF_AXI_SL_SIMPLE_SEQ_SV

`define FP32_MANT_FRAC_BITS  23
`define FP32_EXPO_BITS       8
`define FP32_EXPO_MASK       ((1 << `FP32_EXPO_BITS) - 1)
`define FP32_MANT_MASK       ((1 << `FP32_MANT_FRAC_BITS) - 1)
`define FP32_MANT_INT_BIT    (1 << `FP32_MANT_FRAC_BITS)
`define FP32_SIGN_BIT        (1 << (`FP32_MANT_FRAC_BITS + `FP32_EXPO_BITS))
`define FP32_EXPO_BIAS       (127)
`define FX10P22_FRAC_BITS    (22)
`define FRAC_BITS_DIFF       (`FP32_MANT_FRAC_BITS - `FX10P22_FRAC_BITS)


class psolaf_axi_sl_simple_seq extends psolaf_axi_sl_base_seq;

   rand bit [C_S00_AXI_ADDR_WIDTH -1 : 0] s00_axi_awaddr_aaa = 16;
   //rand logic [2 : 0] s00_axi_awprot_s;
   rand bit s00_axi_awvalid_s = 1;

    bit [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_wdata_s = 196;
   rand bit [(C_S00_AXI_DATA_WIDTH/8) - 1 : 0] s00_axi_wstrb = 4'b1111;
   rand bit s00_axi_wvalid_s = 1;

   rand bit s00_axi_bready_s = 1;

   constraint s00_axi_awvalid_s_cst { s00_axi_awvalid_s == 1;}

   constraint s00_axi_wvalid_s_cst { s00_axi_wvalid_s == 1;}
   constraint s00_axi_bready_s_cst { s00_axi_bready_s == 1;}


   // UVM factory registration
   `uvm_object_utils (psolaf_axi_sl_simple_seq)

   // new - constructor
   function new(string name = "psolaf_axi_sl_simple_seq");
      super.new(name);
   endfunction

   virtual task body();

      int fd;
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_lite_seq.txt","a");
      $timeformat(-9,2,"ns",20);
      `uvm_info(get_type_name(),"body SIMPLE SLAVE SEQ", UVM_LOW)
      if(fd)
            $display("debug_lite_seq file was open successfully %0d",fd);
      else
            $display("debug_lite_seq file was NOT open successfully %0d",fd);


      $fdisplay(fd,"m_size %d",$time);
      $display("psolaf_axi_sl_simple_seq m_size_cfg = %d",m_size_cfg);
      //    m_size
      `uvm_do_with(  req, {
            req.dir == AXIL_WRITE;

            req.s00_axi_awaddr_s == 16;
            req.s00_axi_awvalid_s == 1;
            // req.s00_axi_wdata_s == M_SIZE;  
            req.s00_axi_wdata_s == m_size_cfg;
            req.s00_axi_wstrb_s == 4'b1111;
            req.s00_axi_wvalid_s == 1;
            req.s00_axi_bready_s == 1;

      })

      $fdisplay(fd,"In_size %d",$time);
      $display("psolaf_axi_sl_simple_seq in_size_cfg = %d",in_size_cfg);
      //In_size
      `uvm_do_with(  req, {
            req.dir == AXIL_WRITE;

            req.s00_axi_awaddr_s == 12;
            req.s00_axi_awvalid_s == 1;
            // req.s00_axi_wdata_s == IN_SIZE;
            req.s00_axi_wdata_s == in_size_cfg;
            req.s00_axi_wstrb_s == 4'b1111;
            req.s00_axi_wvalid_s == 1;
            req.s00_axi_bready_s == 1;
      })

      $fdisplay(fd,"alpha %d",$time);

      $display("psolaf_axi_sl_simple_seq alpha_cfg = %f",alpha_cfg);
      // alpha
      `uvm_do_with(  req, {
            req.dir == AXIL_WRITE;

            req.s00_axi_awaddr_s == 0;
            req.s00_axi_awvalid_s == 1;
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(0.8));//prvi test yo
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(1.3));//drugi test yo 16. jun 2024
            req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(alpha_cfg));//drugi test yo 16. jun 2024
            req.s00_axi_wstrb_s == 4'b1111;
            req.s00_axi_wvalid_s == 1;
            req.s00_axi_bready_s == 1;
      })

      $display("psolaf_axi_sl_simple_seq beta_cfg = %f",beta_cfg);
      $fdisplay(fd,"beta %d",$time);
      // beta
      `uvm_do_with(  req, {
            req.dir == AXIL_WRITE;

            req.s00_axi_awaddr_s == 4;
            req.s00_axi_awvalid_s == 1;
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(0.5));//prvi test yo
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(0.8));//drugi test yo 16. jun 2024
            req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(beta_cfg));//drugi test yo 16. jun 2024
            req.s00_axi_wstrb_s == 4'b1111;
            req.s00_axi_wvalid_s == 1;
            req.s00_axi_bready_s == 1;
      })

      $display("psolaf_axi_sl_simple_seq gamma_cfg = %f",gamma_cfg);
      $fdisplay(fd,"gamma %d",$time);
      // gamma
      `uvm_do_with(  req, {
            req.dir == AXIL_WRITE;

            req.s00_axi_awaddr_s == GAMMA_REG_ADDR_C;
            req.s00_axi_awvalid_s == 1;
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(1.5));//prvi test yo
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(1.5));//drugi test yo 16. jun 2024
            req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(gamma_cfg));//drugi test yo 16. jun 2024
            req.s00_axi_wstrb_s == 4'b1111;
            req.s00_axi_wvalid_s == 1;
            req.s00_axi_bready_s == 1;
      })

      $fdisplay(fd,"gamma_rec %d",$time);
      $display("psolaf_axi_sl_simple_seq gamma_rec_cfg = %f %t",gamma_rec_cfg,$time);
      // gamma_rec
      `uvm_do_with(  req, {
            req.dir == AXIL_WRITE;

            req.s00_axi_awaddr_s == GAMMA_REC_REG_ADDR_C;
            req.s00_axi_awvalid_s == 1;
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(1.5));//prvi test yo
            // req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(1.5));//drugi test yo 16. jun 2024
            req.s00_axi_wdata_s == fp32_to_fixed($shortrealtobits(gamma_rec_cfg));//drugi test yo 16. jun 2024
            req.s00_axi_wstrb_s == 4'b1111;
            req.s00_axi_wvalid_s == 1;
            req.s00_axi_bready_s == 1;
      })


      
      
      do begin

            if(place_en_v == 1)begin
                  // pit
                  // PIT_REG_ADDR_C = 28
                  `uvm_do_with( req, {
                        req.dir == AXIL_READ;
                        req.s00_axi_araddr_s == PIT_REG_ADDR_C;
                        req.s00_axi_arvalid_s == 1;
                        req.s00_axi_rready_s == 1;
                  })

                  // PLACE_EN_ADDR_C  = 32
                  `uvm_do_with( req, {
                        req.dir == AXIL_READ;

                        //req.s00_axi_awaddr_s == 52;
                        req.s00_axi_araddr_s == PLACE_EN_ADDR_C;
                        req.s00_axi_arvalid_s == 1;
                        req.s00_axi_rready_s == 1;
                  })
                  // END_FLAG_ADDR_C = 40
                  `uvm_do_with( req, {
                        req.dir == AXIL_READ;
                        req.s00_axi_araddr_s == END_FLAG_ADDR_C;
                        req.s00_axi_arvalid_s == 1;
                        req.s00_axi_rready_s == 1;
                  })
            end else begin
                  // PLACE_EN_ADDR_C  = 32
                  `uvm_do_with( req, {
                        req.dir == AXIL_READ;

                        //req.s00_axi_awaddr_s == 52;
                        req.s00_axi_araddr_s == PLACE_EN_ADDR_C;
                        req.s00_axi_arvalid_s == 1;
                        req.s00_axi_rready_s == 1;
                  })

                  // END_FLAG_ADDR_C = 40
                  `uvm_do_with( req, {
                        req.dir == AXIL_READ;
                        req.s00_axi_araddr_s == END_FLAG_ADDR_C;
                        req.s00_axi_arvalid_s == 1;
                        req.s00_axi_rready_s == 1;
                  })
            end
            

            if(just_read_ready == 25)begin
                  //psolaf ready
                  // READY_REG_ADDR_C = 24
                  `uvm_do_with( req, {
                        req.dir == AXIL_READ;
                        req.s00_axi_araddr_s == READY_REG_ADDR_C;
                        req.s00_axi_arvalid_s == 1;
                        req.s00_axi_rready_s == 1;
                  })
            end
      end while(ready_psolaf != 1);

      $fclose(fd);

   endtask : body

function bit[C_S00_AXI_DATA_WIDTH -1 : 0] fp32_to_fixed(bit [C_S00_AXI_DATA_WIDTH -1 : 0] fl);

      int expo;
      int mant,sign;
      int shift;
      int shifted_right,shifted_left;
      int discard,round,sticky,odd;
      int res;
      bit [C_S00_AXI_DATA_WIDTH -1 : 0] shifted_left_bit;
      expo = (fl >> `FP32_MANT_FRAC_BITS) & `FP32_EXPO_MASK;
      //$display("fl = %b", fl);
      //$display("expo = %b", expo);
      mant = expo ? ((fl & `FP32_MANT_MASK) | `FP32_MANT_INT_BIT) : 0;
      //$display("mant = %b", mant);
      sign = fl & `FP32_SIGN_BIT;
      //$display("sign = %b", sign);
      shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF;
      //shift = -5;
      //$display("shift = %b", shift);
      if(shift < 0) begin
            shift = (shift < (-31)) ? (-31) : shift;
            //$display("shift manje od nule = %b", shift);
      end else begin
            shift = (shift > (31)) ? (31) : shift;
            //$display("shift vece od nule = %b", shift);
      end
      shifted_right = mant >> (-shift);
      //$display("shifted_right = %b", shifted_right);
      shifted_left = mant << shift;


      discard = mant << (32 + shift);
      //$display("discard = %b", discard);
      round = (discard & 32'h80000000) ? 1 : 0;
      //$display("round = %b", round);
      sticky = (discard & 32'h7fffffff) ? 1 : 0;
      //$display("sticky = %b", sticky);

      
      odd = shifted_right & 1;
      //$display("odd = %b", odd);
      shifted_right = (round & (sticky | odd)) ? (shifted_right + 1) : shifted_right;
      //$display("shifted_right = %b", shifted_right);

      res = (shift < 0) ? shifted_right : shifted_left;
      //$display("res = %b", res);

      return (sign < 0) ? (-res) : res;
endfunction


endclass : psolaf_axi_sl_simple_seq

`endif
