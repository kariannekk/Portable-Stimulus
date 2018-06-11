//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

class uart_driver extends uvm_driver#(uart_transaction);
  `uvm_component_utils(uart_driver)

  protected int uart_id;
  protected int num_uart;

  virtual in_uart uin_uart[];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

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
      @(posedge uin_uart[uart_id].ckBrg);
    #10ns;
    uin_uart[uart_id].rxd = req.start_bit;

    // Payload
    for (int i = 0; i < 8; i++) begin
      @(posedge uin_uart[uart_id].ckBrg);
      uin_uart[uart_id].rxd = req.payload[i];
    end

    // Stop bit
    @(posedge uin_uart[uart_id].ckBrg);
    uin_uart[uart_id].rxd = req.stop_bits[0];
    if(req.stop_type == TWO_STOP_BITS) begin
      @(posedge uin_uart[uart_id].ckBrg);
      uin_uart[uart_id].rxd = req.stop_bits[1];
    end

    @(posedge uin_uart[uart_id].rxDataReady);

    @(posedge uin_uart[uart_id].ckBrg);
    uin_uart[uart_id].rxDataReq = 1'b1;

    @(posedge uin_uart[uart_id].ckBrg);
    uin_uart[uart_id].rxDataReq = 1'b0;

  endtask : receive

  virtual task transmit();
    repeat(req.delay)
      @(posedge uin_uart[uart_id].ckBrg);

    @(posedge uin_uart[uart_id].ckBrg);
    @(posedge uin_uart[uart_id].ckTb);
    uin_uart[uart_id].txData = req.payload;

    @(posedge uin_uart[uart_id].ckBrg);
    uin_uart[uart_id].txDataReady = 1'b1;

    @(posedge uin_uart[uart_id].txDataRead);
    @(posedge uin_uart[uart_id].ckTb);
    uin_uart[uart_id].txDataReady = 1'b0;

    // Wait for transmittion to finish
    repeat(9)
      @(posedge uin_uart[uart_id].ckBrg);

    if(req.stop_type == TWO_STOP_BITS) begin
      @(posedge uin_uart[uart_id].ckBrg);
    end

    @(posedge uin_uart[uart_id].ckBrg);
  endtask : transmit
endclass: uart_driver