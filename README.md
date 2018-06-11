# Portable-Stimulus

This repository is an online appendix for the master thesis located here:

A proof of concept for the new Portable Stimulus standard, PSS, has been conducted with Questa inFact. Generated code from a single description was proven to be used in simulation at IP-, sub-system- and SoC-level in UVM testbenches, as well as with C code running on a CPU. The generated code are the stimulus, so frameworks for driving the stimulus are created. This includes three UVM testbenches and a C code.

## Repository content:
* UVM_Uart
	* Testbench files for the IP level UVM testbench
* UVM_PeripheralSS
	* Testbench files for the sub-system level UVM testbench
* UVM_UartTop
	* Testbench files for the SoC level UVM testbench
* FW_Uart
	* The C code and a SystemVerilog testbench for running it
* Infact code
	* The rules files created in inFact and the generated code
