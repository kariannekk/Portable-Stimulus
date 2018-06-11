//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

package paTest_uart;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "uvm_uart/uart_sequencer.sv"
  `include "uvm_uart/uart_driver.sv"
  `include "uvm_uart/uart_monitor.sv"
  `include "uvm_uart/uart_agent.sv"
  `include "uvm_uart/uart_env.sv"

  `include "infact_uart_receive_transaction_gen.svh"
  `include "infact_uart_transmit_transaction_gen.svh"
  `include "infact_uart_receive_delay_transaction_gen.svh"
  `include "infact_RxTx_seq.svh"
endpackage : paTest_uart