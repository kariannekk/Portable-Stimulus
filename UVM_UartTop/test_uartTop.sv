//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-04-06
//====================================================================

class test_uartTop extends uvm_test;
  `uvm_component_utils(test_uartTop)

  localparam [31:0] UART_BASE0 = pa_AppBaseAddr::APP_UARTE0;
  localparam [31:0] UART_BASE1 = pa_AppBaseAddr::APP_UARTE1;
  localparam [31:0] UART_BASE2 = pa_AppBaseAddr::APP_UARTE2;
  localparam [31:0] UART_BASE3 = pa_AppBaseAddr::APP_UARTE3;

  protected int num_serIOBox;
  virtual inTb_Princess uin_Tb;
  virtual in_PeripheralSubSystem uin_PeripheralSubSystem;

  top_env env;

  // Sequence instances
  `ifdef INFACT_IMPORT
    infact_uart_receive_transaction_gen       uartTop_rec_seq;
    infact_uart_transmit_transaction_gen      uartTop_trans_seq;
    infact_uart_receive_delay_transaction_gen uartTop_rec_delay_seq0;
    infact_uart_receive_delay_transaction_gen uartTop_rec_delay_seq1;
  `else 
    uart_sequence_receive             uartTop_rec_seq;
    uart_sequence_transmit            uartTop_trans_seq;
    uart_sequence_receive_fixed_delay uartTop_rec_delay_seq0;
    uart_sequence_receive_fixed_delay uartTop_rec_delay_seq1;
  `endif

  // Mixed Rx and Tx sequence
  infact_RxTx_seq uartTop_RxTx_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = top_env::type_id::create(.name("env"), .parent(this));

    if (!uvm_config_db #(int)::get(this, "", "num_serIOBox", num_serIOBox))
      `uvm_fatal("NOINT",{"Number of SerIOBoxs must be set: ",get_full_name(),".num_serIOBox"})

    if (!uvm_config_db #(virtual inTb_Princess)::get(null, "uvm_test_top", "uin_Tb", uin_Tb))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_Tb"})

    if (!uvm_config_db #(virtual in_PeripheralSubSystem)::get(null, "uvm_test_top", "uin_PeripheralSubSystem", uin_PeripheralSubSystem))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_PeripheralSubSystem"})
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(.obj(this));

    ta_waitInit();

    `ifdef INFACT_RXTX
      ta_ReceiveAndTransmit(0);
      #10us;
      ta_ReceiveAndTransmit(1);
      #10us;
      ta_ReceiveAndTransmit(2);
      #10us;
      ta_ReceiveAndTransmit(3);
    `else 
      ta_Receive(0);
      #10us;
      ta_Transmit(0);
      #10us;
      ta_Receive(1);
      #10us;
      ta_Transmit(1);
      #10us;
      ta_Receive(2);
      #10us;
      ta_Transmit(2);
      #10us;
      ta_Receive(3);
      #10us;
      ta_Transmit(3);
      #10us;
      ta_ReceiveDmaConflic();
    `endif

    phase.drop_objection(.obj(this));
  endtask: run_phase

  virtual task ta_Receive(int uart);
    logic [7:0]  rxBufSize;
    int          rxPtrBase;
    logic [31:0] uartBase;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_RECEIVE UART%0d :: ------", uart),UVM_LOW)

    if(uart == 0)
      uartBase = UART_BASE0;
    if(uart == 1)
      uartBase = UART_BASE1;
    if(uart == 2)
      uartBase = UART_BASE2;
    if(uart == 3)
      uartBase = UART_BASE3;

    // Select GPIOs for RX and TX
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0, .data(0 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1, .data(1 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_2, .data(2 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_3, .data(3 + 4*uart));

    // Enable UART with DMA
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_ENABLE, .data('h8));

    // Configure memory pointers and buffer size
    rxPtrBase = pa_Memories::APP_SRAM_END-(1*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM7_START-16
    rxBufSize = 50;
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE, .data(rxBufSize));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR, .data(rxPtrBase));

    // Start transfer
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX, .data('b1));

    // Call receive sequences
    uartTop_rec_seq = new();
    uartTop_rec_seq.start(env.uartTop0.agent[uart].sequencer);

    // Disable
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_RX, .data('h1));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_ENABLE,            .data('h0));
  endtask

  virtual task ta_Transmit(int uart);
    logic [7:0]  txBufSize;
    int          txPtrBase;
    logic [31:0] uartBase;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_TRANSMIT UART%0d :: ------", uart),UVM_LOW)

    if(uart == 0)
      uartBase = UART_BASE0;
    if(uart == 1)
      uartBase = UART_BASE1;
    if(uart == 2)
      uartBase = UART_BASE2;
    if(uart == 3)
      uartBase = UART_BASE3;

    // Select GPIOs for RX and TX
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0, .data(0 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1, .data(1 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_2, .data(2 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_3, .data(3 + 4*uart));

    // Enable UART with DMA
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_ENABLE, .data('h8));

    // Configure memory pointers and buffer size
    txPtrBase = pa_Memories::APP_SRAM_END-(2*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM6_START-16
    txBufSize = 10;
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_BUFFER_SIZE, .data(txBufSize));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_MEMORY_ADDR, .data(txPtrBase));

    // Call transmit sequences
    uartTop_trans_seq = new();
    uartTop_trans_seq.start(env.uartTop0.agent[uart].sequencer);

    // Start transfer
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_TX, .data('b1));

    if(uart == 0)
      wait(uin_PeripheralSubSystem.eventTxCompleted0);
    if(uart == 1)
      wait(uin_PeripheralSubSystem.eventTxCompleted1);
    if(uart == 2)
      wait(uin_PeripheralSubSystem.eventTxCompleted2);
    if(uart == 3)
      wait(uin_PeripheralSubSystem.eventTxCompleted3);
    #5us;

    // Disable
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_TX, .data('h1));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_ENABLE,            .data('h0));
  endtask

  virtual task ta_ReceiveDmaConflic();
    logic [7:0] rxBufSize;
    int         rxPtrBase;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_RECEIVEDMA :: ------"),UVM_LOW)

    // Select GPIOs for RX and TX
    // UART0
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0, .data(0));
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1, .data(1));
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_2, .data(2));
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_3, .data(3));
    // UART1
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0, .data(4));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1, .data(5));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_2, .data(6));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_3, .data(7));

    // Enable UART with DMA
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_ENABLE, .data('h8));
    #3.959us; //Delay for synchronizing ckBrg for UART0 and UART1
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_ENABLE, .data('h8));

    // Configure memory pointers and buffer size
    rxPtrBase = pa_Memories::APP_SRAM_END-(1*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM7_START-16
    rxBufSize = 50;
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE, .data(rxBufSize));
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR, .data(rxPtrBase));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE, .data(rxBufSize));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR, .data(rxPtrBase));

    // Start transfer
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX, .data('b1));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX, .data('b1));

    // Call receive sequences
    uartTop_rec_delay_seq0 = new();
    uartTop_rec_delay_seq1 = new();

    fork
      uartTop_rec_delay_seq0.start(env.uartTop0.agent[0].sequencer);
      uartTop_rec_delay_seq1.start(env.uartTop0.agent[1].sequencer);
    join

    // Disable
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_RX, .data('h1));
    ta_UartWrite(UART_BASE0 + pa_SerIOBox::ID_SERIOBOX_ENABLE,            .data('h0));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_RX, .data('h1));
    ta_UartWrite(UART_BASE1 + pa_SerIOBox::ID_SERIOBOX_ENABLE,            .data('h0));
  endtask

  virtual task ta_ReceiveAndTransmit(int uart);
    logic [7:0]  rxBufSize, txBufSize;
    int          rxPtrBase, txPtrBase;
    logic [31:0] uartBase;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_RECEIVEANDTRANSMIT UART%0d :: ------", uart),UVM_LOW)

    if(uart == 0)
      uartBase = UART_BASE0;
    if(uart == 1)
      uartBase = UART_BASE1;
    if(uart == 2)
      uartBase = UART_BASE2;
    if(uart == 3)
      uartBase = UART_BASE3;

    // Select GPIOs for RX and TX
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0, .data(0 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1, .data(1 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_2, .data(2 + 4*uart));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_3, .data(3 + 4*uart));

    // Enable UART with DMA
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_ENABLE, .data('h8));

    // Configure memory pointers and buffer size
    rxPtrBase = pa_Memories::APP_SRAM_END-(1*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM7_START-16
    rxBufSize = 50;
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE, .data(rxBufSize));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR, .data(rxPtrBase));
    txPtrBase = pa_Memories::APP_SRAM_END-(2*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM6_START-16
    txBufSize = 10;
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_BUFFER_SIZE, .data(txBufSize));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_MEMORY_ADDR, .data(txPtrBase));

    // Start transfer
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX, .data('b1));

    // Call receive sequences
    uartTop_RxTx_seq = new();
    uartTop_RxTx_seq.start(env.uartTop0.agent[uart].sequencer);

    // Start transfer
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_TX, .data('b1));

    if(uart == 0)
      wait(uin_PeripheralSubSystem.eventTxCompleted0);
    if(uart == 1)
      wait(uin_PeripheralSubSystem.eventTxCompleted1);
    if(uart == 2)
      wait(uin_PeripheralSubSystem.eventTxCompleted2);
    if(uart == 3)
      wait(uin_PeripheralSubSystem.eventTxCompleted3);
    #5us;

    // Disable
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_TX, .data('h1));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_RX, .data('h1));
    ta_UartWrite(uartBase + pa_SerIOBox::ID_SERIOBOX_ENABLE,            .data('h0));
  endtask

  virtual task ta_waitInit();
    logic [7:0] ramDataMatrix[$];
    int         txPtrBase;

    wait(uin_Tb.uin_DevA.uin_Ctrl.simTestInit);
    #10us;
    uin_Tb.uin_DevA.uin_Ctrl.enableAppAhbOverride = 1;

    // RTS
    uin_Tb.uin_DevA.GPIO[0].ctrl.en_control  = 0;
    uin_Tb.uin_DevA.GPIO[0].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[4].ctrl.en_control  = 0;
    uin_Tb.uin_DevA.GPIO[4].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[8].ctrl.en_control  = 0;
    uin_Tb.uin_DevA.GPIO[8].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[12].ctrl.en_control = 0;
    uin_Tb.uin_DevA.GPIO[12].ctrl.en_biDir   = 0;
    
    // TXD
    uin_Tb.uin_DevA.GPIO[1].ctrl.en_control  = 0;
    uin_Tb.uin_DevA.GPIO[1].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[5].ctrl.en_control  = 0;
    uin_Tb.uin_DevA.GPIO[5].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[9].ctrl.en_control  = 0;
    uin_Tb.uin_DevA.GPIO[9].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[13].ctrl.en_control = 0;
    uin_Tb.uin_DevA.GPIO[13].ctrl.en_biDir   = 0;

    // CTS
    uin_Tb.uin_DevA.GPIO[2].ctrl.en_control  = 1;
    uin_Tb.uin_DevA.GPIO[2].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[2].ctrl.in          = 0;
    uin_Tb.uin_DevA.GPIO[6].ctrl.en_control  = 1;
    uin_Tb.uin_DevA.GPIO[6].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[6].ctrl.in          = 0;
    uin_Tb.uin_DevA.GPIO[10].ctrl.en_control = 1;
    uin_Tb.uin_DevA.GPIO[10].ctrl.en_biDir   = 0;
    uin_Tb.uin_DevA.GPIO[10].ctrl.in         = 0;
    uin_Tb.uin_DevA.GPIO[14].ctrl.en_control = 1;
    uin_Tb.uin_DevA.GPIO[14].ctrl.en_biDir   = 0;
    uin_Tb.uin_DevA.GPIO[14].ctrl.in         = 0;

    // RXD
    uin_Tb.uin_DevA.GPIO[3].ctrl.en_control  = 1;
    uin_Tb.uin_DevA.GPIO[3].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[3].ctrl.in          = 1;
    uin_Tb.uin_DevA.GPIO[7].ctrl.en_control  = 1;
    uin_Tb.uin_DevA.GPIO[7].ctrl.en_biDir    = 0;
    uin_Tb.uin_DevA.GPIO[7].ctrl.in          = 1;
    uin_Tb.uin_DevA.GPIO[11].ctrl.en_control = 1;
    uin_Tb.uin_DevA.GPIO[11].ctrl.en_biDir   = 0;
    uin_Tb.uin_DevA.GPIO[11].ctrl.in         = 1;
    uin_Tb.uin_DevA.GPIO[15].ctrl.en_control = 1;
    uin_Tb.uin_DevA.GPIO[15].ctrl.en_biDir   = 0;
    uin_Tb.uin_DevA.GPIO[15].ctrl.in         = 1;

    // Turn on RAM blocks and Fill TX RAM buffer
    txPtrBase = pa_Memories::APP_SRAM_END-(2*pa_Memories::RAM_SIZE)+1-16; // APP_SRAM6_START-16
    for (int j = 0; j < 50; j++) begin  
      ramDataMatrix[j] = $urandom;
      uin_Tb.uin_DevA.uin_Tasks.APPMCU.uin_AppSram_Tasks.memset(.addr(txPtrBase+j), .data(ramDataMatrix[j]));
    end
  endtask

  virtual task ta_UartWrite(input logic [31:0] addr, input logic [31:0] data, input int size = 4);
    uin_Tb.uin_DevA.APPMCU.ahbDriver.ta_simpleWrite(.addr(addr), .data(data), .size(size));
  endtask
endclass: test_uartTop