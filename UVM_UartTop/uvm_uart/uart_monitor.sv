//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)

  protected int uart_id;
  protected int num_uart;

  virtual in_uart uin_uart[];

  // Analysis port, to send the transaction to scoreboard
  uvm_analysis_port#(uart_transaction) item_collected_port;

  uart_transaction trans_collected;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction: new

  // Build_phase - getting the interface handle
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(int)::get(this, "", "uart_id", uart_id))
      `uvm_fatal("NOINT",{"Which SerIOBoxs must be set: ",get_full_name(),".uart_id"})

    if (!uvm_config_db #(int)::get(this, "", "num_uart", num_uart))
      `uvm_fatal("NOINT",{"Number of UARTs must be set: ",get_full_name(),".num_uart"})

    uin_uart = new[num_uart];
    for (int i = 0; i < num_uart; i++) begin
      if (!uvm_config_db #(virtual in_uart)::get(null, "uvm_test_top", $sformatf("uin_uart%0d",i), uin_uart[i]))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_uart"})
    end
  endfunction: build_phase

  // Run_phase - convert the signal level activity to transaction level.
  task run_phase(uvm_phase phase);
    logic [7:0] payload;

    forever begin
      fork : la_MonitorReciveTransmit
        begin
          while(1) begin
            @(negedge uin_uart[uart_id].taskStartRx);
            while(uin_uart[uart_id].uartRxEnable) begin
              @(negedge uin_uart[uart_id].rxd);

              @(posedge uin_uart[uart_id].ckBrg);
              trans_collected.start_bit = uin_uart[uart_id].rxd;

              @(posedge uin_uart[uart_id].ckBrg);
              payload[0] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[1] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[2] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[3] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[4] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[5] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[6] = uin_uart[uart_id].rxd;
              @(posedge uin_uart[uart_id].ckBrg);
              payload[7] = uin_uart[uart_id].rxd;

              @(posedge uin_uart[uart_id].ckBrg);
              trans_collected.stop_bits[0] = uin_uart[uart_id].rxd;

              @(posedge uin_uart[uart_id].rxDataReady);
              trans_collected.rxDataReady = uin_uart[uart_id].rxDataReady;
              trans_collected.rxData      = uin_uart[uart_id].rxData;
              trans_collected.kind        = RECEIVE;
              trans_collected.payload     = payload;
              trans_collected.uart_id     = uart_id;

              //Send the transaction to the analysis port
              item_collected_port.write(trans_collected);
              #0.6us;
            end
          end
        end
        begin
          while(1) begin
            @(posedge uin_uart[uart_id].txDataRead);
            trans_collected.payload = uin_uart[uart_id].txData;

            @(negedge uin_uart[uart_id].ckBrg);
            trans_collected.start_bit = uin_uart[uart_id].txd;

            @(negedge uin_uart[uart_id].ckBrg);
            payload[0] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[1] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[2] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[3] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[4] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[5] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[6] = uin_uart[uart_id].txd;
            @(negedge uin_uart[uart_id].ckBrg);
            payload[7] = uin_uart[uart_id].txd;

            @(negedge uin_uart[uart_id].ckBrg);
            trans_collected.stop_bits[0] = uin_uart[uart_id].txd;

            trans_collected.txd     = payload;
            trans_collected.kind    = TRANSMIT;
            trans_collected.uart_id = uart_id;

            //Send the transaction to the analysis port
            item_collected_port.write(trans_collected);
          end
        end
      join
    end
  endtask: run_phase
endclass: uart_monitor