################################################################################
# USER CONFIGURATION
#
# Modify these paths according to your local installation.
################################################################################

# Root directory containing the SKY130 technology files
set PDK_DIR "../../Tech_Lib"

# Technology LEF
# Defines routing layers, vias, manufacturing rules and placement sites.
set tlef_file "$PDK_DIR/sky130_fd_sc_hd.tlef"

# Standard Cell LEF
# Contains physical abstracts (size, pins, blockages) for all standard cells.
set cell_lef_file "$PDK_DIR/sky130_fd_sc_hd_merged.lef"

# IO LEF
# Physical abstracts for SKY130 IO and fill cells.
set io_lef_file "$PDK_DIR/sky130io_fill.lef"

# Gate-level netlist generated after DFT/JTAG insertion.
set NETLIST "../../DFT/JTAG/router_top_jtag_netlist.v"

# Top-level module name.
set TOP_MODULE "router_top"

# Timing constraints file.
set SDC "../../POST_DFT_STA/Constraints.sdc"


################################################################################
# READ TECHNOLOGY LEF
#
# Loads technology information such as:
# - Metal layers
# - Routing rules
# - Via definitions
# - Placement sites
################################################################################

read_lef $tlef_file


################################################################################
# READ STANDARD CELL LEF
#
# Loads the physical abstract of each standard cell.
# Used for placement and routing.
################################################################################

read_lef $cell_lef_file


################################################################################
# READ IO LEF
#
# Loads IO cell definitions required during floorplanning.
################################################################################

read_lef $io_lef_file


################################################################################
# READ LIBERTY
#
# Loads timing, area and power information of the standard cell library.
################################################################################

read_liberty $PDK_DIR/sky130_fd_sc_hd__tt_025C_1v80.lib


################################################################################
# READ GATE-LEVEL NETLIST
#
# Imports the synthesized design into OpenROAD.
################################################################################

read_verilog $NETLIST


################################################################################
# LINK DESIGN
#
# Resolves all standard-cell references in the netlist using the loaded library
# and creates the design database.
################################################################################

link_design $TOP_MODULE


################################################################################
# READ TIMING CONSTRAINTS
#
# Applies clocks, IO delays and timing constraints for subsequent physical
# design optimization.
################################################################################

read_sdc $SDC
