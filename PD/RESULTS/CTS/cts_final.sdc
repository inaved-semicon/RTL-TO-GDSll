###############################################################################
# Created by write_sdc
# Fri Jun 26 07:26:07 2026
###############################################################################
current_design router_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clock -period 10.0000 [get_ports {clock}]
set_clock_uncertainty -setup 0.2000 clock
set_clock_uncertainty -hold 0.1000 clock
set_propagated_clock [get_clocks {clock}]
create_clock -name tck -period 100.0000 [get_ports {tck}]
set_clock_uncertainty -setup 0.2000 tck
set_clock_uncertainty -hold 0.1000 tck
set_propagated_clock [get_clocks {tck}]
set_clock_groups -name group1 -asynchronous \
 -group [get_clocks {clock}]\
 -group [get_clocks {tck}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[0]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[1]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[2]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[3]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[4]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[5]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[6]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_in[7]}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {pkt_valid}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {read_enb_0}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {read_enb_1}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {read_enb_2}]
set_input_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {resetn}]
set_input_delay 1.0000 -clock [get_clocks {tck}] -add_delay [get_ports {tdi}]
set_input_delay 1.0000 -clock [get_clocks {tck}] -add_delay [get_ports {tms}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {busy}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[0]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[1]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[2]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[3]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[4]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[5]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[6]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_0[7]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[0]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[1]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[2]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[3]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[4]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[5]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[6]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_1[7]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[0]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[1]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[2]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[3]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[4]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[5]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[6]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {data_out_2[7]}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {err}]
set_output_delay 1.0000 -clock [get_clocks {tck}] -add_delay [get_ports {tdo}]
set_output_delay 1.0000 -clock [get_clocks {tck}] -add_delay [get_ports {tdo_paden_o}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {vld_out_0}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {vld_out_1}]
set_output_delay 1.0000 -clock [get_clocks {clock}] -add_delay [get_ports {vld_out_2}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
