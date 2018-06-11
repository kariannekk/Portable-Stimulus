//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class par_env extends uvm_env;
  `uvm_component_utils(par_env)

  par_agent agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build_phase - create the components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = par_agent::type_id::create(.name("agent"), .parent(this));
  endfunction: build_phase
endclass: par_env