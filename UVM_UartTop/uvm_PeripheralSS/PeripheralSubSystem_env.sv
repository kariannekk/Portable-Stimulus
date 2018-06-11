//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

class PeripheralSubSystem_env extends uvm_env;
  `uvm_component_utils(PeripheralSubSystem_env)

  protected int num_serIOBox;

  PeripheralSubSystem_agent agent[];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build_phase - create the components
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);

    if (!uvm_config_db #(int)::get(this, "", "num_serIOBox", num_serIOBox))
      `uvm_fatal("NOINT",{"Number of UARTs must be set: ",get_full_name(),".num_serIOBox"})

    agent = new[num_serIOBox];
    for(int i = 0; i < num_serIOBox; i++) begin
      $sformat(inst_name, "agent[%0d]", i);
      agent[i] = PeripheralSubSystem_agent::type_id::create(inst_name, this);
      void'(uvm_config_db#(int)::set(this,{inst_name,".monitor"}, "PeripheralSS_id", i));
      void'(uvm_config_db#(int)::set(this,{inst_name,".driver"}, "PeripheralSS_id", i));
    end
  endfunction: build_phase
endclass: PeripheralSubSystem_env