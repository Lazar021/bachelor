# command-line arguments
set (input_in_0) "debugIn_yo33"
set (input_m_0) "debugM2_yo33"
set (output_iniGr_0) "debugIniGrYo2"
set (output_write_out_0) "debugOutSvakiProlazYo2"
set (output_read_out_0) "debugOutReadSvakiProlazYo2"
set (check_pit_0) "debugPitYo2"
set (alpha_0) 1.3
# set (beta_0) 0.8
set (beta_0) 1.25
set (gamma_0) 1.5
set (gamma_rec_0) 0.666666667
set (m_size_0) 233
set (in_size_0) 27753

set (input_in_1) "debugInDnl"
set (input_m_1) "debugM2Dnl"
set (output_iniGr_1) "debugIniGrDnl"
set (output_write_out_1) "debugOutSvakiProlazDnl"
set (output_read_out_1) "debugOutReadSvakiProlazDnl"
set (check_pit_1) "debugPitDnl"
set (alpha_1) 0.5
# set (beta_1) 1.5
set (beta_1) 0.666666667
set (gamma_1) 1.4
set (gamma_rec_1) 0.714285714
set (m_size_1) 196
set (in_size_1) 28012

set (input_in_2) "debugIn_yo33"
set (input_m_2) "debugM2_yo33"
set (output_iniGr_2) "debugIniGr"
set (output_write_out_2) "debugOutSvakiProlaz"
set (output_read_out_2) "debugOutReadSvakiProlaz"
set (check_pit_2) "debugPit"
set (alpha_2) 0.8
# set (beta_2) 0.5
set (beta_2) 2
set (gamma_2) 1.5
set (gamma_rec_2) 0.666666667
set (m_size_2) 233
set (in_size_2) 27753

set (input_in_3) "debugInB"
set (input_m_3) "debugM2B"
set (output_iniGr_3) "debugIniGrB"
set (output_write_out_3) "debugOutSvakiProlazB"
set (output_read_out_3) "debugOutReadSvakiProlazB"
set (check_pit_3) "debugPitB"
set (alpha_3) 0.5
# set (beta_3) 1.5
set (beta_3) 0.666666667
set (gamma_3) 1.4
set (gamma_rec_3) 0.714285714
set (m_size_3) 274
set (in_size_3) 34688


# for {set i 0} {$i < 4} {incr i} {

    # set input_in $(input_in_$i)
    # set input_m $(input_m_$i)
    # set output_iniGr $(output_iniGr_$i)
    # set output_write_out $(output_write_out_$i) 
    # set output_read_out $(output_read_out_$i) 
    # set check_pit $(check_pit_$i) 
    # set alpha $(alpha_$i)
    # set beta $(beta_$i)
    # set gamma $(gamma_$i) 
    # set m_size $(m_size_$i) 
    # set in_size $(in_size_$i) 

    # set input_in $(input_in_3)
    # set input_m $(input_m_3)
    # set output_iniGr $(output_iniGr_3)
    # set output_write_out $(output_write_out_3) 
    # set output_read_out $(output_read_out_3) 
    # set check_pit $(check_pit_3) 
    # set alpha $(alpha_3)
    # set beta $(beta_3)
    # set gamma $(gamma_3) 
    # set m_size $(m_size_0)

    set input_in $(input_in_1)
    set input_m $(input_m_1)
    set output_iniGr $(output_iniGr_1)
    set output_write_out $(output_write_out_1) 
    set output_read_out $(output_read_out_1) 
    set check_pit $(check_pit_1) 
    set alpha $(alpha_1)
    set beta $(beta_1)
    set gamma $(gamma_1) 
    set gamma_rec $(gamma_rec_1) 
    set m_size $(m_size_1)
    set in_size $(in_size_1)

    set db_name "covdb_0" ;

    # set db_name "covdb_$i" ;
    set xsim_command "set_property -name \{xsim.simulate.xsim.more_options\} -value \{-testplusarg UVM_TESTNAME=test_simple -testplusarg UVM_VERBOSITY=UVM_LOW -testplusarg \
    input_in=$input_in -testplusarg input_m=$input_m -testplusarg output_iniGr=$output_iniGr -testplusarg output_write_out=$output_write_out \
    -testplusarg output_read_out=$output_read_out -testplusarg check_pit=$check_pit -testplusarg alpha=$alpha -testplusarg beta=$beta -testplusarg gamma=$gamma \
    -testplusarg gamma_rec=$gamma_rec -testplusarg m_size=$m_size -testplusarg in_size=$in_size -sv_seed random -runall -cov_db_name $db_name\} -objects \[get_filesets sim_1\]"
    eval $xsim_command
    launch_simulation 

    # run 50 ms
    # run all

        # close_sim

#  }

# /media/milan/VolumeTri/Vivado/funkcionalna_verifikacija/vezbanje/9_sep_2024_script/esl/verif