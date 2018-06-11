//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================

class PeripheralSubSystem_driver extends uvm_driver#(uart_transaction);
  `uvm_component_utils(PeripheralSubSystem_driver)

  int offset = 0;

  protected int PeripheralSS_id;
  virtual in_PeripheralSubSystem uin_PeripheralSubSystem;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(int)::get(this, "", "PeripheralSS_id", PeripheralSS_id))
      `uvm_fatal("NOINT",{"Which SerIOBoxs must be set: ",get_full_name(),".PeripheralSS_id"})

    if (!uvm_config_db #(virtual in_PeripheralSubSystem)::get(null, "", "uin_PeripheralSubSystem", uin_PeripheralSubSystem))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_PeripheralSubSystem"})
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
    uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3] = '1 ; //RXD

    repeat(req.delay)
      WaitPosCkBrg(PeripheralSS_id);

    uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][0] = 0;
    WaitNegCkBrg(PeripheralSS_id);
    uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3] =  0; //RXD 

    for(int k=0; k<9; k++) begin
      WaitNegCkBrg(PeripheralSS_id);
      if(k<8)
        uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3] =  req.payload[k]; //RXD
      else
        uin_PeripheralSubSystem.serIOBoxGpioIn[PeripheralSS_id][3] = '1 ; //RXD
    end

    WaitdmaRxReP(PeripheralSS_id);
  endtask : receive


  virtual task transmit();
    uin_PeripheralSubSystem.fu_SetRamByte(offset, 1, req.payload);
    offset++;
  endtask : transmit

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
      0 : @(negedge uin_PeripheralSubSystem.dmaRxReP0);
      1 : @(negedge uin_PeripheralSubSystem.dmaRxReP1);
      2 : @(negedge uin_PeripheralSubSystem.dmaRxReP2);
      3 : @(negedge uin_PeripheralSubSystem.dmaRxReP3);
    endcase
  endtask
endclass: PeripheralSubSystem_driver