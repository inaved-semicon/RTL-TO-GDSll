################################################################################
# CREATE OUTPUT DIRECTORIES
#
# Create directories to store generated databases, DEF files and reports.
################################################################################

file mkdir ../RESULTS
file mkdir ../REPORTS

set OUTPUT "../RESULTS/FLOORPLAN"
file mkdir $OUTPUT


################################################################################
# INITIALIZE FLOORPLAN
#
# Define the core area using:
# - Target utilization
# - Core aspect ratio
# - Core-to-die spacing
# - Placement site
################################################################################

initialize_floorplan \
    -utilization 65 \
    -aspect_ratio 1 \
    -core_space 15 \
    -site unithd


################################################################################
# CREATE ROUTING TRACKS
#
# Define routing grids for each routing layer based on SKY130 technology.
# These tracks are used during placement and routing.
################################################################################

make_tracks li1 -x_pitch 0.46 -y_pitch 0.34 -x_offset 0.23 -y_offset 0.17

make_tracks met1 -x_pitch 0.34 -y_pitch 0.34 -x_offset 0.17 -y_offset 0.17

make_tracks met2 -x_pitch 0.46 -y_pitch 0.46 -x_offset 0.23 -y_offset 0.23

make_tracks met3 -x_pitch 0.68 -y_pitch 0.68 -x_offset 0.34 -y_offset 0.34

make_tracks met4 -x_pitch 0.92 -y_pitch 0.92 -x_offset 0.46 -y_offset 0.46

make_tracks met5 -x_pitch 3.40 -y_pitch 3.40 -x_offset 1.70 -y_offset 1.70


################################################################################
# REPORT INITIAL DESIGN AREA
#
# Displays the estimated die/core area after floorplan initialization.
################################################################################

report_design_area


################################################################################
# IO PIN CONSTRAINTS
#
# Assign input/output ports to specific sides of the chip.
################################################################################

# Bottom edge
set_io_pin_constraint \
  -pin_names { clock resetn pkt_valid
               read_enb_0 read_enb_1 read_enb_2
               tdi tdo tms tck trst tdo_paden_o} \
  -region bottom:*


# Left edge
set_io_pin_constraint \
  -pin_names { data_in[0] data_in[1] data_in[2] data_in[3]
               data_in[4] data_in[5] data_in[6] data_in[7]
               data_out_0[0] data_out_0[1] data_out_0[2] data_out_0[3]} \
  -region left:*


# Right edge
set_io_pin_constraint \
  -pin_names { data_out_0[4] data_out_0[5] data_out_0[6] data_out_0[7] err busy
               vld_out_0 vld_out_1 vld_out_2
               data_out_1[0] data_out_1[1] data_out_1[2] data_out_1[3]} \
  -region right:*


# Top edge
set_io_pin_constraint \
  -pin_names { data_out_1[4] data_out_1[5] data_out_1[6] data_out_1[7]
               data_out_2[0] data_out_2[1] data_out_2[2] data_out_2[3]
               data_out_2[4] data_out_2[5] data_out_2[6] data_out_2[7] } \
  -region top:*


################################################################################
# PLACE IO PINS
#
# Automatically place IO pins on the specified chip edges using
# the selected routing layers.
################################################################################

place_pins -hor_layers met3 \
           -ver_layers met2 \
           -min_distance 25 \
           -min_distance_in_tracks


################################################################################
# TAP CELL INSERTION
#
# Insert tap cells throughout the core to provide well/substrate
# connections and prevent latch-up.
################################################################################

tapcell \
    -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 \
    -distance 20


################################################################################
# SAVE FLOORPLAN DATABASE
#
# Store the generated floorplan for subsequent Physical Design stages.
################################################################################

write_db $OUTPUT/Floorplan.db
write_def $OUTPUT/Floorplan.def
write_db $OUTPUT/Floorplan.odb