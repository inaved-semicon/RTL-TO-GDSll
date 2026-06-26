################################################################################
# CREATE OUTPUT DIRECTORY
#
# Store placement databases and DEF files.
################################################################################

set OUTPUT "../RESULTS/PLACEMENT"

file mkdir $OUTPUT


################################################################################
# SET ESTIMATED WIRE RC
#
# Define resistance and capacitance models used during placement
# for signal and clock routing estimation.
################################################################################

set_wire_rc -signal -layer met3

set_wire_rc -clock -layer met5


################################################################################
# GLOBAL PLACEMENT
#
# Perform timing-driven placement to obtain an optimized initial
# location for all standard cells.
################################################################################

global_placement -timing_driven


################################################################################
# DETAILED PLACEMENT
#
# Legalize the placement by aligning cells to placement rows,
# removing overlaps, and satisfying design rules.
################################################################################

detailed_placement


################################################################################
# VERIFY PLACEMENT
#
# Check for placement legality and report any violations.
################################################################################

check_placement


################################################################################
# SAVE PLACEMENT DATABASE
#
# Export the placed design for the CTS stage.
################################################################################

write_db $OUTPUT/Placement.db
write_def $OUTPUT/Placement.def
write_db $OUTPUT/Placement.odb