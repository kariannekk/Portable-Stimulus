//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-04-06
//====================================================================

class uartTop_driver extends uvm_driver#(uart_transaction);
  `uvm_component_utils(uartTop_driver)

  int offset = 0;

  protected int serIOBox_id;
  virtual inTb_Princess uin_Tb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(int)::get(this, "", "serIOBox_id", serIOBox_id))
      `uvm_fatal("NOINT",{"Which SerIOBoxs must be set: ",get_full_name(),".serIOBox_id"})

    if(!uvm_config_db#(virtual inTb_Princess)::get(this, "", "uin_Tb", uin_Tb))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".uin_Tb"});
  endfunction: build_phase

  // Run - transaction level to signal level
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
    WrGpio(serIOBox_id, 3, 1'b1); //RXD 

    repeat(req.delay)
      WaitPosCkBrg(serIOBox_id);

    WaitNegCkBrg(serIOBox_id);

    WrGpio(serIOBox_id, 3, 1'b0); //RXD 

    for(int k=0; k<9; k++) begin
      WaitNegCkBrg(serIOBox_id);
      if(k<8)
        WrGpio(serIOBox_id, 3, req.payload[k]); //RXD 
      else
        WrGpio(serIOBox_id, 3, 1'b1); //RXD 
    end

    WaitRxReady(serIOBox_id);

  endtask : receive

  virtual task transmit();
    int txPtrBase = pa_Memories::APP_SRAM_END-(2*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM6_START-16
    uin_Tb.uin_DevA.uin_Tasks.APPMCU.uin_AppSram_Tasks.memset(.addr(txPtrBase+offset), .data(req.payload));

    offset++;
  endtask : transmit

  virtual task WrGpio(int serIOBox, int gpio, logic in);
    case(serIOBox)
      0 : begin
        if(gpio == 3)
          uin_Tb.uin_DevA.GPIO[3].ctrl.in =  in;
        else if(gpio == 2)
          uin_Tb.uin_DevA.GPIO[2].ctrl.in =  in;
      end
      1 : begin
        if(gpio == 3)
          uin_Tb.uin_DevA.GPIO[7].ctrl.in =  in;
        else if(gpio == 2)
          uin_Tb.uin_DevA.GPIO[6].ctrl.in =  in;
      end
      2 : begin
        if(gpio == 3)
          uin_Tb.uin_DevA.GPIO[11].ctrl.in =  in;
        else if(gpio == 2)
          uin_Tb.uin_DevA.GPIO[10].ctrl.in =  in;
      end
      3 : begin
        if(gpio == 3)
          uin_Tb.uin_DevA.GPIO[15].ctrl.in =  in;
        else if(gpio == 2)
          uin_Tb.uin_DevA.GPIO[14].ctrl.in =  in;
      end
    endcase
  endtask

  virtual task WaitGpio(int serIOBox);
    case(serIOBox)
      0 : @(negedge uin_Tb.uin_DevA.GPIO[1].ctrl.out);
      1 : @(negedge uin_Tb.uin_DevA.GPIO[5].ctrl.out);
      2 : @(negedge uin_Tb.uin_DevA.GPIO[9].ctrl.out);
      3 : @(negedge uin_Tb.uin_DevA.GPIO[13].ctrl.out);
    endcase
  endtask

  virtual task WaitNegCkBrg(int serIOBox);
    case(serIOBox)
      0 : @(negedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_UartPcgc.ckBrg);
      1 : @(negedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart1Pcgc.ckBrg);
      2 : @(negedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart2Pcgc.ckBrg);
      3 : @(negedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart3Pcgc.ckBrg);
    endcase
  endtask

  virtual task WaitPosCkBrg(int serIOBox);
    case(serIOBox)
      0 : @(posedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_UartPcgc.ckBrg);
      1 : @(posedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart1Pcgc.ckBrg);
      2 : @(posedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart2Pcgc.ckBrg);
      3 : @(posedge uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart3Pcgc.ckBrg);
    endcase
  endtask

  virtual task WaitRxReady(int serIOBox);
    case(serIOBox)
      0 : wait(uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_UartPpi.eventRxDataReady);
      1 : wait(uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart1Ppi.eventRxDataReady);
      2 : wait(uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart2Ppi.eventRxDataReady);
      3 : wait(uin_Tb.uin_DevA.APPMCU.uin_AppPer.uin_Uart3Ppi.eventRxDataReady);
    endcase
  endtask
endclass: uartTop_driver