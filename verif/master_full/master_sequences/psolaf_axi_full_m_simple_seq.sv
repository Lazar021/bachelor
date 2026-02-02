`ifndef PSOLAF_AXI_FULL_M_SIMPLE_SEQ_SV
 `define PSOLAF_AXI_FULL_M_SIMPLE_SEQ_SV

`define FP32_MANT_FRAC_BITS  23
`define FP32_EXPO_BITS       8
`define FP32_EXPO_MASK       ((1 << `FP32_EXPO_BITS) - 1)
`define FP32_MANT_MASK       ((1 << `FP32_MANT_FRAC_BITS) - 1)
`define FP32_MANT_INT_BIT    (1 << `FP32_MANT_FRAC_BITS)
`define FP32_SIGN_BIT        (1 << (`FP32_MANT_FRAC_BITS + `FP32_EXPO_BITS))
`define FP32_EXPO_BIAS       (127)
`define FX10P22_FRAC_BITS    (22)
`define FRAC_BITS_DIFF       (`FP32_MANT_FRAC_BITS - `FX10P22_FRAC_BITS)


class psolaf_axi_full_m_simple_seq extends psolaf_axi_full_m_base_seq;


      psolaf_axi_full_m_seq_item paf_it;
      psolaf_axi_full_m_seq_item paradr_it;

      int mem_addr;
      int en_code;
      int mem_addr_wr;
      int en_code_wr;
      int wa;
      int ra;
      int stop_read,stop_write;
      bit mem_wr_s;
      //debug
      int read_cnt_print,write_cnt_print;

  
   // UVM factory registration
   `uvm_object_utils (psolaf_axi_full_m_simple_seq)

   // new - constructor
   function new(string name = "psolaf_axi_full_m_simple_seq");
      super.new(name);
   endfunction


   extern virtual function bit[C_M00_AXI_DATA_WIDTH -1 : 0] fp32_to_fixed (input bit [C_M00_AXI_DATA_WIDTH -1 : 0] fl);
   extern virtual task read_file();
   extern virtual task read_axi_up_to_128();
      extern virtual task write_read_out_up_to_128();
      extern virtual task write_addr_setup();
   
   virtual task body();
      int fd,fd1;
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_full_seq.txt","a");
      // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_stop_read.txt","a");
      $timeformat(-9,2,"ns",20);
      `uvm_info(get_type_name(),"body SIMPLE FULL MASTER SEQ", UVM_LOW)

      read_file();

      paf_it = psolaf_axi_full_m_seq_item::type_id::create("paf_it");

////////////////////////////INICIJALIZACIJA
      start_item(paf_it);

      paf_it.constraint_mode(0);
      paf_it.dir_afinit.constraint_mode(1);
      paf_it.init_0.constraint_mode(1);
      paf_it.arready.constraint_mode(1);
      paf_it.rvalid.constraint_mode(1);
      paf_it.awready.constraint_mode(1);
      paf_it.wready.constraint_mode(1);
      paf_it.bvalid.constraint_mode(1);
      paf_it.bresp.constraint_mode(1);
      paf_it.rlast.constraint_mode(1);
      assert(paf_it.randomize());

      $fdisplay(fd,"paf_it posle prve radnomizacije %s",paf_it.sprint());
      $fdisplay(fd,"paf_it constraint mode init_0 %0d",paf_it.init_0.constraint_mode());
      $fdisplay(fd,"paf_it constraint mode dir_afinit %0d",paf_it.dir_afinit.constraint_mode());
      $fdisplay(fd,"paf_it constraint mode dir_afar %0d",paf_it.dir_afar.constraint_mode());
      $fdisplay(fd,"paf_it constraint mode arready %0d",paf_it.arready.constraint_mode());

      finish_item(paf_it);

      get_response(paf_it);

      $fdisplay(fd,"paf_it %s",paf_it.sprint());
      $fdisplay(fd,"posle get_response paf_it %t",$time);

      stop_read = 0;
      stop_write = 0;

      do begin
            //CITANJE M podataka
            $display("Prvo CITANJE M podataka 9_sep %t",$time);
            $display("pre citanja M podataka end_flag_read 9_sep = %d %t",end_flag_read,$time);
            read_axi_up_to_128();  
            $display("posle citanja M podataka end_flag_read 9_sep = %d %t",end_flag_read,$time);
      end while(end_flag_read != 1);


      //CITANJE prvog elementa od M
      $display("CITANJE prvog elementa od M 9_sep %t",$time);
      read_axi_up_to_128();

      //CITANJE poslednjeg elementa od M
      $display("CITANJE poslednjeg elementa od M 9_sep %t",$time);
      read_axi_up_to_128();

      do begin

            read_cnt_print = 0;
            do begin
                  //CITANJE M podataka za matk
                  $display("CITANJE M podataka za matk 9_sep %t",$time);
                  read_axi_up_to_128();  
                  $display("stop_read while 9_sep = %d %t",stop_read,$time);
                  $display("end_flag_read while 9_sep = %d %t",end_flag_read,$time);
                  $display("M read_cnt_print 9_sep = %0d %t",read_cnt_print,$time);
                  $display("Kraj CITANJA M podataka 9_sep %t",$time);

                  read_cnt_print = read_cnt_print + 1;

            end while(end_flag_read != 1);


            //$fdisplay(fd1,"read_cnt_print = %0d %t",read_cnt_print,$time);

            //CITANJE opseg_set -> opseg
            $display("CITANJE priprema za han k = 0 9_sep %t",$time);
            read_axi_up_to_128();

            //CITANJE opseg -> start_han -> han
            $display("CITANJE priprema za han k = 1 9_sep %t",$time);
            read_axi_up_to_128();

            //CITANJE data_available dobija vrednost i end_flag pada na 0
            $display("CITANJE priprema za han k = 2 9_sep %t",$time);
            read_axi_up_to_128();

            // just_read_ready = 0;

            // read_cnt_print = 0;
            do begin
                  //CITANJE HAN podataka
                  $display("CITANJE HAN podataka  9_sep %t",$time);
                  read_axi_up_to_128(); 

                  $display("HAN end_flag_read while 9_sep = %d %t",end_flag_read,$time);
                  $display("HAN read_cnt_print 9_sep = %0d %t",read_cnt_print,$time);
                  $display("HAN Kraj CITANJA HAN podataka 9_sep %t",$time);

                  read_cnt_print = read_cnt_print + 1; 
            end while(end_flag_read != 1);

            // //priprema za opseg memoriju
            $display("CITANJE priprema za opseg memoriju 9_sep %t",$time);
            read_axi_up_to_128();


            // just_read_ready = 25;

            // read_cnt_print = 0;
            do begin
                  //CITANJE IN podataka
                  $display("CITANJE IN podataka 9_sep  %t",$time);
                  
                  read_axi_up_to_128(); 
                  $display("stop_read while 9_sep = %d %t",stop_read,$time);
                  $display("end_flag_read while 9_sep = %d %t",end_flag_read,$time);
                  $display("IN read_cnt_print 9_sep = %0d %t",read_cnt_print,$time);
                  $display("Kraj CITANJA IN podataka 9_sep  %t",$time);
                  read_cnt_print = read_cnt_print + 1; 
            end while(end_flag_read != 1);

            // $display("CITANJE i pisanje priprema adrese za citanje i upis u MEM_OUT  %t",$time);
            //IZMENA 19. jun 2024
            write_addr_setup();

            //citanje i upis u MEM_OUT
            read_cnt_print = 0;
            do begin
                  $display("PISANJE I CITANJE out podataka 9_sep %t",$time);

                  write_read_out_up_to_128();

                  $display("stop_read while 9_sep = %d %t",stop_read,$time);
                  $display("end_flag_read while 9_sep = %d %t",end_flag_read,$time);
                  $display("MEM_OUT read_cnt_print 9_sep = %0d %t",read_cnt_print,$time);
                  read_cnt_print = read_cnt_print + 1;
                  $display("read_cnt_print 9_sep = %d  %t",read_cnt_print,$time);
                  $display("kraj PISANJE I CITANJE out podataka 9_sep %t",$time);
                  $display("while petljastop_write 9_sep = %0d %t",stop_write,$time);
                  $fdisplay(fd1,"stop_write 9_sep = %0d %t",stop_write,$time);

                  $fdisplay(fd1,"============================================== ",);
            end while(stop_write != 1);

            $fdisplay(fd1,"stop_write nakon out upisa = %0d %t",stop_write,$time);
            $fdisplay(fd1,"============================================== ",);

            $display("CITANJE priprema adrese za matk  %t",$time);
            read_axi_up_to_128();

      end while(ready_psolaf != 1);


      $fclose(fd);
      //Ovde treba da nastavim vise uvm_do_with komandi ili da pravim posebne fajlove koji ce 
      //se zvati kao simple seq2  
   endtask : body

   
endclass : psolaf_axi_full_m_simple_seq

function bit[C_M00_AXI_DATA_WIDTH -1 : 0] psolaf_axi_full_m_simple_seq::fp32_to_fixed(input bit [C_M00_AXI_DATA_WIDTH -1 : 0] fl);
      //bit [C_S00_AXI_DATA_WIDTH -1 : 0] expo; 
      //bit [C_S00_AXI_DATA_WIDTH -1 : 0] mant; 
      //bit [C_S00_AXI_DATA_WIDTH -1 : 0] shift; 
      int expo;
      int mant,sign;
      int shift;
      int shifted_right,shifted_left;
      int discard,round,sticky,odd;
      int res;
      bit [C_M00_AXI_DATA_WIDTH -1 : 0] shifted_left_bit;
      expo = (fl >> `FP32_MANT_FRAC_BITS) & `FP32_EXPO_MASK;
      // $display("fl = %b", fl);
      // $display("expo = %b", expo);
      mant = expo ? ((fl & `FP32_MANT_MASK) | `FP32_MANT_INT_BIT) : 0;
      // $display("mant = %b", mant);
      sign = fl & `FP32_SIGN_BIT;
      // $display("sign = %b", sign);
      shift = (expo - `FP32_EXPO_BIAS) - `FRAC_BITS_DIFF;
      //shift = -5;
      // $display("shift = %b", shift);
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
      // $display("res = %b", res);

      return (sign < 0) ? (-res) : res;
endfunction : fp32_to_fixed

task psolaf_axi_full_m_simple_seq::read_file(); 
      int fd,fd1,fd2,fd3;
      int val;
      real val_in;
      string str;
      
      int i = 0;
      fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/9_sep_2024_script/debug_txt/debugM2_yoSVDriver.txt","w");
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/esl/vhdl/txt_source/debugM2_yo33.txt","r");
      // fd3 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/esl/vhdl/txt_source/debugIn_yo33.txt","r");
      // fd2 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debugIn_yo_SVDriver.txt","w");
      // fd = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/esl/vhdl/txt_source/",input_m,".txt"},"r");
      // fd3 = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/esl/vhdl/txt_source/",input_in_cfg,".txt"},"r");
      // fd = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/esl/vhdl/txt_source/",input_m_cfg,".txt"},"r");
      
      // fd = $fopen({"/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/esl/vhdl/txt_source/",input_m_cfg,".txt"},"r");
      fd3 = $fopen({"../../../../../../esl/vhdl/txt_source/",input_in_cfg,".txt"},"r");
      fd = $fopen({"../../../../../../esl/vhdl/txt_source/",input_m_cfg,".txt"},"r");
      
                  //   /media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/test_psolaf
      if(fd)
            $display("input_m_cfg file was open successfully %0d =====================================================",fd);
      else
            $display("input_m_cfg file was NOT open successfully %0d =====================================================",fd);
      

      
      
      // input_in_m_seq = input_in_top;
      $display("read_file Argument 1 input_in : %s", input_in_cfg);
      $display("read_file Argument 2 input_m : %s", input_m_cfg);

      while($fscanf(fd3,"%s = %2.25f",str,val_in) == 2) begin
            MEM_IN[i] = $shortrealtobits(val_in);
            i++;
      end
      
      i = 0;

      while($fscanf(fd,"%s = %d",str,val) == 2) begin
            MEM_M[i] = val;
            i++;
      end

      foreach(MEM_M[i])begin
            $fdisplay(fd1,"%d",MEM_M[i]);
      end

      foreach(MEM_IN[i])begin
            $fdisplay(fd2,"%b",MEM_IN[i]);
      end

      //$display("pise %s = %d",str,val);
      $fclose(fd);
      $fclose(fd1);
      $fclose(fd2);
      $fclose(fd3);
endtask : read_file

task psolaf_axi_full_m_simple_seq::read_axi_up_to_128();
      
      int fd,fd1;
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_read_axi_full.txt","a");
      // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_read_axi_full_han.txt","a");

////////////////////////////CITANJE ADRESE prvog elementa od M
      stop_read = 0;

      start_item(paf_it);



      paf_it.dir_afinit.constraint_mode(0);
      paf_it.dir_afar.constraint_mode(1);
      paf_it.dir_afread.constraint_mode(0);
      paf_it.dir_af_write_read.constraint_mode(0);
      paf_it.dir_af_write_read_addr.constraint_mode(0);
      paf_it.dir_af_write_read_single.constraint_mode(0);
      paf_it.dir_af_write_addr_setup.constraint_mode(0);

      $display("paf_it.dir_afar.constraint_mode(1); %t",$time);

      assert(paf_it.randomize());

      finish_item(paf_it);
      get_response(paf_it);

////////////////////////////CITANJE prvog elementa od M
      $display("SAMO CITANJE==============================================  9_sep %t",$time);
      rdata_cnt = 0;
      mem_addr = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB];
      en_code = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 1) : (C_M00_AXI_ADDR_WIDTH - 2)];

      $display("en_code 9_sep = %d %t",en_code,$time);
      k = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB] + paf_it.m00_axi_arlen_s;
      $display("k citanje 9_sep = %d %t",k,$time);
      $display("paf_it.m00_axi_araddr_s 9_sep = %d %t",paf_it.m00_axi_araddr_s,$time);
      $display("stop_read 9_sep = %d %t",stop_read,$time);
      if(paf_it.m00_axi_arlen_s < (C_M00_AXI_BURST_LEN - 1))begin
            $display("stop_read unutar ifa 9_sep = %d %t",stop_read,$time);
            stop_read = 1;
            $display("stop_read unutar ifa = %d %t",stop_read,$time);
      end

      for(int b = mem_addr;b <= k;b++)begin
            rdata_cnt = b;
            start_item(paf_it);

            paf_it.dir_afinit.constraint_mode(0);
            paf_it.dir_afar.constraint_mode(0);
            paf_it.dir_afread.constraint_mode(1);
            paf_it.dir_af_write_read_addr.constraint_mode(0);
            paf_it.dir_af_write_read.constraint_mode(0);
            paf_it.dir_af_write_read_single.constraint_mode(0);
            paf_it.dir_af_write_addr_setup.constraint_mode(0);
            $display("paf_it.dir_afread.constraint_mode(1); %t",$time);

            $display("b = %d %t",b,$time);
            $display("k citanje unutar fora 9_sep = %d %t",k,$time);
            $fdisplay(fd,"b = %d %t",b,$time);
            $fdisplay(fd,"k = %d %t",k,$time);
            $fdisplay(fd,"paf_it constraint mode rlast %0d",paf_it.rlast.constraint_mode());

            case(en_code)
                  //2'00 :
                  0 :begin
                        paf_it.m00_axi_rdata_s = MEM_M[b];
                        $display("MEM_M[b] 9_sep = %d %t",MEM_M[b],$time);
                  end
                  //2'10 :
                  1 :
                        // paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[b],1);

                        paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[b],2);
                  2 :begin
                        $fdisplay(fd1,"MEM_HAN[%0d] %0b",b,fp32_to_fixed_han(MEM_HAN[b],0));
                        paf_it.m00_axi_rdata_s = fp32_to_fixed_han_debug(MEM_HAN[b],0);
                  end
                  default :
                        paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_OUT[b],1);      
            endcase
            

            assert(paf_it.randomize());

            finish_item(paf_it);
            get_response(paf_it);

            $fdisplay(fd,"============================================================ %t",$time);

            $display("KRAJ SAMO CITANJA/////////////////////////////////////  %t",$time);
      end


endtask : read_axi_up_to_128

task psolaf_axi_full_m_simple_seq::write_read_out_up_to_128();
      
      int fd1,fd,fd2,fd3,fd4;
      // fd1 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_write_read_axi_full.txt","a");
      // fd = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_PISANJE_write_read_axi_full.txt","a");
      // fd2 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_MEM_OUT_simple_seq.txt","a");
      // fd3 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_write_read_redosled.txt","a");
      // fd4 = $fopen("/media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/jan_23_rucno/debug_txt/debug_stop_write.txt","a");

////////////////////////////CITANJE ADRESE prvog elementa od M
      stop_write = 0;
      
      start_item(paf_it);

      $display("PISANJE I CITANJE posle start_item(paf_it) 9_sep %t",$time);

      paf_it.dir_afinit.constraint_mode(0);
      paf_it.dir_afar.constraint_mode(0);
      paf_it.dir_afread.constraint_mode(0);
      paf_it.dir_af_write_read_addr.constraint_mode(1);
      paf_it.dir_af_write_read.constraint_mode(0);
      paf_it.dir_af_write_read_single.constraint_mode(0);
      paf_it.dir_af_write_addr_setup.constraint_mode(0);
      $display("paf_it.dir_af_write_read_addr.constraint_mode(1); 9_sep %t",$time);

      $display("PISANJE I CITANJE pre paf_it.randomize() 9_sep %t",$time);
      
      assert(paf_it.randomize());
       $display("PISANJE I CITANJE posle paf_it.randomize() 9_sep %t",$time);


      $display("PISANJE I CITANJE pre finish_item(paf_it); 9_sep %t",$time);
      finish_item(paf_it);
      $display("PISANJE I CITANJE posle finish_item(paf_it); 9_sep  %t",$time);
      get_response(paf_it);
      $display("PISANJE I CITANJE posle get_response(paf_it); 9_sep %t",$time);

////////////////////////////CITANJE prvog elementa od M
      $display("PISANJE I CITANJE==============================================  %t",$time);
      rdata_cnt = 0;
      wdata_cnt = 0;

      mem_addr = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB];
      en_code = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 1) : (C_M00_AXI_ADDR_WIDTH - 2)];
      $display("mem_addr 9_sep = %d %t",mem_addr,$time);
      $display("en_code 9_sep = %d %t",en_code,$time);

      mem_addr_wr = paf_it.m00_axi_awaddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB];
      en_code_wr = paf_it.m00_axi_awaddr_s[(C_M00_AXI_ADDR_WIDTH - 1) : (C_M00_AXI_ADDR_WIDTH - 2)];
      $display("mem_addr_wr 9_sep = %d %t",mem_addr_wr,$time);
      $display("en_code_wr 9_sep = %d %t",en_code_wr,$time);

      k = paf_it.m00_axi_awaddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB] + paf_it.m00_axi_awlen_s;
      $display("write_read_out_up_to_128 paf_it.m00_axi_awaddr_s 9_sep = %h %t",paf_it.m00_axi_awaddr_s,$time);
      $display("write_read_out_up_to_128 paf_it.m00_axi_awlen_s 9_sep = %d %t",paf_it.m00_axi_awlen_s,$time);
      $display("write_read_out_up_to_128 9_sep k = %d %t",k,$time);

      if(paf_it.m00_axi_awlen_s < (C_M00_AXI_BURST_LEN - 1))begin
            stop_write = 1;
            $display("write_read_out_up_to_128 stop_write 9_sep = %d %t",stop_write,$time);


      end;

      ra = mem_addr;

      //Izmena 6. juna 2024
      if(paf_it.m00_axi_awlen_s == 0)begin
            for(wa = mem_addr_wr;wa <= k;wa++)begin

                  $display("PISANJE I CITANJE paf_it.m00_axi_awlen_s == 0/////////////////////////////////////  %t",$time);
                  wdata_cnt = wa;
                  rdata_cnt = wa;

                  start_item(paf_it);
                  $display("single wa 9_sep = %d %t",wa,$time);
                  $display("single ra 9_sep = %d %t",ra,$time);
                  $display("single k 9_sep = %d %t",k,$time);
                  
                  

                  paf_it.dir_afinit.constraint_mode(0);
                  paf_it.dir_afar.constraint_mode(0);
                  paf_it.dir_afread.constraint_mode(0);
                  paf_it.dir_af_write_read_addr.constraint_mode(0);
                  paf_it.dir_af_write_read.constraint_mode(0);
                  paf_it.dir_af_write_read_single.constraint_mode(1);
                  paf_it.dir_af_write_addr_setup.constraint_mode(0);
                  $display("paf_it.dir_af_write_read_single.constraint_mode(1); 9_sep %t",$time);

                  $display("single en_code 9_sep = %d", en_code);
                  case(en_code)
                        //2'00 :
                        0 :
                              paf_it.m00_axi_rdata_s = MEM_M[ra];
                        //2'10 :
                        1 : begin
                              // paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[ra],1);

                              paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[ra],2);
                        end
                        2 :
                              paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_HAN[ra],0);
                        default : begin
                              $display("read_signle_MEM_OUT[%d] = %h", ra,fp32_to_fixed_han(MEM_OUT[ra],1));
                              paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_OUT[ra],1);  

                        end
                  endcase

 
                  assert(paf_it.randomize());
                  $display("single nakon paf_it.randomize(); 9_sep %t",$time);
                  
                  finish_item(paf_it);
                  $display("single nakon finish_item(paf_it); 9_sep %t",$time);

                  get_response(paf_it);
                  $display("single nakon get_response(paf_it); 9_sep %t",$time);

                  $display("single en_code_wr = %d", en_code_wr);
                  case(en_code_wr)
                        0 : begin
                              $display("write_read_out_up_to_128 m00_axi_awlen_s = 0 MEM_M[%d] %d 9_sep %t",wa,paf_it.m00_axi_wdata_s,$time);
                              MEM_M[wa] = paf_it.m00_axi_wdata_s;
                        end
                        1 : begin
                              MEM_IN[wa] = paf_it.m00_axi_wdata_s;
                        end
                        default : begin
                              MEM_OUT[wa] = paf_it.m00_axi_wdata_s;  
                              $display("write_single_MEM_OUT[%d] = %h", wa,paf_it.m00_axi_wdata_s);
                        end    
                  endcase

                  ra++;
                  $display("ra nakon ra++ 9_sep = %d %t",ra,$time);
                  $display("KRAJ PISANJA I CITANJA paf_it.m00_axi_awlen_s 9_sep  == 0/////////////////////////////////////  %t",$time);
            end
      end else begin
      
            for(wa = mem_addr_wr;wa <= k;wa++)begin

                  wdata_cnt = wa;
                  rdata_cnt = wa;
                  $display("wdata_cnt = %d %t",wdata_cnt,$time);
                  $display("rdata_cnt = %d %t",rdata_cnt,$time);

                  start_item(paf_it);
                  $display("wa = %d %t",wa,$time);
                  $display("ra = %d %t",ra,$time);
                  $display("k = %d %t",k,$time);

                  
                  paf_it.dir_afinit.constraint_mode(0);
                  paf_it.dir_afar.constraint_mode(0);
                  paf_it.dir_afread.constraint_mode(0);
                  paf_it.dir_af_write_read_addr.constraint_mode(0);
                  paf_it.dir_af_write_read.constraint_mode(1);
                  paf_it.dir_af_write_read_single.constraint_mode(0);
                  paf_it.dir_af_write_addr_setup.constraint_mode(0);
                  $display("paf_it.dir_af_write_read.constraint_mode(1); %t",$time);

                  // citanje prvog elemnta ako moze da bude ranije ili da podesis bolje upis jer 
                  // se ne poklapaju tajminzi
                  
                  $display("en_code = %d", en_code);
                  case(en_code)
                        0 :
                              paf_it.m00_axi_rdata_s = MEM_M[ra];
                        1 : begin
                              // paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[ra],1);

                              paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[ra],2);
                        end
                        2 :
                              paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_HAN[ra],0);
                        default : begin
                              $display("read_MEM_OUT[%d] = %h", ra,fp32_to_fixed_han(MEM_OUT[ra],1));
                              $display("bez fp32_to_fixed_han read_MEM_OUT[%d] = %h", ra,MEM_OUT[ra]);
                              paf_it.m00_axi_rdata_s = MEM_OUT[ra];     
                        end
                  endcase
                  
                  assert(paf_it.randomize());
                  $display("write_read_out_up_to_128 posle paf_it.randomize()  %t",$time);
                  
                  finish_item(paf_it);
                  $display("write_read_out_up_to_128 posle finish_item(paf_it);  %t",$time);

                  get_response(paf_it);

                  $display("write_read_out_up_to_128 posle get_response(paf_it);  %t",$time);

                  $display("en_code_wr = %d", en_code_wr);
                  mem_wr_s = paf_it.m00_axi_wready_s && paf_it.m00_axi_wvalid_s;
                  $display("paf_it.m00_axi_wready_s = %h", paf_it.m00_axi_wready_s);
                  $display("paf_it.m00_axi_wvalid_s = %h", paf_it.m00_axi_wvalid_s);
                  case(en_code_wr)
                        0 : begin
                              $display("write_read_out_up_to_128 MEM_M[%d] %d 9_sep %t",wa,paf_it.m00_axi_wdata_s,$time);
                              MEM_M[wa] = paf_it.m00_axi_wdata_s;
                        end
                        1 : begin
                              MEM_IN[wa] = paf_it.m00_axi_wdata_s;
                        end
                        default : begin
                              $display("write_MEM_OUT[%d] = %h", wa,paf_it.m00_axi_wdata_s);
                              $display("mem_wr_s = %h", mem_wr_s);
                              if(mem_wr_s == 1 )begin
                                    MEM_OUT[wa] = paf_it.m00_axi_wdata_s;  
                              end
                        end    
                  endcase

                  ra++;
                  $display("ra nakon ra ++ = %d %t",ra,$time);

                  $display("KRAJ PISANJA I CITANJA/////////////////////////////////////  %t",$time);
            end

      end;
      



endtask : write_read_out_up_to_128


task psolaf_axi_full_m_simple_seq::write_addr_setup();

      start_item(paf_it);


      paf_it.dir_afinit.constraint_mode(0);
      paf_it.dir_afar.constraint_mode(0);
      paf_it.dir_afread.constraint_mode(0);
      paf_it.dir_af_write_read_addr.constraint_mode(1);
      paf_it.dir_af_write_read.constraint_mode(0);
      paf_it.dir_af_write_read_single.constraint_mode(0);
      paf_it.dir_af_write_addr_setup.constraint_mode(0);
      $display("paf_it.dir_af_write_read_addr.constraint_mode(1); 9_sep %t",$time);

      assert(paf_it.randomize());
      $display("posle paf_it.randomize(); 9_sep %t",$time);
      
      finish_item(paf_it);
      $display("posle finish_item(paf_it); 9_sep %t",$time);
      get_response(paf_it);
      $display("posle get_response(paf_it); 9_sep %t",$time);

////////////////////////////CITANJE prvog elementa od M
      // $fdisplay(fd1,"pre rdata_cnt = 0 write_read %t",$time);
      $display("PISANJE I CITANJE 9_sep ==============================================   %t",$time);
      rdata_cnt = 0;
      wdata_cnt = 0;

      mem_addr = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB];
      en_code = paf_it.m00_axi_araddr_s[(C_M00_AXI_ADDR_WIDTH - 1) : (C_M00_AXI_ADDR_WIDTH - 2)];
      $display("as mem_addr 9_sep = %d %t",mem_addr,$time);
      $display("as en_code 9_sep = %d %t",en_code,$time);

      mem_addr_wr = paf_it.m00_axi_awaddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB];
      en_code_wr = paf_it.m00_axi_awaddr_s[(C_M00_AXI_ADDR_WIDTH - 1) : (C_M00_AXI_ADDR_WIDTH - 2)];

      $display("as mem_addr_wr 9_sep = %d %t",mem_addr_wr,$time);
      $display("as en_code_wr 9_sep = %d %t",en_code_wr,$time);


      k = paf_it.m00_axi_awaddr_s[(C_M00_AXI_ADDR_WIDTH - 3) : ADDR_LSB] + paf_it.m00_axi_awlen_s;
      $display("as paf_it.m00_axi_awaddr_s 9_sep = %h %t",paf_it.m00_axi_awaddr_s,$time);
      $display("as paf_it.m00_axi_awlen_s 9_sep = %d %t",paf_it.m00_axi_awlen_s,$time);
      $display("as k = %d %t",k,$time);

      if(paf_it.m00_axi_awlen_s < (C_M00_AXI_BURST_LEN - 1))begin
            stop_write = 1;
            $display("addr setup stop_write 9_sep = %d %t",stop_write,$time);
      end;

      ra = mem_addr;


      for(wa = mem_addr_wr;wa <= k;wa++)begin
            wdata_cnt = wa;
            rdata_cnt = wa;

            start_item(paf_it);
            $display("as wa 9_sep = %d %t",wa,$time);
            $display("as ra 9_sep = %d %t",ra,$time);
            $display("as k 9_sep = %d %t",k,$time);

            paf_it.dir_afinit.constraint_mode(0);
            paf_it.dir_afar.constraint_mode(0);
            paf_it.dir_afread.constraint_mode(0);
            paf_it.dir_af_write_read_addr.constraint_mode(0);
            paf_it.dir_af_write_read.constraint_mode(0);
            paf_it.dir_af_write_read_single.constraint_mode(0);
            paf_it.dir_af_write_addr_setup.constraint_mode(1);

            $display("as en_code 9_sep = %d", en_code);
            case(en_code)
                  0 :
                        paf_it.m00_axi_rdata_s = MEM_M[ra];
                  1 : begin
                        // paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[ra],1);

                        paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_IN[ra],2);
                  end
                  2 :
                        paf_it.m00_axi_rdata_s = fp32_to_fixed_han(MEM_HAN[ra],0);
                  default : begin
                        $display("as read_MEM_OUT[%d] 9_sep = %h", ra,fp32_to_fixed_han(MEM_OUT[ra],1));
                        $display("as bez fp32_to_fixed_han read_MEM_OUT[%d] 9_sep = %h", ra,MEM_OUT[ra]);
                        paf_it.m00_axi_rdata_s = MEM_OUT[ra];     
                  end
            endcase


            $display("as posle case en_code pre randomize 9_sep %t",$time);
            
            assert(paf_it.randomize());

            $display("as paf_it write_read posle randomizacije 9_sep %t",$time);

            $display("as posle randomize pre finish_item 22222 9_sep %t",$time);
            
            finish_item(paf_it);
            $display("as posle finish_item pre get_response 22222 9_sep %t",$time);
            
            get_response(paf_it);
            $display("as paf_it write_read posle get_response 9_sep %t",$time);

            $display("as en_code_wr = %d", en_code_wr);
            mem_wr_s = paf_it.m00_axi_wready_s && paf_it.m00_axi_wvalid_s;
            $display("as paf_it.m00_axi_wready_s 9_sep = %h", paf_it.m00_axi_wready_s);
            $display("as paf_it.m00_axi_wvalid_s 9_sep = %h", paf_it.m00_axi_wvalid_s);
            case(en_code_wr)
                  0 : begin
                        $display("write_addr_setup MEM_M[%d] %d 9_sep %t",wa,paf_it.m00_axi_wdata_s,$time);

                        // MEM_M[wa] = paf_it.m00_axi_wdata_s;
                  end
                  1 : begin
                        MEM_IN[wa] = paf_it.m00_axi_wdata_s;
                  end
                  default : begin
                        $display("write_MEM_OUT[%d] 9_sep = %h", wa,paf_it.m00_axi_wdata_s);
                        $display("mem_wr_s 9_sep = %h", mem_wr_s);

                        $display("PRESIPANJE 9_sep = %h",MEM_OUT[wa] );
                        if(mem_wr_s == 1 )begin
                              MEM_OUT[wa] = MEM_OUT[wa];  
                        end

                  end    
            endcase


            ra++;
            $display("as ra nakon ra ++ 9_sep = %d %t",ra,$time);
            
            $display("KRAJ addr setup PISANJA I CITANJA/////////////////////////////////////  9_sep %t",$time);
      end

            $display("KRAJ write addr setup/////////////////////////////////////  %t",$time);
endtask : write_addr_setup


`endif
