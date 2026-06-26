###############################################################################
# DRC Verification Script (Magic)
#
# This script performs Design Rule Check (DRC) on the generated GDS layout.
# It loads the routed layout, runs all SKY130 design rule checks, and exports
# the violations into a report file.
###############################################################################

# ---------------------------------------------------------------------------
# Load the top-level layout
# ---------------------------------------------------------------------------
gds read ../RESULTS/GDS/router_top.gds
load router_top

# ---------------------------------------------------------------------------
# Enable Euclidean distance checking (recommended for SKY130)
# ---------------------------------------------------------------------------
drc euclidean on

# ---------------------------------------------------------------------------
# Run complete DRC
# ---------------------------------------------------------------------------
drc check
drc catchup

# ---------------------------------------------------------------------------
# Print summary to console
# ---------------------------------------------------------------------------
puts ""
puts "========================================"
puts "        DRC SUMMARY"
puts "========================================"
drc count
puts "========================================"
puts ""

# ---------------------------------------------------------------------------
# Write detailed DRC report
# ---------------------------------------------------------------------------
file mkdir ../REPORTS/DRC
set outfile [open "../REPORTS/DRC/router_top_drc.rpt" "w"]

puts $outfile "========================================"
puts $outfile "      MAGIC DRC REPORT"
puts $outfile "========================================"
puts $outfile ""

puts $outfile "DRC Summary:"
puts $outfile ""

set errors [drc listall why]

if {[llength $errors] == 0} {
    puts $outfile "No DRC violations found."
} else {
    foreach err $errors {
        puts $outfile $err
    }
}

close $outfile

puts "Detailed DRC report written to ../REPORTS/DRC/router_top_drc.rpt"

# ---------------------------------------------------------------------------
# Exit Magic
# ---------------------------------------------------------------------------
quit -noprompt