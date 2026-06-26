# SYNTHESIS

## Objective
Convert the verified RTL into a technology-mapped gate-level netlist using the SKY130 standard cell library

Synthesis is performed using:
- [yosys](https://github.com/YosysHQ/yosys.git): RTL synthesis to gate-level netlist


## PDK Setup(Optional)

This synthesis flow targets the SKY130 open-source PDK.

Before running synthesis, install and configure the SKY130 Process Design Kit (PDK).

This repository uses SKY130 open-source PDK generated through [open_pdks](https://github.com/RTimothyEdwards/open_pdks.git).

`open_pdks` automates creation of the complete PDK directory structure and prepares technology data for open-source EDA tools.

## Write Synthesis Script
This repository provides a ready-to-use synthesis script:

[synth.tcl](synth.tcl)

```bash
//Change this Line from script
set LIB        "../Tech_Lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

```
## Run Synthesis
Execute:
```bash
cd SYNTHESIS
yosys -c synth.tcl 2>&1 | tee synth.log
```
This command:

- Runs the synthesis script
- Prints logs to terminal
- Saves complete logs into [synth.log](synth.log)

After successful synthesis, the following files will be generated:

- Netlist/[router_top_netlist.v](Netlist/router_top_netlist.v)
- Report/[router_top_area.rpt](Report/router_top_area.rpt)

## Understand Output
### [router_top_netlist.v](Netlist/router_top_netlist.v)

Synthesized gate-level Verilog netlist generated after technology mapping.

**Inspect:**
```bash
vi Netlist/router_top_netlist.v
```

**This file contains:**

- Standard cells mapped from SKY130 library
- Flattened hardware structure
- Gate-level implementation of RTL logic
- Cell instances and interconnections

**Example transformation:**
```bash
RTL:
assign y = a & b

↓

Netlist:
sky130_fd_sc_hd__and2_1 U1 (...)
```

**Purpose:**

- Input for DFT insertion
- Timing analysis
- Physical design (Floorplan → Route)
- Gate-level simulation



### [router_top_area.rpt](Report/router_top_area.rpt)
This report contains synthesis statistics and estimated area after technology mapping.

Inspect:
```bash
cat Report/router_top_area.rpt
```

Expected Output

     === router_top ===

            +----------Local Count, excluding submodules.
            |        +-Local Area, excluding submodules.
            |        | 
        1519        - wires                     //Total internal signal connections
        2174        - wire bits                 //Total width of all wires
        141         - public wires               //Named user-visible signals
        796         - public wire bits           //Width of public signals
        15          - ports                       //Number of input/output ports
        43          - port bits                   //Total I/O width
        1962 2.29E+04 cells
        6           -   $scopeinfo
        1     8.758   sky130_fd_sc_hd__a2111oi_0
        17  127.622   sky130_fd_sc_hd__a211oi_1
        .
        .
        .
        .
        586 1.17E+04   sky130_fd_sc_hd__dfxtp_1   //D Type FlipFlop
        .
        .
        .
        14   122.618   sky130_fd_sc_hd__xor2_1

    Area for cell type $scopeinfo is unknown!

    Chip area for module '\router_top': 22943.254400
        of which used for sequential elements: 11731.251200 (51.13%)

`$scopeinfo` is synthesis metadata and does not contribute to physical implementation.It can be ignored.

## Conclusion

At this stage, the RTL has been successfully converted into a technology-mapped gate-level netlist using the SKY130 standard cell library.

Verify that:

* Synthesis completed successfully
* Netlist is generated
* Area report is generated
* Results meet design expectations

The synthesized netlist generated in this stage will be used as the input for the next stage of the RTL → GDSII flow.

Proceed to the next step after successful synthesis verification.
