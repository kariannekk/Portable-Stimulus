//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

package paTest_PeripheralSubSystem;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import paTest_uart::*;

  `include "uvm_PeripheralSubSystem/PeripheralSubSystem_driver.sv"
  `include "uvm_PeripheralSubSystem/PeripheralSubSystem_monitor.sv"
  `include "uvm_PeripheralSubSystem/PeripheralSubSystem_agent.sv"
  `include "uvm_PeripheralSubSystem/PeripheralSubSystem_env.sv"

  `include "top_scoreboard.sv"
  `include "top_env.sv"
  `include "test_PeripheralSubSystem.sv"

endpackage : paTest_PeripheralSubSystem