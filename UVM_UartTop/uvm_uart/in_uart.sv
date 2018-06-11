//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

interface in_uart ();
  logic ckTb;
  logic arst;

  // Inputs:
  logic                                 rxd;
  logic                                 cts_n;
  logic                                 rxDataReq;
  logic                                 rxDataStall;
  logic [7:0]                           txData;
  logic                                 txDataReady;

  logic                                 ckBrg;

  logic                                 taskStartRx;
  logic                                 taskStartTx;
  logic                                 taskStopRx;
  logic                                 taskStopTx;
  logic                                 taskStopTrx;

  // Outputs:
  logic                                 txd;
  logic                                 txDataRead;
  logic                                 rxDataReady;
  logic                                 rts_n;
  logic [7:0]                           rxData;

  logic                                 eventReadyRx;
  logic                                 eventReadyTx;

  logic                                 uartEnable;
  logic                                 uartRxEnable;
  logic                                 uartTxEnable;

endinterface