set resultDir ../../result/test_psolaf
set releaseDir ../../release/test_psolaf
file mkdir $resultDir
file mkdir $releaseDir

create_project test_psolaf $resultDir -part xc7z020clg484-1

set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]

add_files -norecurse ../vhdl/all_design_modules/fixed_pkg_2008.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/fixed_pkg_2008.vhd]
set_property library ieee_proposed [get_files  ../vhdl/all_design_modules/fixed_pkg_2008.vhd]

add_files -norecurse ../vhdl/all_design_modules/hanning.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/hanning.vhd]

add_files -norecurse ../vhdl/all_design_modules/interp1_top.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/interp1_top.vhd]

add_files -norecurse ../vhdl/all_design_modules/mem_double_port_gr.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/mem_double_port_gr.vhd]

add_files -norecurse ../vhdl/all_design_modules/mem_double_port_par1.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/mem_double_port_par1.vhd]

add_files -norecurse ../vhdl/all_design_modules/mem_double_port_par3.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/mem_double_port_par3.vhd]

add_files -norecurse ../vhdl/all_design_modules/mem_interp1_rez.vhd
add_files -norecurse ../vhdl/all_design_modules/mem_matk.vhd

add_files -norecurse ../vhdl/all_design_modules/mem_p.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/mem_p.vhd]

add_files -norecurse ../vhdl/all_design_modules/mem_subsystem.vhd
add_files -norecurse ../vhdl/all_design_modules/mem_w_triple.vhd

add_files -norecurse ../vhdl/all_design_modules/psolaf.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/psolaf.vhd]

add_files -norecurse ../vhdl/all_design_modules/psolaf_axi_v1_0_M00_AXI.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf_axi_v1_0_S00_AXI.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf_axi_v1_0.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf_top.vhd
add_files -norecurse ../vhdl/all_design_modules/utils_pkg.vhd


#Treba drugacije da se unesu fajlovi The error got fixed by changing the compile order
# if 0 {
# add_files -fileset sim_1 -norecurse -scan_for_includes {{/home/lazar/Lazar_fakultet/Fakultet/Funkcionalna verifikacija/vezbe/vezbanje/24_jun_2024/esl/verif/psolaf_verif_top.sv}}

add_files -fileset sim_1 -norecurse ../verif/test_simple.sv
add_files -fileset sim_1 -norecurse ../verif/test_base.sv
add_files -fileset sim_1 -norecurse ../verif/psolaf_verif_top.sv
add_files -fileset sim_1 -norecurse ../verif/psolaf_if.sv
add_files -fileset sim_1 -norecurse ../verif/psolaf_axi_sl_env.sv
add_files -fileset sim_1 -norecurse ../verif/psolaf_axi_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/psolaf_scoreboard.sv


add_files -fileset sim_1 -norecurse ../verif/master_full/master_configurations/master_configuration_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_configurations/psolaf_axi_full_m_config.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_sequences/psolaf_axi_full_m_base_seq.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_sequences/psolaf_axi_full_m_seq_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_sequences/psolaf_axi_full_m_simple_seq.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_agent/psolaf_axi_full_m_seq_item.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_agent/psolaf_axi_full_m_monitor.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_agent/psolaf_axi_full_m_sequencer.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_agent/psolaf_axi_full_m_driver.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_agent/psolaf_axi_full_m_agent.sv
add_files -fileset sim_1 -norecurse ../verif/master_full/master_agent/psolaf_axi_full_m_agent_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Agent/psolaf_axi_sl_agent.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Agent/psolaf_axi_sl_agent_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Agent/psolaf_axi_sl_driver.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Agent/psolaf_axi_sl_monitor.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Agent/psolaf_axi_sl_seq_item.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Agent/psolaf_axi_sl_sequencer.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/configurations/configuration_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/configurations/psolaf_axi_sl_config.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Sequences/psolaf_axi_sl_base_seq.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Sequences/psolaf_axi_sl_seq_pkg.sv
add_files -fileset sim_1 -norecurse ../verif/slave_lite/Sequences/psolaf_axi_sl_simple_seq.sv

# }



add_files -fileset constrs_1 -norecurse ../xdc/psolaf.xdc