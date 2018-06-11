//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

class PeripheralSubSystem_monitor extends uvm_monitor;
  `uvm_component_utils(PeripheralSubSystem_monitor)

  protected int PeripheralSS_id;
  virtual in_PeripheralSubSystem uin_PeripheralSubSystem;

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

    if (!uvm_config_db #(int)::get(this, "", "PeripheralSS_id", PeripheralSS_id))
      `uvm_fatal("NOINT",{"Which SerIOBoxs must be set: ",get_full_name(),".PeripheralSS_id"})

    if (!uvm_config_db #(virtual in_PeripheralSubSystem)::get(null, "", "uin_PeripheralSubSystem", uin_PeripheralSubSystem))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_PeripheralSubSystem"})
  endfunction: build_phase

  // Run_phase - convert the signal level activity to transaction level.
  task run_phase(uvm_phase phase);
    logic [7:0] readData, expData = '0;
    logic [7:0] payloadRx, payloadTx;
    int offset = 0;
    logic [7:0] ramQueue[$];

    forever begin
      fork : la_MonitorRecTrans
        begin
          while(1) begin
            WaitTaskStartRx(PeripheralSS_id);
            while(RxEnable(PeripheralSS_id)) begin
              @(negedge uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3]);
              WaitPosCkBrg(PeripheralSS_id);
              WaitPosCkBrg(PeripheralSS_id);

              payloadRx[0] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[1] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[2] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[3] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[4] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[5] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[6] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];
              WaitPosCkBrg(PeripheralSS_id);
              payloadRx[7] = uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3];

              WaitdmaRxReP(PeripheralSS_id);
              RxDmaData(PeripheralSS_id, readData);

              trans_collected.payload = payloadRx;
              trans_collected.rxData  = readData;
              trans_collected.kind    = RECEIVE;
              trans_collected.uart_id = PeripheralSS_id;

              //Send the transaction to the analysis port
              item_collected_port.write(trans_collected);
              #3us;
            end
          end
        end
        begin
          while(1) begin
            WaitdmaTxWeP(PeripheralSS_id);
            TxDmaData(PeripheralSS_id, offset % 4, expData);
            ramQueue.push_back(expData);
            offset++;
          end
        end
        begin
          while(1) begin
            WaitTxEnable(PeripheralSS_id);
            @(negedge uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1]);
            WaitTxEnable(PeripheralSS_id);
            WaitNegCkBrg(PeripheralSS_id);

            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[0] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[1] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[2] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[3] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[4] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[5] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[6] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);
            payloadTx[7] = uin_PeripheralSubSystem.serIOBoxGpioOut[PeripheralSS_id][1];
            WaitNegCkBrg(PeripheralSS_id);

            trans_collected.payload = ramQueue.pop_front();
            trans_collected.txd     = payloadTx;
            trans_collected.kind    = TRANSMIT;
            trans_collected.uart_id = PeripheralSS_id;

            //Send the transaction to the analysis port
            item_collected_port.write(trans_collected);
          end
        end
      join_any
      disable la_MonitorRecTrans;
    end
  endtask: run_phase

  virtual task WaitNegCkBrg(int serIOBox);
    case(serIOBox)
      0 : @(negedge uin_PeripheralSubSystem.ckBrg0);
      1 : @(negedge uin_PeripheralSubSystem.ckBrg1);
      2 : @(negedge uin_PeripheralSubSystem.ckBrg2);
      3 : @(negedge uin_PeripheralSubSystem.ckBrg3);
    endcase
  endtask

  virtual task WaitPosCkBrg(int serIOBox);
    case(serIOBox)
      0 : @(posedge uin_PeripheralSubSystem.ckBrg0);
      1 : @(posedge uin_PeripheralSubSystem.ckBrg1);
      2 : @(posedge uin_PeripheralSubSystem.ckBrg2);
      3 : @(posedge uin_PeripheralSubSystem.ckBrg3);
    endcase
  endtask

  virtual task WaitdmaTxWeP(int serIOBox);
    case(serIOBox)
      0 : @(posedge uin_PeripheralSubSystem.dmaTxWeP0);
      1 : @(posedge uin_PeripheralSubSystem.dmaTxWeP1);
      2 : @(posedge uin_PeripheralSubSystem.dmaTxWeP2);
      3 : @(posedge uin_PeripheralSubSystem.dmaTxWeP3);
    endcase
  endtask

  virtual task WaitdmaRxReP(int serIOBox);
    case(serIOBox)
      0 : @(posedge uin_PeripheralSubSystem.dmaRxReP0);
      1 : @(posedge uin_PeripheralSubSystem.dmaRxReP1);
      2 : @(posedge uin_PeripheralSubSystem.dmaRxReP2);
      3 : @(posedge uin_PeripheralSubSystem.dmaRxReP3);
    endcase
  endtask

  virtual task WaitTaskStartRx(int serIOBox);
    case(serIOBox)
      0 : @(negedge uin_PeripheralSubSystem.taskStartRx0);
      1 : @(negedge uin_PeripheralSubSystem.taskStartRx1);
      2 : @(negedge uin_PeripheralSubSystem.taskStartRx2);
      3 : @(negedge uin_PeripheralSubSystem.taskStartRx3);
    endcase
  endtask

  virtual task WaitTxEnable(int serIOBox);
    case(serIOBox)
      0 : wait(uin_PeripheralSubSystem.uartTxEnable0);
      1 : wait(uin_PeripheralSubSystem.uartTxEnable1);
      2 : wait(uin_PeripheralSubSystem.uartTxEnable2);
      3 : wait(uin_PeripheralSubSystem.uartTxEnable3);
    endcase
  endtask


  virtual function RxEnable(int serIOBox);
    case(serIOBox)
      0 : begin
          if(uin_PeripheralSubSystem.uartRxEnable0)
            return 1;
          end
      1 : begin
          if(uin_PeripheralSubSystem.uartRxEnable1)
            return 1;
          end
      2 : begin
          if(uin_PeripheralSubSystem.uartRxEnable2)
            return 1;
          end
      3 : begin
          if(uin_PeripheralSubSystem.uartRxEnable3)
            return 1;
          end
    endcase
    return 0;
  endfunction

  virtual task RxDmaData(int serIOBox, output logic [7:0] dmaData);
    logic [7:0] tempData;
    wait(uin_PeripheralSubSystem.ahbHWrite);
    @(posedge uin_PeripheralSubSystem.ckTb);
    #10ns;
    tempData = uin_PeripheralSubSystem.ahbHWData;

    if(serIOBox >= 1) begin
      if(uin_PeripheralSubSystem.ahbHWrite == 1'b1) begin
        @(posedge uin_PeripheralSubSystem.ckTb);
        #10ns;
        tempData = uin_PeripheralSubSystem.ahbHWData;
      end
    end
    if(serIOBox >= 2) begin
      if(uin_PeripheralSubSystem.ahbHWrite == 1'b1) begin
        @(posedge uin_PeripheralSubSystem.ckTb);
        #10ns;
        tempData = uin_PeripheralSubSystem.ahbHWData;
      end
    end
    if(serIOBox == 3) begin
      if(uin_PeripheralSubSystem.ahbHWrite == 1'b1) begin
        @(posedge uin_PeripheralSubSystem.ckTb);
        #10ns;
        tempData = uin_PeripheralSubSystem.ahbHWData;
      end
    end
    dmaData = tempData;
  endtask

  virtual task TxDmaData(int serIOBox, int offset, output logic [7:0] dmaData);
    logic [7:0] tempData;

//    @(negedge uin_PeripheralSubSystem.ahbHSelX);
    #0.08us;
    case (offset)
      0 : tempData = uin_PeripheralSubSystem.ahbHRData[7:0];
      1 : tempData = uin_PeripheralSubSystem.ahbHRData[15:8];
      2 : tempData = uin_PeripheralSubSystem.ahbHRData[23:16];
      3 : tempData = uin_PeripheralSubSystem.ahbHRData[31:24];
    endcase

    dmaData = tempData;
  endtask
endclass: PeripheralSubSystem_monitor