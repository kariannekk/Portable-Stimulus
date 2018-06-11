#include "infact_uart_RxTx_static.h"
#include "infact_uart_RxTx.h"

int main(void){

  //Instantiate test engine manager and inFact sequence
  infact_sdv_te_mgr te_mgr;
  infact_uart_RxTx_t *seq;
  
  //Create test engine manager with static C code
  infact_uart_RxTx_static_init(&te_mgr);
  //Create inFact C code sequence
  seq = infact_uart_RxTx_create(&te_mgr, "seq");
  
  //Initialize UART and TIMER
  UartRxInit();
  UartTxInit();
  TimerInit();

  //Enable UART and start RX
  StartRx();

  //Run inFact sequence
  infact_uart_RxTx_run(seq);

  //Start Tx and disable UART when finished
  SendTx();

  //Forever loop to prevent C code from restarting in TB
  while(true){}
}

int HardFault_Handler (void){
    while(true){}
}
