# STATIC TIMING ANALYSIS (STA)

## Objective

Verify that the synthesized design meets timing requirements under the specified operating conditions.

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

* gate-level netlist
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

This project uses one clocks:

| Clock | Period | Frequency |
| ----- | ------ | --------- |
| clock | 10 ns  | 100 MHz   |

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
cd PRE_DFT_STA
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
# Understanding a Timing Path

Open hold timing report:
```bash
gvim hold_report.rpt
```
it will look like

```text
Startpoint: __dut__.__uuf__._3302_
            (rising edge-triggered flip-flop clocked by clock)

Endpoint: __dut__.__uuf__._3303_
          (rising edge-triggered flip-flop clocked by clock)

Path Group: clock
Path Type: min

...

0.40   data arrival time

...

0.06   data required time

...

0.33   slack (MET)
```

### Startpoint

```text
Startpoint: __dut__.__uuf__._3302_
```

Source flip-flop launching the data.

Data starts propagating from:

```text
Q output of Flip-Flop
```

---

### Endpoint

```text
Endpoint: __dut__.__uuf__._3303_
```

Destination flip-flop capturing the data.

Data must arrive at:

```text
D input of Flip-Flop
```

---

### Path Type

```text
Path Type: min
```

This is a **hold timing analysis**.

For hold analysis, STA checks:

```text
Is the data arriving too fast?
```

---

### Data Arrival Time

```text
0.29    __dut__.__uuf__._3302_/Q
0.11    __dut__._1182_/X
0.00    __dut__.__uuf__._3303_/D
```

Path traversal:

```text
FF1(Q)
   ↓
MUX
   ↓
FF2(D)
```

Total combinational delay:

```text
0.29 + 0.11 = 0.40 ns
```

Therefore:

```text
Data Arrival Time = 0.40 ns
```

---

### Data Required Time

```text
0.10   clock uncertainty
-0.04  library hold time
```

OpenSTA calculates:

```text
Required Time = 0.06 ns
```

Meaning:

The destination flip-flop requires data to remain stable for at least:

```text
0.06 ns
```

after the active clock edge.

---

### Slack Calculation

For hold analysis:

```text
Slack = Arrival Time - Required Time
```

Substituting values:

```text
Slack = 0.40 - 0.06
      = 0.34 ns
```

OpenSTA reports:

```text
Slack = 0.33 ns
```

(small difference due to internal precision)

---

### Result Interpretation

```text
Slack = +0.33 ns
```

Since:

```text
Slack > 0
```

the path passes hold timing.

OpenSTA reports:

```text
slack (MET)
```

Meaning:

* No hold violation
* Data is not arriving too early
* Timing requirement is satisfied

---

### Quick Rule

```text
Positive Slack  → Timing MET
Zero Slack      → Timing Exactly Met
Negative Slack  → Timing VIOLATION
```

For a timing-clean design:

```text
Setup Slack > 0
Hold Slack  > 0
WNS ≥ 0
TNS = 0
```
