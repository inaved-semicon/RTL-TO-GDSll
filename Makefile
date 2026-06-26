.PHONY: clean

clean:
	@echo "Cleaning generated files..."

	# -----------------------------
	# Simulation
	# -----------------------------
	rm -rf Simulation/fsm_sim.out
	rm -rf Simulation/router_fsm.vcd
	rm -rf Simulation/*.png

	# -----------------------------
	# Synthesis
	# -----------------------------
	rm -rf SYNTHESIS/Netlist
	rm -rf SYNTHESIS/Report
	rm -rf SYNTHESIS/synth.log

	# -----------------------------
	# STA
	# -----------------------------
	rm -rf POST_DFT_STA/Report
	rm -rf POST_DFT_STA/sta.log
	rm -rf PRE_DFT_STA/Report
	rm -rf PRE_DFT_STA/sta.log

	# -----------------------------
	# DFT
	# -----------------------------
	rm -rf DFT/parser.out
	rm -rf DFT/parsetab.py

	rm -rf DFT/SIMULATION/*
	rm -rf DFT/SCAN/*
	rm -rf DFT/REPORT/*
	rm -rf DFT/JTAG/*
	rm -rf DFT/CUT/*
	rm -rf DFT/ATPG/*
	rm -rf DFT/ASM/*
	rm -rf DFT/LOGS/*

	# -----------------------------
	# Physical Design
	# -----------------------------
	rm -rf PD/SCRIPTS/Log/*
	rm -rf PD/RESULTS
	rm -rf PD/REPORTS
	
	@echo ""
	@echo "Repository cleaned successfully."
	@echo "You can now start the RTL-to-GDSII flow from the beginning."