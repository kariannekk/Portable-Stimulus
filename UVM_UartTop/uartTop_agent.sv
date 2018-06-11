//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-04-06
//====================================================================

class uartTop_agent extends uvm_agent;
  `uvm_component_utils(uartTop_agent)

  uart_sequencer    sequencer;
  uartTop_driver    driver;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = uartTop_driver::type_id::create("driver", this);
      sequencer = uart_sequencer::type_id::create("sequencer", this);
    end
  endfunction: build_phase

  // Connect_phase - connecting the driver and sequencer port
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction: connect_phase
endclass: uartTop_agent