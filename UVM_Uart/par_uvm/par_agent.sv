//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class par_agent extends uvm_agent;
  `uvm_component_utils(par_agent)

  par_driver    driver;
  par_sequencer sequencer;
  par_monitor   monitor;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = par_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = par_driver::type_id::create("driver", this);
      sequencer = par_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  // Connect_phase - connecting the driver and sequencer port
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase
endclass : par_agent