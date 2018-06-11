//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class top_env extends uvm_env;
  `uvm_component_utils(top_env)

  uart_env uart0;
  par_env  par0;
  top_scoreboard scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build_phase - create the components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uart0 = uart_env::type_id::create(.name("uart0"), .parent(this));

    par0  = par_env::type_id::create(.name("par0"), .parent(this));

    scoreboard   = top_scoreboard::type_id::create(.name("scoreboard"), .parent(this));
  endfunction: build_phase

  // Connect_phase - connecting monitor and scoreboard port
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uart0.agent.monitor.item_collected_port.connect(scoreboard.item_collected_export_uart);
    par0.agent.monitor.item_collected_port.connect(scoreboard.item_collected_export_par);
  endfunction: connect_phase
endclass: top_env