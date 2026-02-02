set resultDir ../../result/psolaf
set releaseDir ../../release/psolaf
file mkdir $resultDir
file mkdir $releaseDir

create_project psolaf $resultDir -part xc7z020clg484-1

add_files -norecurse ../vhdl/all_design_modules/fixed_pkg_2008.vhd
set_property library ieee_proposed [get_files  ../vhdl/all_design_modules/fixed_pkg_2008.vhd]

set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/fixed_pkg_2008.vhd]

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
add_files -norecurse ../vhdl/all_design_modules/mem_subsystem.vhd
add_files -norecurse ../vhdl/all_design_modules/mem_w_triple.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf.vhd
set_property file_type {VHDL 2008} [get_files  ../vhdl/all_design_modules/psolaf.vhd]

add_files -norecurse ../vhdl/all_design_modules/psolaf_axi_v1_0.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf_axi_v1_0_M00_AXI.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf_axi_v1_0_S00_AXI.vhd
add_files -norecurse ../vhdl/all_design_modules/psolaf_top.vhd

add_files -norecurse ../vhdl/all_design_modules/utils_pkg.vhd

add_files -fileset sim_1 -norecurse ../vhdl/axi_test_bench/axi_psolaf_tb.vhd

add_files -fileset sim_1 -norecurse ../vhdl/txt_source/debugPrefix_m_tb.txt
add_files -fileset sim_1 -norecurse ../vhdl/txt_source/debugPrefix_in_tb.txt
add_files -fileset sim_1 -norecurse ../vhdl/txt_source/debugM2_do_not_listen33.txt
add_files -fileset sim_1 -norecurse ../vhdl/txt_source/debugIn_do_not_listen33.txt

add_files -fileset constrs_1 -norecurse ../xdc/psolaf.xdc