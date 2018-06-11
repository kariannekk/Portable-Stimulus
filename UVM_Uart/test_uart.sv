//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class test_uart extends uvm_test;
  `uvm_component_utils(test_uart)

  virtual in_uart   uin_uart;

  top_env env;

  // Sequence instances
  `ifdef INFACT_IMPORT
    uart_sequence_receive   uart_rec_seq;
    uart_sequence_transmit  uart_trans_seq;
  `else 
    infact_uart_receive_transaction_gen  uart_rec_seq;
    infact_uart_transmit_transaction_gen uart_trans_seq;
  `endif
  par_sequence_write      par_wr_seq;
  par_sequence_read       par_re_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = top_env::type_id::create(.name("env"), .parent(this));

    if (!uvm_config_db #(virtual in_uart)::get(null, "uvm_test_top", "uin_uart", uin_uart))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_uart"})
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(.obj(this));

    @(negedge uin_uart.arst);

    ta_Receive();

    ta_Transmit();

    phase.drop_objection(.obj(this));
  endtask: run_phase

  virtual task ta_Receive();
    // Enable UART
    ta_ReadWrite(pa_Uart::ID_UART_ENABLE, 32'h0000_0001);

    // Enable RX
    ta_ReadWrite(pa_Uart::ID_UART_RX_ENABLE, 32'h0000_0001);
    wait(uin_uart.eventReadyRx);

    // Config UART to no parity and one stop bit
    ta_ReadWrite(pa_Uart::ID_UART_CONFIG, 32'h0000_0004);

    // Call receive sequences
    uart_rec_seq = new();
    uart_rec_seq.start(env.uart0.agent.sequencer);
  endtask

  virtual task ta_Transmit();
    // Enable UART
    ta_ReadWrite(pa_Uart::ID_UART_ENABLE, 32'h0000_0001);

    // Enable TX
    ta_ReadWrite(pa_Uart::ID_UART_TX_ENABLE, 32'h0000_0001);
    wait(uin_uart.eventReadyTx);

    // Config UART to no parity and one stop bit
    ta_ReadWrite(pa_Uart::ID_UART_CONFIG, 32'h0000_0004);

    // Call receive sequences
    uart_trans_seq = new();
    uart_trans_seq.start(env.uart0.agent.sequencer);
  endtask

  virtual task ta_ReadWrite(logic [11:0] addr, logic [31:0] data);
    //Write
    par_wr_seq = new(.addr(addr), .data(data));
    par_wr_seq.start(env.par0.agent.sequencer);

    //Read
    par_re_seq = new(.addr(addr));
    par_re_seq.start(env.par0.agent.sequencer);
  endtask
endclass: test_uart