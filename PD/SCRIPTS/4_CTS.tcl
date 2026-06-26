################################################################################
# CREATE OUTPUT DIRECTORIES
#
# Create directories to store timing reports, CTS reports,
# and final CTS databases.
################################################################################

set PRE_CTS_STA  "../REPORTS/STA/Pre_cts"   ;# Directory for pre-CTS STA reports (setup, hold, skew)
set POST_CTS_STA "../REPORTS/STA/Post_cts"  ;# Directory for post-CTS STA reports (after clock tree)
set CTS_REP      "../REPORTS/CTS"           ;# Directory for CTS-specific reports (skew, topology)
set CTS_RES      "../RESULTS/CTS"           ;# Directory for CTS result checkpoints (ODB, DEF, DB, SDC)

file mkdir $PRE_CTS_STA
file mkdir $POST_CTS_STA
file mkdir $CTS_REP
file mkdir $CTS_RES


################################################################################
# PRE-CTS TIMING ANALYSIS
#
# Analyze setup, hold and clock skew before inserting
# the clock distribution network.
################################################################################

report_worst_slack -max

report_worst_slack -min

report_worst_slack -max  > $PRE_CTS_STA/Worst_Slack.rpt

report_worst_slack -min >> $PRE_CTS_STA/Worst_Slack.rpt

report_checks -path_delay max > $PRE_CTS_STA/Setup_paths.rpt

report_checks -path_delay min > $PRE_CTS_STA/Hold_paths.rpt

report_clock_skew > $PRE_CTS_STA/Clock_Skew.rpt


################################################################################
# CLOCK TREE SYNTHESIS (CTS)
#
# Build a balanced clock distribution network using SKY130 clock
# buffers while minimizing clock skew and insertion delay.
################################################################################

clock_tree_synthesis \
    -root_buf  sky130_fd_sc_hd__clkbuf_16 \
    -buf_list  {\
        sky130_fd_sc_hd__clkbuf_2\
        sky130_fd_sc_hd__clkbuf_4\
        sky130_fd_sc_hd__clkbuf_8\
    } \
    -sink_clustering_enable \
    -sink_clustering_max_diameter 40 \
    -sink_clustering_size         20 \
    -repair_clock_nets


################################################################################
# CTS REPORTS
#
# Report clock skew and CTS statistics after clock tree generation.
################################################################################

report_clock_skew

report_clock_skew > $CTS_REP/clock_skew_post_cts.rpt

report_cts


################################################################################
# POST-CTS LEGALIZATION
#
# Legalize cell placement after inserting clock buffers.
################################################################################

detailed_placement

check_placement -verbose


################################################################################
# PARASITIC ESTIMATION
#
# Estimate wire resistance and capacitance based on placement.
################################################################################

estimate_parasitics -placement


################################################################################
# TIMING OPTIMIZATION
#
# Repair hold and setup timing violations introduced after CTS.
################################################################################

repair_timing -hold -hold_margin 0.08 -max_buffer_percent 25

repair_timing -setup -setup_margin 0.00 -max_passes 10

repair_timing -hold -hold_margin 0.05 -max_buffer_percent 30


################################################################################
# FINAL LEGALIZATION & PARASITIC UPDATE
#
# Re-legalize placement and update RC estimation after timing fixes.
################################################################################

detailed_placement

estimate_parasitics -placement


################################################################################
# POST-CTS TIMING REPORTS
#
# Generate final setup, hold and clock skew reports after CTS
# optimization.
################################################################################

report_worst_slack -max

report_worst_slack -min

report_worst_slack -max > $POST_CTS_STA/Worst_Slack.rpt

report_worst_slack -min >> $POST_CTS_STA/Worst_Slack.rpt

report_checks -path_delay max > $POST_CTS_STA/Setup.rpt

report_checks -path_delay min > $POST_CTS_STA/Hold.rpt

report_clock_skew

report_clock_skew > $POST_CTS_STA/Clock_Skew.rpt


################################################################################
# SAVE CTS DATABASE
#
# Export the design after Clock Tree Synthesis and timing optimization.
################################################################################

write_db   $CTS_RES/cts_final.db
write_def  $CTS_RES/cts_final.def
write_sdc  $CTS_RES/cts_final.sdc
write_db   $CTS_RES/cts_final.odb