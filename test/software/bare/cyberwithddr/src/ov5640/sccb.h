#ifndef __SCCB_H
#define __SCCB_H

#include "cyber.h"
#include "delay.h"

#ifdef OV5640

#define IIC_ACK 0
#define IIC_NACK 1

void SCCB_Init(void);
void SCCB_DeInit(void);
void SCCB_Start(void);
void SCCB_Stop(void);
void SCCB_SendByte(uint8_t Byte);
void SCCB_SendAck(uint8_t AckBit);
uint8_t SCCB_ReceiveByte(void);
uint8_t SCCB_ReceiveAck(void);
int32_t OV5640_SCCB_ReadReg(uint16_t dev_addr, uint16_t reg_addr, uint8_t *data, uint16_t len);
int32_t OV5640_SCCB_WriteReg(uint16_t dev_addr, uint16_t reg_addr, uint8_t *data, uint16_t len);

#endif /* OV5640 */

#endif
