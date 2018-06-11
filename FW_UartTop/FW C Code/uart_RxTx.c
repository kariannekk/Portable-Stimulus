#include "uart_RxTx.h"

uint32_t offset = 0;

void UartRxInit(void){
	//Pin select
	NRF_UARTE0->PSEL.RXD = (GPIO_RXD << UARTE_PSEL_RXD_PIN_Pos) |
												(UARTE_PSEL_RXD_CONNECT_Connected << UARTE_PSEL_RXD_CONNECT_Pos);
	NRF_UARTE0->PSEL.CTS = (GPIO_CTS << UARTE_PSEL_CTS_PIN_Pos) |
												(UARTE_PSEL_CTS_CONNECT_Connected << UARTE_PSEL_CTS_CONNECT_Pos);

	//Set DMA pointer and buffer size
	NRF_UARTE0->RXD.PTR = (0x20038000 << UARTE_RXD_PTR_PTR_Pos);
	NRF_UARTE0->RXD.MAXCNT = (0xF << UARTE_RXD_MAXCNT_MAXCNT_Pos);

	//Set up GPIO for setting RX
  NRF_GPIO->PIN_CNF[GPIO_RX] = (GPIO_PIN_CNF_DIR_Output << GPIO_PIN_CNF_DIR_Pos)      |
                                (GPIO_PIN_CNF_INPUT_Connect << GPIO_PIN_CNF_INPUT_Pos) |
                                (GPIO_PIN_CNF_PULL_Disabled << GPIO_PIN_CNF_PULL_Pos)  |
                                (GPIO_PIN_CNF_DRIVE_S0S1 << GPIO_PIN_CNF_DRIVE_Pos)    |
                                (GPIO_PIN_CNF_SENSE_Disabled << GPIO_PIN_CNF_SENSE_Pos);
	NRF_GPIO->OUT = (0x1 << GPIO_RX);

}

void UartTxInit(void){
	//Pin select
	NRF_UARTE0->PSEL.TXD = (GPIO_TXD << UARTE_PSEL_TXD_PIN_Pos) |
												(UARTE_PSEL_TXD_CONNECT_Connected << UARTE_PSEL_TXD_CONNECT_Pos);
	NRF_UARTE0->PSEL.RTS = (GPIO_RTS << UARTE_PSEL_RTS_PIN_Pos) |
												(UARTE_PSEL_RTS_CONNECT_Connected << UARTE_PSEL_RTS_CONNECT_Pos);

	//Set DMA pointer and buffer size
	NRF_UARTE0->TXD.PTR = (0x20038100 << UARTE_RXD_PTR_PTR_Pos);
	NRF_UARTE0->TXD.MAXCNT = (0xA << UARTE_RXD_MAXCNT_MAXCNT_Pos);
	
	//Set up ENDTX event to trigger GPIO through PPI
	NRF_UARTE0->PUBLISH_ENDTX = (UARTE_PUBLISH_ENDTX_EN_Enabled << UARTE_PUBLISH_ENDTX_EN_Pos) |
																	(0x1 << UARTE_PUBLISH_ENDTX_CHIDX_Pos);
	NRF_GPIO->PIN_CNF[GPIO_ENDTX] = (GPIO_PIN_CNF_DIR_Output << GPIO_PIN_CNF_DIR_Pos)      |
                                (GPIO_PIN_CNF_INPUT_Connect << GPIO_PIN_CNF_INPUT_Pos) |
                                (GPIO_PIN_CNF_PULL_Disabled << GPIO_PIN_CNF_PULL_Pos)  |
                                (GPIO_PIN_CNF_DRIVE_S0S1 << GPIO_PIN_CNF_DRIVE_Pos)    |
                                (GPIO_PIN_CNF_SENSE_Disabled << GPIO_PIN_CNF_SENSE_Pos);
	NRF_GPIOTE->CONFIG[1] = (GPIOTE_CONFIG_OUTINIT_Low << GPIOTE_CONFIG_OUTINIT_Pos) |
													(GPIOTE_CONFIG_POLARITY_LoToHi << GPIOTE_CONFIG_POLARITY_Pos) |
													(GPIO_ENDTX << GPIOTE_CONFIG_PSEL_Pos) |
													(GPIOTE_CONFIG_MODE_Task << GPIOTE_CONFIG_MODE_Pos);
	NRF_GPIOTE->SUBSCRIBE_OUT[1] = (GPIOTE_SUBSCRIBE_OUT_EN_Enabled << GPIOTE_SUBSCRIBE_OUT_EN_Pos) |
																(0x1 << GPIOTE_SUBSCRIBE_OUT_CHIDX_Pos);
	NRF_DPPIC->CHENSET = (DPPIC_CHENSET_CH1_Set << DPPIC_CHENSET_CH1_Pos);
}

void TimerInit(void){
 //Configure and setup TIMER0 to generate event each 4us (brg clock-rate)
	NRF_TIMER0->PRESCALER = (0x6 << TIMER_PRESCALER_PRESCALER_Pos);
	NRF_TIMER0->CC[0] = 0x1;
	NRF_TIMER0->PUBLISH_COMPARE[0] = (TIMER_PUBLISH_COMPARE_EN_Enabled << TIMER_PUBLISH_COMPARE_EN_Pos) |
																	(0x0 << TIMER_PUBLISH_COMPARE_CHIDX_Pos);
	NRF_GPIO->PIN_CNF[GPIO_TIM] = (GPIO_PIN_CNF_DIR_Output << GPIO_PIN_CNF_DIR_Pos)      |
                                (GPIO_PIN_CNF_INPUT_Connect << GPIO_PIN_CNF_INPUT_Pos) |
                                (GPIO_PIN_CNF_PULL_Disabled << GPIO_PIN_CNF_PULL_Pos)  |
                                (GPIO_PIN_CNF_DRIVE_S0S1 << GPIO_PIN_CNF_DRIVE_Pos)    |
                                (GPIO_PIN_CNF_SENSE_Disabled << GPIO_PIN_CNF_SENSE_Pos);
	NRF_GPIOTE->CONFIG[0] = (GPIOTE_CONFIG_OUTINIT_Low << GPIOTE_CONFIG_OUTINIT_Pos) |
													(GPIOTE_CONFIG_POLARITY_LoToHi << GPIOTE_CONFIG_POLARITY_Pos) |
													(GPIO_TIM << GPIOTE_CONFIG_PSEL_Pos) |
													(GPIOTE_CONFIG_MODE_Task << GPIOTE_CONFIG_MODE_Pos);
	NRF_GPIOTE->SUBSCRIBE_OUT[0] = (GPIOTE_SUBSCRIBE_OUT_EN_Enabled << GPIOTE_SUBSCRIBE_OUT_EN_Pos) |
																(0x0 << GPIOTE_SUBSCRIBE_OUT_CHIDX_Pos);
	NRF_DPPIC->CHENSET = (DPPIC_CHENSET_CH0_Set << DPPIC_CHENSET_CH0_Pos);
	NRF_TIMER0->TASKS_START = 0x1;
}

void waitForTimer(void){
	while(NRF_GPIO->PIN[GPIO_TIM].IN == 0x0){}
	NRF_TIMER0->TASKS_CLEAR = 0x1;
	NRF_GPIOTE->TASKS_CLR[0] = 0x1;
}

void SetRx(uint32_t payload, uint32_t delay){
	char RxBit;
	waitForTimer();

	//Start bit
	waitForTimer();
	NRF_GPIO->OUT = (0x0 << GPIO_RX);

	//Payload
	for(uint32_t i = 0; i < 8; i++){
		waitForTimer();
		RxBit = (payload >> i);
		NRF_GPIO->OUT = (RxBit << GPIO_RX);
	}

	//Stop bit
	waitForTimer();
	NRF_GPIO->OUT = (0x1 << GPIO_RX);

	//Delay
	for(uint32_t j = 0; j < delay; j++){
		waitForTimer();
	}
}

void StartRx(void){
	//Enable UARTE0 with DMA
	NRF_UARTE0->ENABLE = (UARTE_ENABLE_ENABLE_Enabled << UARTE_ENABLE_ENABLE_Pos);

	//Start RX
	NRF_UARTE0->TASKS_STARTRX = 0x1;
}


void WriteTx(uint32_t payload){
	//Write to RAM
	*(volatile int *) (0x20038100 + offset) = payload; 

	offset++;
}

void SendTx(void){
	//Start TX
	NRF_UARTE0->TASKS_STARTTX = 0x1;
	
	//Wait for completion
	while(NRF_GPIO->PIN[GPIO_ENDTX].IN == 0x0){}

	//Disable UART
	NRF_UARTE0->ENABLE = (UARTE_ENABLE_ENABLE_Disabled << UARTE_ENABLE_ENABLE_Pos);
}

void do_RxTx(uint32_t payload, enum kind_e kind, uint32_t delay){
	if(kind == RECEIVE){
		SetRx(payload, delay);
	}
	else if(kind == TRANSMIT){
		WriteTx(payload);
	}
}
