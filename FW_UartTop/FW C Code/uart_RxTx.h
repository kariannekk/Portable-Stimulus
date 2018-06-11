#include "stdbool.h"
#include "stdint.h"
#include "product.h"

#define GPIO_RXD   (0)
#define GPIO_CTS   (1)
#define GPIO_TXD   (2)
#define GPIO_RTS   (3)
#define GPIO_TIM   (4)
#define GPIO_RX    (5)
#define GPIO_ENDTX (6)


enum kind_e {RECEIVE, TRANSMIT};
enum stop_e {TWO_STOP_BITS, ONE_STOP_BIT};

void UartRxInit(void);
void UartTxInit(void);
void TimerInit(void);
void waitForTimer(void);
void SetRx(uint32_t payload, uint32_t delay);
void StartRx(void);
void SendTx(void);
void WriteTx(uint32_t payload);
void do_RxTx(uint32_t payload, enum kind_e kind, uint32_t delay);
