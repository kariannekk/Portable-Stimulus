//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class uart_agent extends uvm_agent;
  `uvm_component_utils(uart_agent)

  uart_sequencer sequencer;
  uart_driver    driver;
  uart_monitor   monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = uart_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = uart_driver::type_id::create("driver", this);
      sequencer = uart_sequencer::type_id::create("sequencer", this);
    end
  endfunction: build_phase

  // Connect_phase - connecting the driver and sequencer port
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction: connect_phase
endclass: uart_agent