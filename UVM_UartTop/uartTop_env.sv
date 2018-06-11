//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-04-06
//====================================================================

class uartTop_env extends uvm_env;
  `uvm_component_utils(uartTop_env)

  protected int num_serIOBox;

  uartTop_agent agent[];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build_phase - create the components
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);

    if (!uvm_config_db #(int)::get(this, "", "num_serIOBox", num_serIOBox))
      `uvm_fatal("NOINT",{"Number of SerIOBoxs must be set: ",get_full_name(),".num_serIOBox"})

    agent = new[num_serIOBox];
    for(int i = 0; i < num_serIOBox; i++) begin
      $sformat(inst_name, "agent[%0d]", i);
      agent[i] = uartTop_agent::type_id::create(inst_name, this);
      void'(uvm_config_db#(int)::set(this,{inst_name,".driver"}, "serIOBox_id", i));
    end
  endfunction: build_phase
endclass: uartTop_env