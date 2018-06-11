//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

class PeripheralSubSystem_agent extends uvm_agent;
  `uvm_component_utils(PeripheralSubSystem_agent)

  uart_sequencer                sequencer;
  PeripheralSubSystem_driver    driver;
  PeripheralSubSystem_monitor   monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = PeripheralSubSystem_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = PeripheralSubSystem_driver::type_id::create("driver", this);
      sequencer = uart_sequencer::type_id::create("sequencer", this);
    end
  endfunction: build_phase

  // Connect_phase - connecting the driver and sequencer port
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction: connect_phase
endclass: PeripheralSubSystem_agent