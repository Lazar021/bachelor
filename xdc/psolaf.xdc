create_clock -period 10.000 -name s00_axi_aclk -waveform {0.000 5.000} [get_ports s00_axi_aclk]
create_clock -period 10.000 -name m00_axi_aclk -waveform {0.000 5.000} [get_ports m00_axi_aclk]

#set_property RETIMING TRUE [current_design]
#set_property DSP_Usage Auto [current_design]

#set_max_fanout 10 [get_nets dx_next]
#set_max_fanout 10 [get_nets dx_reg]

#set_property LOC SLICE_X2Y5 [get_cells dy_reg_reg[1]]
#set_property LOC SLICE_X3Y5 [get_cells DSP_A_B_DATA_INST]


set_clock_latency -source -early 0.0 [get_clocks s00_axi_aclk]
set_clock_latency -source -early 0.0 [get_clocks m00_axi_aclk]
set_clock_latency -source -late 0.0 [get_clocks s00_axi_aclk]
set_clock_latency -source -late 0.0 [get_clocks m00_axi_aclk]

#constrains for no_input_delay warning

set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_aresetn ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_arready ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_awready ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_bvalid ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_init_axi_txn ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_rdata* ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_rlast ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_rvalid ]
set_input_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_wready ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_araddr* ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_aresetn ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_arvalid ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_awaddr* ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_awvalid ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_bready ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_rready ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_wdata* ]
set_input_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_wvalid ]

#constrains for no_output_delay warning

set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_araddr* ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_arlen* ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_arvalid ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_awaddr* ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_awlen* ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_awvalid ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_bready ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_rready ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_wdata* ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_wlast ]
set_output_delay -clock m00_axi_aclk 0.0 [get_ports m00_axi_wvalid ]
set_output_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_arready ]
set_output_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_awready ]
set_output_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_bvalid ]
set_output_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_rdata* ]
set_output_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_rvalid ]
set_output_delay -clock s00_axi_aclk 0.0 [get_ports s00_axi_wready ]


