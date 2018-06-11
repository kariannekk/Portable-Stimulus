//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

package paTest_uart;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import paTest_par::*;

  `include "uart_uvm/uart_sequencer.sv"
  `include "uart_uvm/uart_driver.sv"
  `include "uart_uvm/uart_monitor.sv"
  `include "uart_uvm/uart_agent.sv"
  `include "uart_uvm/uart_env.sv"
  `include "infact_uart_receive_transaction_gen.svh"
  `include "infact_uart_transmit_transaction_gen.svh"
  `include "infact_uart_receive_delay_transaction_gen.svh"

  `include "top_scoreboard.sv"
  `include "top_env.sv"
  `include "test_uart.sv"

endpackage : paTest_uart