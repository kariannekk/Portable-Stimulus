//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-22
//====================================================================


class test_PeripheralSubSystem extends uvm_test;
  `uvm_component_utils(test_PeripheralSubSystem)

  protected int num_serIOBox;
  virtual in_PeripheralSubSystem uin_PeripheralSubSystem;

  nVipPa_AHBLite5Master::cl_AHBLite5Master ahbDriver;

  logic [31:0] base0, base1, base2, base3;

  localparam RX_OFFSET       = 'h60;
  localparam PSS_DMA_ADDR_HW = 32'h2000_0000;
  localparam PSS_RAM_SIZE    = 32'h0000_8000;

  localparam logic [7:0][31:0] SLAVE_RAM_BADDR =
  '{  '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE*7}, // SLAVE 7: SRAM
      '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE*6}, // SLAVE 6: SRAM
      '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE*5}, // SLAVE 5: SRAM
      '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE*4}, // SLAVE 4: SRAM
      '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE*3}, // SLAVE 3: SRAM
      '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE*2}, // SLAVE 2: SRAM
      '{PSS_DMA_ADDR_HW + PSS_RAM_SIZE  }, // SLAVE 1: SRAM
      '{PSS_DMA_ADDR_HW                 }  // SLAVE 0: SRAM
  };

  localparam logic [pa_Application::NUM_RESOURCES-1:0][pa_Application::DMA_WD+pa_Application::SECUREMAPPING_WD+pa_Application::DOMAIN_WD+pa_Application::INCLUDE_WD+pa_Application::PSS_RES_WD+pa_Application::FRAGMENT_WD+pa_Application::CONFIG_WD-1:0]  PERIPHERAL_CONFIG = pa_Application::fu_GetPeripheralConfig();
  localparam logic [pa_Application::NUM_RESOURCES-1:0][pa_Application::CONFIG_WD-1:0]              APP_PERIPHERAL_INDEXES  = pa_Application::fu_unpackPeripheralConfig(PERIPHERAL_CONFIG, pa_Application::UNPACK_PINDEX);
  localparam logic [pa_Application::NUM_RESOURCES-1:0]                                             APP_PERIPHERAL_INCLUDE  = pa_Application::fu_unpackPeripheralConfig(PERIPHERAL_CONFIG, pa_Application::UNPACK_INCLUDE);
  localparam logic [pa_Application::NUM_RESOURCES-1:0][pa_Application::PSS_RES_WD-1:0]             PSS_RESOURCE_INDEXES    = pa_Application::fu_unpackPeripheralConfig(PERIPHERAL_CONFIG, pa_Application::UNPACK_APB_INDEX_PERI);
  localparam logic [pa_Application::NUM_RESOURCES-1:0][pa_Application::DOMAIN_WD-1:0]              APP_DOMAIN              = pa_Application::fu_unpackPeripheralConfig(PERIPHERAL_CONFIG, pa_Application::UNPACK_DOMAIN);
  localparam logic [pa_PeripheralSubSystem::NUM_PSS_RESOURCES-1:0][pa_Application::CONFIG_WD-1:0]  PSS_PERIPHERAL_INDEXES  = pa_Application::fu_getPSSPeripheralIndexes(APP_PERIPHERAL_INCLUDE, APP_PERIPHERAL_INDEXES, PSS_RESOURCE_INDEXES,APP_DOMAIN);

  top_env env;

  // Sequence instances
  `ifdef INFACT_IMPORT
    infact_uart_receive_transaction_gen       PeripheralSubSystem_rec_seq;
    infact_uart_transmit_transaction_gen      PeripheralSubSystem_trans_seq;
    infact_uart_receive_delay_transaction_gen PeripheralSubSystem_rec_delay_seq0;
    infact_uart_receive_delay_transaction_gen PeripheralSubSystem_rec_delay_seq1;
  `else //UVM RX and TX sequences
    uart_sequence_receive             PeripheralSubSystem_rec_seq;
    uart_sequence_transmit            PeripheralSubSystem_trans_seq;
    uart_sequence_receive_fixed_delay PeripheralSubSystem_rec_delay_seq0;
    uart_sequence_receive_fixed_delay PeripheralSubSystem_rec_delay_seq1;
  `endif

  // Mixed Rx and Tx sequence
  infact_RxTx_seq PeripheralSubSystem_RxTx_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = top_env::type_id::create(.name("env"), .parent(this));

    if (!uvm_config_db #(int)::get(this, "", "num_serIOBox", num_serIOBox))
      `uvm_fatal("NOINT",{"Number of SerIOBoxs must be set: ",get_full_name(),".num_serIOBox"})

    if (!uvm_config_db #(virtual in_PeripheralSubSystem)::get(null, "uvm_test_top", "uin_PeripheralSubSystem", uin_PeripheralSubSystem))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uin_PeripheralSubSystem"})

    ahbDriver = new(.uin_AHBLite5(uin_PeripheralSubSystem.uin_AhbBus), .name("AHB Master"));

    base0 = 'h400_00_000 + (PSS_PERIPHERAL_INDEXES[pa_PeripheralSubSystem::RESOURCE_PSS_SERIOBOX0] << 12);
    base1 = 'h400_00_000 + (PSS_PERIPHERAL_INDEXES[pa_PeripheralSubSystem::RESOURCE_PSS_SERIOBOX1] << 12);
    base2 = 'h400_00_000 + (PSS_PERIPHERAL_INDEXES[pa_PeripheralSubSystem::RESOURCE_PSS_SERIOBOX2] << 12);
    base3 = 'h400_00_000 + (PSS_PERIPHERAL_INDEXES[pa_PeripheralSubSystem::RESOURCE_PSS_SERIOBOX3] << 12);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(.obj(this));

    @(negedge uin_PeripheralSubSystem.arst);

    // Init RAM data (set to random values)
    uin_PeripheralSubSystem.fu_InitRamData();

    `ifdef INFACT_RXTX
      ta_ReceiveAndTransmit();
    `else
      ta_Receive();
      #10us;
      ta_Transmit();
      #10us;
      ta_ReceiveDmaPriority();
    `endif

    phase.drop_objection(.obj(this));
  endtask: run_phase

  virtual task ta_Receive();
    int ramIndexRx = 0;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_RECEIVE :: ------"),UVM_LOW)

    // Select GPIO pin for RXD
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data('h2), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data('h3), .size(4));

    // Set DMA size and DMA memory location from UART
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE), .data(64), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR), .data(SLAVE_RAM_BADDR[ramIndexRx]+RX_OFFSET), .size(4));

    // Enable UART in SerIOBox
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE), .data('h8), .size(4));

    // Enable RX
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX), .data('h1), .size(4));

    // Call receive sequences
    PeripheralSubSystem_rec_seq = new();
    PeripheralSubSystem_rec_seq.start(env.PeripheralSubSystem0.agent[0].sequencer);

    // Disable
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_RX), .data('h1), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE),           .data(pa_SerIOBox::RV_SERIOBOX_ENABLE), .size(4)); 
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data(pa_SerIOBox::RV_SERIOBOX_SER_PIN_SELECT_0), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data(pa_SerIOBox::RV_SERIOBOX_SER_PIN_SELECT_1), .size(4));
  endtask

  virtual task ta_Transmit();
    int ramIndexTx = 1;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_TRANSMIT :: ------"),UVM_LOW)

    // Set DMA size and DMA memory location from UART
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_BUFFER_SIZE), .data(10), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_MEMORY_ADDR), .data(SLAVE_RAM_BADDR[ramIndexTx]), .size(4));

    // Enable UART in SerIOBox
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE), .data('h8), .size(4));

    // Call transmit sequences
    PeripheralSubSystem_trans_seq = new();
    PeripheralSubSystem_trans_seq.start(env.PeripheralSubSystem0.agent[0].sequencer);

    // Enable TX
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_TX), .data('h1), .size(4));

    wait(uin_PeripheralSubSystem.eventTxCompleted0);
    #5us;

    // Disable
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_TX), .data('h1), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE),           .data(pa_SerIOBox::RV_SERIOBOX_ENABLE), .size(4)); 
  endtask

  task ta_ReceiveDmaPriority();
    int ramIndexRx = 0;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_RECEIVEDMA :: ------"),UVM_LOW)

    // Select GPIO pin for RXD
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data('h2), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data('h3), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data('h4), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data('h5), .size(4));

    // Set DMA size and DMA memory location from UART
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE), .data(64), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR), .data(SLAVE_RAM_BADDR[ramIndexRx]+RX_OFFSET), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE), .data(64), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR), .data(SLAVE_RAM_BADDR[ramIndexRx]+RX_OFFSET + 4*'h2), .size(4));

    // Set Prioity for DMA transfer
    // ahbDriver.ta_simpleWrite(.addr(('h400_00_000 + (PSS_PERIPHERAL_INDEXES[pa_PeripheralSubSystem::RESOURCE_PSS_PAMLI]<<12)) + 'hE00), .data('hFFFFFFFF), .size(4));

    // Enable UART in SerIOBox
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE), .data('h8), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_ENABLE), .data('h8), .size(4));

    // Enable RX
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX), .data('h1), .size(4));
    #3.584us; //Delay for synchronizing ckBrg for UART0 and UART1
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX), .data('h1), .size(4));

    // Call receive sequences
    PeripheralSubSystem_rec_delay_seq0 = new();
    PeripheralSubSystem_rec_delay_seq1 = new();

    fork
      PeripheralSubSystem_rec_delay_seq0.start(env.PeripheralSubSystem0.agent[0].sequencer);
      PeripheralSubSystem_rec_delay_seq1.start(env.PeripheralSubSystem0.agent[1].sequencer);
    join

    // Disable
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE),           .data(pa_SerIOBox::RV_SERIOBOX_ENABLE), .size(4)); 
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data(pa_SerIOBox::RV_SERIOBOX_SER_PIN_SELECT_0), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data(pa_SerIOBox::RV_SERIOBOX_SER_PIN_SELECT_1), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_ENABLE),           .data(pa_SerIOBox::RV_SERIOBOX_ENABLE), .size(4)); 
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data(pa_SerIOBox::RV_SERIOBOX_SER_PIN_SELECT_0), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base1+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data(pa_SerIOBox::RV_SERIOBOX_SER_PIN_SELECT_1), .size(4));
  endtask

  task ta_ReceiveAndTransmit();
    int ramIndexRx = 0;
    int ramIndexTx = 1;
    `uvm_info(get_type_name(),$sformatf("------ :: TA_RECEIVEANDTRANSMIT :: ------"),UVM_LOW)

    // Select GPIO pin for RXD
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_0), .data('h2), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_SER_PIN_SELECT_1), .data('h3), .size(4));

    // Set DMA size and DMA memory location from UART
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_BUFFER_SIZE), .data(64), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_RX_MEMORY_ADDR), .data(SLAVE_RAM_BADDR[ramIndexRx]+RX_OFFSET), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_BUFFER_SIZE), .data(10), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_DMA_CHANNEL_PERIPHERAL_TX_MEMORY_ADDR), .data(SLAVE_RAM_BADDR[ramIndexTx]), .size(4));

    // Enable UART in SerIOBox
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE), .data('h8), .size(4));

    // Enable RX
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_RX), .data('h1), .size(4));

    // Call receive sequences
    PeripheralSubSystem_RxTx_seq = new();
    PeripheralSubSystem_RxTx_seq.start(env.PeripheralSubSystem0.agent[0].sequencer);

    // Enable TX
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_START_TX), .data('h1), .size(4));

    wait(uin_PeripheralSubSystem.eventTxCompleted0);
    #5us;

    // Disable
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_TX), .data('h1), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_TASK_TRIG_STOP_RX), .data('h1), .size(4));
    ahbDriver.ta_simpleWrite(.addr(base0+pa_SerIOBox::ID_SERIOBOX_ENABLE),           .data(pa_SerIOBox::RV_SERIOBOX_ENABLE), .size(4)); 
  endtask

endclass: test_PeripheralSubSystem