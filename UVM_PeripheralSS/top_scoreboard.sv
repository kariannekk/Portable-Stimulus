//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

`uvm_analysis_imp_decl ( _uart )
`uvm_analysis_imp_decl ( _peripheralSubSystem )

class top_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(top_scoreboard)

  // Ports to recive packets from monitor
  uvm_analysis_imp_uart#(uart_transaction, top_scoreboard) item_collected_export_uart;
  uvm_analysis_imp_peripheralSubSystem#(uart_transaction, top_scoreboard)  item_collected_export_peripheralSubSystem;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Build_phase - create ports
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export_uart                 = new("item_collected_export_uart", this);
    item_collected_export_peripheralSubSystem  = new("item_collected_export_peripheralSubSystem", this);
  endfunction: build_phase

  // Write task - recives the pkt from monitor and pushes into queue
  virtual function void write_uart(uart_transaction pkt);
    uart_trans(pkt);
  endfunction

  virtual function void write_peripheralSubSystem(uart_transaction pkt);
    peripheralSubSystem_trans(pkt);
  endfunction

  virtual function void uart_trans(uart_transaction uart_pkt);

    if(uart_pkt.kind == RECEIVE) begin
      if(uart_pkt.start_bit != 1'b0)
        `uvm_error(get_type_name(),"------ :: RECEIVE START BIT mismatch :: ------")

      // Check if bit stream input equals output RX data
      if(uart_pkt.payload == uart_pkt.rxData) begin
        `uvm_info(get_type_name(),$sformatf("------ :: RECEIVE Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("UART%0d - Expected Data: %0h Actual Data: %0h",uart_pkt.uart_id,uart_pkt.payload,uart_pkt.rxData),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: RECEIVE MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("UART%0d - Expected Data: %0h Actual Data: %0h",uart_pkt.uart_id,uart_pkt.payload,uart_pkt.rxData),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end

      if(uart_pkt.stop_bits[0] != 1'b1)
        `uvm_error(get_type_name(),"------ :: RECEIVE STOP BIT ONE mismatch :: ------")
    end
    else if(uart_pkt.kind == TRANSMIT) begin
      if(uart_pkt.start_bit != 1'b0)
        `uvm_error(get_type_name(),"------ :: TRANSMIT START BIT mismatch :: ------")

      // Check if input TX data equals bit stream output
      if(uart_pkt.payload == uart_pkt.txd) begin
        `uvm_info(get_type_name(),$sformatf("------ :: TRANSMIT Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("UART%0d - Expected Data: %0h Actual Data: %0h",uart_pkt.uart_id,uart_pkt.payload,uart_pkt.txd),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: TRANSMIT MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("UART%0d - Expected Data: %0h Actual Data: %0h",uart_pkt.uart_id,uart_pkt.payload,uart_pkt.txd),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end

      if(uart_pkt.stop_bits[0] != 1'b1)
        `uvm_error(get_type_name(),"------ :: TRANSMIT STOP BIT ONE mismatch :: ------")
    end

  endfunction

  virtual function void peripheralSubSystem_trans(uart_transaction PeripheralSubSystem_pkt);
    if(PeripheralSubSystem_pkt.kind == RECEIVE) begin
      // Check if bit stream input equals output RX data
      if(PeripheralSubSystem_pkt.payload == PeripheralSubSystem_pkt.rxData) begin
        `uvm_info(get_type_name(),$sformatf("------ :: RECEIVE DMA Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("SerIOBox%0d - Expected Data: %0h Actual Data: %0h",PeripheralSubSystem_pkt.uart_id,PeripheralSubSystem_pkt.payload,PeripheralSubSystem_pkt.rxData),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: RECEIVE DMA MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("SerIOBox%0d - Expected Data: %0h Actual Data: %0h",PeripheralSubSystem_pkt.uart_id,PeripheralSubSystem_pkt.payload,PeripheralSubSystem_pkt.rxData),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
    end
    else if(PeripheralSubSystem_pkt.kind == TRANSMIT) begin
      // Check if input TX data equals bit stream output
      if(PeripheralSubSystem_pkt.payload == PeripheralSubSystem_pkt.txd) begin
        `uvm_info(get_type_name(),$sformatf("------ :: TRANSMIT DMA Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("SerIOBox%0d - Expected Data: %0h Actual Data: %0h",PeripheralSubSystem_pkt.uart_id,PeripheralSubSystem_pkt.payload,PeripheralSubSystem_pkt.txd),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: TRANSMIT DMA MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("SerIOBox%0d - Expected Data: %0h Actual Data: %0h",PeripheralSubSystem_pkt.uart_id,PeripheralSubSystem_pkt.payload,PeripheralSubSystem_pkt.txd),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
    end
  endfunction
endclass: top_scoreboard