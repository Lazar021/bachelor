`ifndef PSOLAF_AXI_SL_ENV_SV
 `define PSOLAF_AXI_SL_ENV_SV


class psolaf_axi_sl_env extends uvm_env;

  psolaf_axi_sl_agent psolaf_slave_agent;
  psolaf_axi_sl_config psolaf_slave_cfg;

  psolaf_axi_full_m_agent psolaf_master_agent;
  psolaf_axi_full_m_config psolaf_master_cfg;

  psolaf_scoreboard psolaf_scbd;

  //arguments
  string input_in_arg1;
  string input_m_arg2;
  real alpha_top_arg7;
  real beta_top_arg8;
  real gamma_top_arg9;
  real gamma_rec_top_arg12;
  int m_size_top_arg10;
  int in_size_top_arg11;
  
  virtual interface psolaf_if vif;
  `uvm_component_utils (psolaf_axi_sl_env)

  function new(string name = "psolaf_axi_sl_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    /************Geting from configuration database*******************/
    if (!uvm_config_db#(virtual psolaf_if)::get(this, "", "psolaf_if", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
    
    if(!uvm_config_db#(psolaf_axi_sl_config)::get(this, "", "psolaf_axi_sl_config", psolaf_slave_cfg))
      `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    //master
    if(!uvm_config_db#(psolaf_axi_full_m_config)::get(this, "", "psolaf_axi_full_m_config", psolaf_master_cfg))
      `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    //arg 1
    if (!uvm_config_db#(string)::get(this, "", "input_in_top", input_in_arg1))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument input_in must be set:",get_full_name(),".arg"})
    //arg 2
    if (!uvm_config_db#(string)::get(this, "", "input_m_top", input_m_arg2))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument input_m must be set:",get_full_name(),".arg"})
    //arg 7
    if (!uvm_config_db#(real)::get(this, "", "alpha_top", alpha_top_arg7))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument alpha_top must be set:",get_full_name(),".arg"})
    $display("psolaf_axi_sl_env alpha_top_arg7 : %f", alpha_top_arg7);
    //arg 8
    if (!uvm_config_db#(real)::get(this, "", "beta_top", beta_top_arg8))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument beta_top must be set:",get_full_name(),".arg"})
    $display("psolaf_axi_sl_env beta_top_arg8 : %f", beta_top_arg8);
    //arg 9
    if (!uvm_config_db#(real)::get(this, "", "gamma_top", gamma_top_arg9))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument gamma_top must be set:",get_full_name(),".arg"})
    $display("psolaf_axi_sl_env gamma_top_arg9 : %f", gamma_top_arg9);
    //arg 12
    if (!uvm_config_db#(real)::get(this, "", "gamma_rec_top", gamma_rec_top_arg12))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument gamma_rec_top must be set:",get_full_name(),".arg"})
    $display("psolaf_axi_sl_env gamma_rec_top_arg12 : %f", gamma_rec_top_arg12);
    //arg 10
    if (!uvm_config_db#(int)::get(this, "", "m_size_top", m_size_top_arg10))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument m_size_top must be set:",get_full_name(),".arg"})
    $display("psolaf_axi_sl_env m_size_top_arg10 : %d", m_size_top_arg10);
    //arg 11
    if (!uvm_config_db#(int)::get(this, "", "in_size_top", in_size_top_arg11))
      `uvm_fatal("NOARG",{"psolaf_axi_sl_env Argument in_size_top must be set:",get_full_name(),".arg"})
    $display("psolaf_axi_sl_env in_size_top_arg11 : %d", in_size_top_arg11);
    /*****************************************************************/
    // setting slave_config fields
    psolaf_slave_cfg.alpha = alpha_top_arg7;
    psolaf_slave_cfg.beta = beta_top_arg8;
    psolaf_slave_cfg.gamma = gamma_top_arg9;
    psolaf_slave_cfg.gamma_rec = gamma_rec_top_arg12;
    psolaf_slave_cfg.m_size = m_size_top_arg10;
    psolaf_slave_cfg.in_size = in_size_top_arg11;
    psolaf_slave_cfg.set_config();

    // setting master_config fields
    psolaf_master_cfg.input_in = input_in_arg1;
    psolaf_master_cfg.input_m = input_m_arg2;
    psolaf_master_cfg.set_config();


    psolaf_slave_agent = psolaf_axi_sl_agent::type_id::create("psolaf_slave_agent", this);
    //
    psolaf_master_agent = psolaf_axi_full_m_agent::type_id::create("psolaf_master_agent", this);
    /************Setting to configuration database********************/
    uvm_config_db#(psolaf_axi_sl_config)::set(this, "psolaf_slave_agent", "psolaf_axi_sl_config", psolaf_slave_cfg);
    uvm_config_db#(psolaf_axi_full_m_config)::set(this, "psolaf_master_agent", "psolaf_axi_full_m_config", psolaf_master_cfg);
    uvm_config_db#(virtual psolaf_if)::set(this, "*", "psolaf_if", vif);

    /*****************************************************************/

    psolaf_scbd = psolaf_scoreboard::type_id::create("psolaf_scoreboard",this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    psolaf_master_agent.mon.item_collected_port_full.connect(psolaf_scbd.item_collected_imp_full);

    psolaf_slave_agent.mon_sl.item_collected_port_lite.connect(psolaf_scbd.item_collected_imp_lite);
    `uvm_info(get_type_name(),"connect_phase psolaf_axi_sl_env============", UVM_LOW)
  endfunction
endclass : psolaf_axi_sl_env

`endif
