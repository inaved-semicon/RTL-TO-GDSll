################################################################################
# CLOCK DEFINITIONS
#
# Define all clocks used in the design.
# STA uses these clocks as timing references for setup and hold analysis.
################################################################################

# Functional clock
# Period = 10 ns → Frequency = 100 MHz
create_clock -name clock -period 10 [get_ports clock]

# Clock uncertainty models clock jitter, skew, and modeling inaccuracies
set_clock_uncertainty -setup 0.2 [get_clocks clock]
set_clock_uncertainty -hold  0.1 [get_clocks clock]


################################################################################
# INPUT DELAYS
#
# Models delay from external source to DUT input pins.
#
# Example:
# External Logic ---> 1ns delay ---> DUT Input
################################################################################

# Functional interface inputs
set_input_delay 1.0 -clock clock [get_ports data_in[*]]
set_input_delay 1.0 -clock clock [get_ports pkt_valid]

set_input_delay 1.0 -clock clock [get_ports read_enb_0]
set_input_delay 1.0 -clock clock [get_ports read_enb_1]
set_input_delay 1.0 -clock clock [get_ports read_enb_2]

set_input_delay 1.0 -clock clock [get_ports resetn]
################################################################################
# OUTPUT DELAYS
#
# Models timing requirements of external receiving logic.
#
# Example:
# DUT Output ---> 1ns budget ---> External Logic
################################################################################

# Data outputs
set_output_delay 1.0 -clock clock [get_ports data_out_0[*]]
set_output_delay 1.0 -clock clock [get_ports data_out_1[*]]
set_output_delay 1.0 -clock clock [get_ports data_out_2[*]]

# Valid signals
set_output_delay 1.0 -clock clock [get_ports vld_out_0]
set_output_delay 1.0 -clock clock [get_ports vld_out_1]
set_output_delay 1.0 -clock clock [get_ports vld_out_2]

# Status outputs
set_output_delay 1.0 -clock clock [get_ports busy]
set_output_delay 1.0 -clock clock [get_ports err]
