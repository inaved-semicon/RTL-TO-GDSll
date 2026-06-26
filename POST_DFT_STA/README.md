# STATIC TIMING ANALYSIS (STA)

## Objective

Verify that the synthesized and DFT-inserted design meets timing requirements under the specified operating conditions.

STA is performed without simulation vectors and is used to identify timing violations before physical implementation.

This stage verifies:

* Setup timing
* Hold timing
* Critical timing paths
* Worst Negative Slack (WNS)
* Total Negative Slack (TNS)

---

## Tool Used

STA is performed using:

- [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA.git): Static Timing Analysis engine

**Input files:**

* JTAG inserted gate-level netlist
* SKY130 Liberty timing library
* Timing constraints (SDC)
* Automated .tcl Script

**Outputs:**

* Setup timing report
* Hold timing report
* WNS report
* TNS report

---

## Write Timing Constraints (Constraints.sdc)

STA requires timing constraints describing clocks, I/O timing requirements, and clock relationships.

This project uses two clocks:

| Clock | Period | Frequency |
| ----- | ------ | --------- |
| clock | 10 ns  | 100 MHz   |
| tck   | 100 ns | 10 MHz    |

This repository provides a ready-to-use Constraints file:

**[Constraints.sdc](Constraints.sdc)**

---

## Write STA Script (sta.tcl)

The STA flow is automated using OpenSTA.

The script performs:

1. Read Liberty timing library
2. Read gate-level netlist
3. Link design hierarchy
4. Read timing constraints
5. Perform setup analysis
6. Perform hold analysis
7. Generate WNS report
8. Generate TNS report

This repository provides a ready-to-use STA script:

**[sta.tcl](sta.tcl)**

## Run STA

Execute:

```bash
cd POST_DFT_STA
sta sta.tcl
```

This command:

* Launches OpenSTA
* Reads the SKY130 timing library
* Reads the gate-level netlist
* Applies timing constraints
* Performs setup and hold analysis
* Generates timing reports

## Expected Output


### **Report/[setup_report.rpt](Report/setup_report.rpt)**: Contains worst setup timing paths.

Used to verify:

* Maximum path delays
* Setup slack
* Critical timing paths

### **Report/[hold_report.rpt](Report/hold_report.rpt)**: Contains worst hold timing paths.

Used to verify:

* Minimum path delays
* Hold slack
* Hold timing violations

### **Report/[wns.rpt](Report/wns.rpt)**: Worst Negative Slack report.

Used to identify the single most critical timing path in the design.

Interpretation:

```text
WNS ≥ 0  → Timing Met
WNS < 0  → Timing Violation
```

### **Report/[tns.rpt](Report/tns.rpt)**: Total Negative Slack report.

Used to measure the overall timing health of the design.

Interpretation:

```text
TNS = 0  → No Timing Violations
TNS < 0  → Timing Violations Exist
```
