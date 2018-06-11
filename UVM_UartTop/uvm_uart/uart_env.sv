//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  protected int num_uart;

  uart_agent agent[];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build_phase - create the components
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);

    if (!uvm_config_db #(int)::get(this, "", "num_uart", num_uart))
      `uvm_fatal("NOINT",{"Number of UARTs must be set: ",get_full_name(),".num_uart"})

    agent = new[num_uart];
    for(int i = 0; i < num_uart; i++) begin
      $sformat(inst_name, "agent[%0d]", i);
      agent[i] = uart_agent::type_id::create(inst_name, this);
      void'(uvm_config_db#(int)::set(this,{inst_name,".monitor"}, "uart_id", i));
      void'(uvm_config_db#(int)::set(this,{inst_name,".driver"}, "uart_id", i));
    end
  endfunction: build_phase
endclass: uart_env