//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class par_monitor extends uvm_monitor;
  `uvm_component_utils(par_monitor)

  virtual in_ParBus uin_ParBus;

  // Analysis port, to send the transaction to scoreboard
  uvm_analysis_port #(par_transaction) item_collected_port;

  par_transaction trans_collected;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  // Build_phase - getting the interface handle
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual in_ParBus)::get(this, "", "uin_ParBus", uin_ParBus))
       `uvm_fatal("NO uin_ParBus",{"virtual interface must be set for: ",get_full_name(),".uin_ParBus"});
  endfunction: build_phase

  // Run_phase - convert the signal level activity to transaction level.
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge uin_ParBus.parWe || uin_ParBus.parRe);
        trans_collected.parAddr = uin_ParBus.parAddr;
      if(uin_ParBus.parWe) begin
        trans_collected.parWe = uin_ParBus.parWe;
        trans_collected.parDo = uin_ParBus.parDo;
        trans_collected.parRe = '0;
        trans_collected.inst  = WRITE;
      end
      if(uin_ParBus.parRe) begin
        @(posedge uin_ParBus.ckPar);
        trans_collected.parRe = uin_ParBus.parRe;
        trans_collected.parWe = '0;
        trans_collected.parDi = uin_ParBus.parDi;
        trans_collected.inst  = READ;
      end
      item_collected_port.write(trans_collected);
    end 
  endtask : run_phase
endclass : par_monitor