#include "cyber.h"
#ifdef CYBER_CAN

int CAN_Transmit(CAN_TypeDef *can, const CAN_Message *message)
{
    CAN_TxMailBox_TypeDef *mailbox = &can->sTxMailBox[0];
    mailbox->TDTR = message->length & 0xf;
    mailbox->TDLR = (uint32_t)message->data[0] | ((uint32_t)message->data[1] << 8) |
                    ((uint32_t)message->data[2] << 16) | ((uint32_t)message->data[3] << 24);
    mailbox->TDHR = (uint32_t)message->data[4] | ((uint32_t)message->data[5] << 8) |
                    ((uint32_t)message->data[6] << 16) | ((uint32_t)message->data[7] << 24);
    mailbox->TIR = (message->id << 21) | 1;
    return 0;
}

int CAN_Receive(CAN_TypeDef *can, CAN_Message *message)
{
    uint32_t low, high;
    if ((can->RF0R & 3) == 0) return 0;
    message->id = can->sFIFOMailBox[0].RIR >> 21;
    message->length = can->sFIFOMailBox[0].RDTR & 0xf;
    low = can->sFIFOMailBox[0].RDLR; high = can->sFIFOMailBox[0].RDHR;
    for (int i = 0; i < 4; ++i) { message->data[i] = low >> (8 * i); message->data[i + 4] = high >> (8 * i); }
    can->RF0R = 1u << 5;
    return 1;
}

#endif
