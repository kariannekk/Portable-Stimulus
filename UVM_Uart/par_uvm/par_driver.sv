//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class par_driver extends uvm_driver #(par_transaction);
  `uvm_component_utils(par_driver)

  virtual in_ParBus uin_ParBus;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual in_ParBus)::get(this, "", "uin_ParBus", uin_ParBus))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".uin_ParBus"});
  endfunction: build_phase

  // Run phase - transaction level to signal level
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase

  virtual task drive();
    uin_ParBus.parWe = 4'h0;
    uin_ParBus.parRe = 1'b0;
    @(posedge uin_ParBus.ckPar);
    
    uin_ParBus.parAddr = req.parAddr;
    uin_ParBus.parWe   = req.parWe;
    uin_ParBus.parDo   = req.parDo;
    uin_ParBus.parRe   = req.parRe;
    @(posedge uin_ParBus.ckPar);
    uin_ParBus.parWe = 4'h0;
    uin_ParBus.parRe = 1'b0;

  endtask : drive
endclass : par_driver