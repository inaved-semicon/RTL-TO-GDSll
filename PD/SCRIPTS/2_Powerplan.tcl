################################################################################
# CREATE OUTPUT DIRECTORY
#
# Store the generated PDN database and DEF files.
################################################################################

set OUTPUT "../RESULTS/PDN"
file mkdir $OUTPUT


################################################################################
# DEFINE GLOBAL POWER CONNECTIONS
#
# Connect all VPWR pins to VDD and all VGND pins to VSS.
################################################################################

add_global_connection -net VDD -pin_pattern "^VPWR$" -power

add_global_connection -net VSS -pin_pattern "^VGND$" -ground


################################################################################
# APPLY GLOBAL CONNECTIONS
#
# Physically connect all standard-cell power and ground pins.
################################################################################

global_connect


################################################################################
# DEFINE VOLTAGE DOMAIN
#
# Specify the primary power and ground nets for the design.
################################################################################

set_voltage_domain -power VDD -ground VSS


################################################################################
# CREATE PDN GRID
#
# Initialize the Power Distribution Network (PDN).
################################################################################

define_pdn_grid -name grid


################################################################################
# FOLLOWPIN STRIPES
#
# Generate Metal1 power rails aligned with standard-cell rows.
################################################################################

add_pdn_stripe -grid grid -layer met1 -followpins -width 0.48


################################################################################
# POWER RING
#
# Create Metal4/Metal5 power rings around the core.
################################################################################

add_pdn_ring -grid grid -layers {met4 met5} -widths 2 -spacings 2 -core_offsets 2 -add_connect


################################################################################
# POWER STRIPES
#
# Add vertical Metal4 power stripes across the core to distribute
# power from the rings to the standard-cell rails.
################################################################################

add_pdn_stripe -grid grid -layer met4 -width 1.6 -pitch 40 -offset 5


################################################################################
# GENERATE POWER DISTRIBUTION NETWORK
#
# Build the complete PDN and connect all power structures.
################################################################################

pdngen -verbose


################################################################################
# SAVE POWER PLAN DATABASE
#
# Export the generated PDN for the next implementation stages.
################################################################################

write_db $OUTPUT/Powerplan.odb
write_def $OUTPUT/Powerplan.def
write_db $OUTPUT/Powerplan.db