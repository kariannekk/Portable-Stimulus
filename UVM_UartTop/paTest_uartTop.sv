//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-04-06
//====================================================================

package paTest_uartTop;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import paTest_uart::*;

  `include "uvm_PeripheralSS/PeripheralSubSystem_driver.sv"
  `include "uvm_PeripheralSS/PeripheralSubSystem_monitor.sv"
  `include "uvm_PeripheralSS/PeripheralSubSystem_agent.sv"
  `include "uvm_PeripheralSS/PeripheralSubSystem_env.sv"

  `include "uartTop_driver.sv"
  `include "uartTop_agent.sv"
  `include "uartTop_env.sv"

  `include "top_scoreboard.sv"
  `include "top_env.sv"
  `include "test_uartTop.sv"
endpackage : paTest_uartTop