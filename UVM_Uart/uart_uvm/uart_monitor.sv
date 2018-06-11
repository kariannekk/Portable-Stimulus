//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)

  virtual in_uart uin_uart;

  // Analysis port, to send the transaction to scoreboard
  uvm_analysis_port#(uart_transaction) item_collected_port;

  uart_transaction trans_collected;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    trans_collected     = new();
    item_collected_port = new("item_collected_port", this);
  endfunction: new

  // Build_phase - getting the interface handle
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual in_uart)::get(this, "", "uin_uart", uin_uart))
       `uvm_fatal("NO uin_ParBus",{"virtual interface must be set for: ",get_full_name(),".uin_uart"});
  endfunction: build_phase

  // Run_phase - convert the signal level activity to transaction level.
  task run_phase(uvm_phase phase);
    logic [7:0] payload;

    forever begin
      fork : la_MonitorReciveTransmit
        begin
          @(negedge uin_uart.rxd);

          @(negedge uin_uart.ckBrg);
          trans_collected.start_bit = uin_uart.rxd;

          @(negedge uin_uart.ckBrg);
          payload[0] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[1] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[2] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[3] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[4] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[5] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[6] = uin_uart.rxd;
          @(negedge uin_uart.ckBrg);
          payload[7] = uin_uart.rxd;

          @(negedge uin_uart.ckBrg);
          trans_collected.stop_bits[0] = uin_uart.rxd;

          @(posedge uin_uart.rxDataReady);
          trans_collected.rxDataReady = uin_uart.rxDataReady;
          trans_collected.rxData      = uin_uart.rxData;
          trans_collected.kind        = RECEIVE;
          trans_collected.payload     = payload;
        end

        begin
          @(negedge uin_uart.txd);

          @(negedge uin_uart.ckBrg);
          trans_collected.start_bit = uin_uart.txd;

          @(negedge uin_uart.ckBrg);
          payload[0] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[1] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[2] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[3] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[4] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[5] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[6] = uin_uart.txd;
          @(negedge uin_uart.ckBrg);
          payload[7] = uin_uart.txd;

          @(negedge uin_uart.ckBrg);
          trans_collected.stop_bits[0] = uin_uart.txd;

          trans_collected.txd     = payload;
          trans_collected.kind    = TRANSMIT;
          trans_collected.payload = uin_uart.txData;
        end
      join_any
      disable la_MonitorReciveTransmit;

      //Send the transaction to the analysis port
      item_collected_port.write(trans_collected);
    end

  endtask: run_phase
endclass: uart_monitor