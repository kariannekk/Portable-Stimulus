//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

`uvm_analysis_imp_decl ( _uart )
`uvm_analysis_imp_decl ( _par )

class top_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(top_scoreboard)

  // Control register for Write/Read
  bit [31:0] sc_mem [4095];

  // Ports to recive packets from monitor
  uvm_analysis_imp_uart#(uart_transaction, top_scoreboard) item_collected_export_uart;
  uvm_analysis_imp_par#(par_transaction, top_scoreboard)  item_collected_export_par;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Build_phase - create port and initialize local memory
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export_uart = new("item_collected_export_uart", this);
    item_collected_export_par  = new("item_collected_export_par", this);
    foreach(sc_mem[i]) sc_mem[i] = 32'hxxxx_xxxx;
  endfunction: build_phase
  
  // Write task - recives the pkt from monitor and pushes into queue
  virtual function void write_uart(uart_transaction pkt);
    uart_trans(pkt);
  endfunction

  virtual function void write_par(par_transaction pkt);
    par_trans(pkt);
  endfunction

  virtual function void uart_trans(uart_transaction uart_pkt);

    if(uart_pkt.kind == RECEIVE) begin
      if(uart_pkt.start_bit != 1'b0)
        `uvm_error(get_type_name(),"------ :: RECEIVE START BIT mismatch :: ------")

      // Check if bit stream input equals output RX data
      if(uart_pkt.payload == uart_pkt.rxData) begin
        `uvm_info(get_type_name(),$sformatf("------ :: RECEIVE Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",uart_pkt.payload,uart_pkt.rxData),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: RECEIVE MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",uart_pkt.payload,uart_pkt.rxData),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end

      if(uart_pkt.stop_bits[0] != 1'b1)
        `uvm_error(get_type_name(),"------ :: TRANSMIT STOP BIT ONE mismatch :: ------")
    end
    else if(uart_pkt.kind == TRANSMIT) begin
      if(uart_pkt.start_bit != 1'b0)
        `uvm_error(get_type_name(),"------ :: TRANSMIT START BIT mismatch :: ------")

      // Check if input TX data equals bit stream output
      if(uart_pkt.payload == uart_pkt.txd) begin
        `uvm_info(get_type_name(),$sformatf("------ :: TRANSMIT Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",uart_pkt.payload,uart_pkt.txd),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: TRANSMIT MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",uart_pkt.payload,uart_pkt.txd),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end

      if(uart_pkt.stop_bits[0] != 1'b1)
        `uvm_error(get_type_name(),"------ :: TRANSMIT STOP BIT ONE mismatch :: ------")
    end

  endfunction

  virtual function void par_trans(par_transaction par_pkt);
    if(par_pkt.inst == WRITE) begin
    sc_mem[par_pkt.parAddr] = par_pkt.parDo;
    `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("parAddr: %0h",par_pkt.parAddr),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("Data: %0h",par_pkt.parDo),UVM_LOW)
    `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)        
    end
    else if(par_pkt.inst == READ) begin
      if(sc_mem[par_pkt.parAddr] == par_pkt.parDi) begin
        `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("parAddr: %0h",par_pkt.parAddr),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[par_pkt.parAddr],par_pkt.parDi),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
        `uvm_info(get_type_name(),$sformatf("parAddr: %0h",par_pkt.parAddr),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[par_pkt.parAddr],par_pkt.parDi),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
      end
    end
  endfunction
endclass: top_scoreboard