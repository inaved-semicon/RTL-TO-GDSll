################################################################################
# USER CONFIGURATION
#
# Modify these paths according to your setup.
################################################################################

# Timing library used for STA
set LIB     ../Tech_Lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Gate-level netlist generated after DFT/JTAG insertion
set NETLIST ../DFT/JTAG/router_top_jtag_netlist.v

# Timing constraints file
set SDC     ./Constraints.sdc

# Top-level design module
set TOP     router_top

# Report directory
set RPT_DIR Report

# Create report directory if it does not exist
file mkdir $RPT_DIR


################################################################################
# READ LIBERTY FILE
#
# Loads timing, power, and area information of SKY130 cells.
################################################################################

read_liberty -infer_latches $LIB


################################################################################
# READ DESIGN NETLIST
#
# Import synthesized gate-level design.
################################################################################

read_verilog $NETLIST


################################################################################
# LINK DESIGN
#
# Resolves all cell references using the loaded liberty library.
# This step creates the complete timing graph.
################################################################################

link_design $TOP


################################################################################
# READ TIMING CONSTRAINTS
#
# Imports clocks, delays, and timing exceptions.
################################################################################

read_sdc $SDC


################################################################################
# SETUP TIMING ANALYSIS
#
# Checks maximum delay paths.
#
# Requirement:
# Data must arrive BEFORE the next active clock edge.
#
# Report top 20 worst setup paths.
################################################################################

report_checks \
-path_delay max \
-group_path_count 20 \
> $RPT_DIR/setup_report.rpt


################################################################################
# HOLD TIMING ANALYSIS
#
# Checks minimum delay paths.
#
# Requirement:
# Data must remain stable AFTER the active clock edge.
#
# Report top 20 worst hold paths.
################################################################################

report_checks \
-path_delay min \
-group_path_count 20 \
> $RPT_DIR/hold_report.rpt


################################################################################
# WORST NEGATIVE SLACK (WNS)
#
# Reports the single most critical timing violation.
#
# WNS >= 0  → Timing met
# WNS < 0   → Timing violation exists
################################################################################

report_wns > $RPT_DIR/wns.rpt


################################################################################
# TOTAL NEGATIVE SLACK (TNS)
#
# Sum of all negative timing violations.
#
# TNS = 0   → No timing violations
# TNS < 0   → Timing violations present
################################################################################

report_tns > $RPT_DIR/tns.rpt


################################################################################
# END OF STA FLOW
#
# Generated Reports:
#   setup_report.rpt
#   hold_report.rpt
#   wns.rpt
#   tns.rpt
################################################################################