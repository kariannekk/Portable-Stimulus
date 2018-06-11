//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

class top_env extends uvm_env;
  `uvm_component_utils(top_env)

  protected int num_serIOBox;

  PeripheralSubSystem_env PeripheralSubSystem0;
  uart_env                uart0;
  top_scoreboard scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build_phase - create the components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(int)::get(this, "", "num_serIOBox", num_serIOBox))
      `uvm_fatal("NOINT",{"Number of SerIOBoxs must be set: ",get_full_name(),".num_serIOBox"})

    uvm_config_db#(int)::set(null,"*",$sformatf("num_uart"),num_serIOBox);

    uart0 = uart_env::type_id::create(.name("uart0"), .parent(this));
    uvm_config_db #(int) :: set (this, "uart0", "is_active", 0);

    PeripheralSubSystem0  = PeripheralSubSystem_env::type_id::create(.name("PeripheralSubSystem0"), .parent(this));

    scoreboard = top_scoreboard::type_id::create(.name("scoreboard"), .parent(this));
  endfunction: build_phase

  // Connect_phase - connecting monitor and scoreboard port
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    for (int i = 0; i < num_serIOBox; i++) begin
      uart0.agent[i].monitor.item_collected_port.connect(scoreboard.item_collected_export_uart);
      PeripheralSubSystem0.agent[i].monitor.item_collected_port.connect(scoreboard.item_collected_export_peripheralSubSystem);
    end
  endfunction: connect_phase
endclass: top_env