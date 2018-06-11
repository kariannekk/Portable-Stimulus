//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class uart_driver extends uvm_driver#(uart_transaction);
  `uvm_component_utils(uart_driver)

  virtual in_uart uin_uart;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual in_uart)::get(this, "", "uin_uart", uin_uart))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".uin_uart"});
  endfunction: build_phase

  // Run phase - transaction level to signal level
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      case (req.kind)
        RECEIVE:  receive();
        TRANSMIT: transmit();
      endcase

      seq_item_port.item_done();
    end
  endtask: run_phase

  virtual task receive();
    // Start bit
    repeat(req.delay)
      @(posedge uin_uart.ckBrg);
    #10ns;
    uin_uart.rxd = req.start_bit;

    // Payload
    for (int i = 0; i < 8; i++) begin
      @(posedge uin_uart.ckBrg);
      uin_uart.rxd = req.payload[i];
    end

    // Stop bit
    @(posedge uin_uart.ckBrg);
    uin_uart.rxd = req.stop_bits[0];
    if(req.stop_type == TWO_STOP_BITS) begin
      @(posedge uin_uart.ckBrg);
      uin_uart.rxd = req.stop_bits[1];
    end

    @(posedge uin_uart.rxDataReady);

    @(posedge uin_uart.ckBrg);
    uin_uart.rxDataReq = 1'b1;

    @(posedge uin_uart.ckBrg);
    uin_uart.rxDataReq = 1'b0;
  endtask : receive

  virtual task transmit();
    repeat(req.delay)
      @(posedge uin_uart.ckBrg);

    @(posedge uin_uart.ckBrg);
    @(posedge uin_uart.ckTb);
    uin_uart.txData = req.payload;

    @(posedge uin_uart.ckBrg);
    uin_uart.txDataReady = 1'b1;

    @(posedge uin_uart.txDataRead);
    @(posedge uin_uart.ckTb);
    uin_uart.txDataReady = 1'b0;

    // Wait for transmittion to finish
    repeat(9)
      @(posedge uin_uart.ckBrg);

    if(req.stop_type == TWO_STOP_BITS) begin
      @(posedge uin_uart.ckBrg);
    end

    @(posedge uin_uart.ckBrg);
  endtask : transmit
endclass: uart_driver