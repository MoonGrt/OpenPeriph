#ifndef OPENPERIPH_CAN_H
#define OPENPERIPH_CAN_H

#include <stdint.h>

typedef struct { volatile uint32_t TIR, TDTR, TDLR, TDHR; } CAN_TxMailBox_TypeDef;
typedef struct { volatile uint32_t RIR, RDTR, RDLR, RDHR; } CAN_FIFOMailBox_TypeDef;
typedef struct {
    volatile uint32_t MCR, MSR, TSR, RF0R, RF1R, IER, ESR, BTR;
    uint32_t RESERVED0[88];
    CAN_TxMailBox_TypeDef sTxMailBox[3];
    CAN_FIFOMailBox_TypeDef sFIFOMailBox[2];
} CAN_TypeDef;

typedef struct { uint32_t id; uint8_t length; uint8_t data[8]; } CAN_Message;
int CAN_Transmit(CAN_TypeDef *can, const CAN_Message *message);
int CAN_Receive(CAN_TypeDef *can, CAN_Message *message);

#endif
