################################################################################
# TECHNOLOGY CONFIGURATION
#
# Specify the RC extraction rules required for post-route
# parasitic extraction (SPEF generation).
################################################################################

set RCX_DIR "../../Tech_Lib"       ;# Root directory for SkyWater 130 nm PDK files (LEF, LIB, RCX rules)
set rcx_rules_file "$RCX_DIR/rcx_patterns.rules"  ;# RCX rules file for SkyWater 130 nm PDK (defines parasitic extraction patterns)


################################################################################
# CREATE OUTPUT DIRECTORIES
#
# Create directories for routing reports, timing reports,
# routing database, and post-route netlist.
################################################################################

set REPORT    "../REPORTS/ROUTING"         ;# Directory for routing DRC and maze log files
file mkdir $REPORT

set POST_ROUTE_STA "../REPORTS/STA/Post_Routing";# Directory for post-route STA timing reports
file mkdir $POST_ROUTE_STA

set OUTPUT        "../RESULTS/ROUTING"  ;# Directory for detailed route result checkpoints
file mkdir $OUTPUT

set NETLIST_DIR "../RESULTS/NETLIST"  ;# Directory for synthesized post-route netlist
file mkdir $NETLIST_DIR

set NETLIST_OUTPUT "$NETLIST_DIR/router_top_post_route.v"  ;# Output post-route gate-level netlist


################################################################################
# ROUTING LAYER CONFIGURATION
#
# Define the routing layers used for signal and clock nets.
################################################################################

set_routing_layers -signal met1-met5 -clock met2-met5


################################################################################
# GLOBAL ROUTING
#
# Perform congestion-aware coarse routing to generate routing guides
# for the detailed router.
################################################################################

global_route \
    -congestion_iterations 50 \
    -critical_nets_percentage 30 \
    -allow_congestion \
    -verbose \
    -congestion_report_file $REPORT/global_route_congestion.rpt


################################################################################
# SAVE ROUTING GUIDES
#
# Export routing guides generated during global routing.
################################################################################

write_guides $OUTPUT/route.guide


################################################################################
# DETAILED ROUTING
#
# Complete the physical routing of every signal using the routing
# guides generated during global routing.
################################################################################

set_routing_layers -signal met1-met5 -clock met2-met5

detailed_route \
    -output_maze $REPORT/detailed_route_maze.log \
    -output_drc $REPORT/detailed_route_drc.rpt \
    -output_guide_coverage $REPORT/guide_coverage.rpt \
    -db_process_node sky130 \
    -droute_end_iter 64 \
    -min_access_points 1 \
    -save_guide_updates \
    -clean_patches \
    -verbose 1


################################################################################
# ANTENNA CHECK & REPAIR
#
# Detect and repair antenna violations introduced during routing.
################################################################################

check_antennas

repair_antennas

check_antennas


################################################################################
# FILLER CELL INSERTION
#
# Insert filler cells to maintain continuous power rails and satisfy
# physical design requirements.
################################################################################

filler_placement \
    "sky130_fd_sc_hd__fill_8 \
     sky130_fd_sc_hd__fill_4 \
     sky130_fd_sc_hd__fill_2 \
     sky130_fd_sc_hd__fill_1"


################################################################################
# POST-ROUTE STATIC TIMING ANALYSIS
#
# Analyze setup, hold, WNS, TNS and clock skew after routing.
################################################################################

report_checks -path_delay max
report_checks -path_delay max > $POST_ROUTE_STA/setup.rpt

report_checks -path_delay min
report_checks -path_delay min > $POST_ROUTE_STA/hold.rpt

report_wns
report_wns > $POST_ROUTE_STA/wns.rpt

report_tns
report_tns > $POST_ROUTE_STA/tns.rpt

report_clock_skew > $POST_ROUTE_STA/skew.rpt


################################################################################
# PARASITIC EXTRACTION
#
# Extract post-route resistance and capacitance values and
# generate the SPEF file.
################################################################################

extract_parasitics -ext_model_file $rcx_rules_file

write_spef $OUTPUT/router.spef


################################################################################
# EXPORT FINAL DESIGN
#
# Save the routed design, extracted netlist, DEF, and OpenROAD
# databases for GDS generation and signoff.
################################################################################

write_verilog $NETLIST_OUTPUT

write_db $OUTPUT/Routing.odb
write_def $OUTPUT/Routing.def
write_db $OUTPUT/Routing.db