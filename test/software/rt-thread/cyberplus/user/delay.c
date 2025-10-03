#include "delay.h"

static uint16_t fac_us = 0; // us延时倍乘数
static uint16_t fac_ms = 0; // ms延时倍乘数
static uint32_t fac_s  = 0; //  s延时倍乘数

// 初始化延迟函数
// SYSTICK的时钟固定为
// CORE_HZ:系统时钟
void delay_init(void)
{
    fac_us = (uint16_t)(CORE_HZ / 1000 / 1000);
    fac_ms = fac_us * 1000;
    fac_s  = fac_ms * 1000;
}

// 延时nus
// nus为要延时的us数.
void delay_us(uint32_t nus)
{
    uint32_t temp;
    SysTick->LOAD = nus * fac_us; // 时间加载
    SysTick->VAL = 0x00;          // 清空计数器
    SysTick->CTRL = 0x01;         // 开始倒数
    do
    {
        temp = SysTick->CTRL;
    } while (temp & 0x01 && !(temp & (1 << 16))); // 等待时间到达
    SysTick->CTRL = 0x00; // 关闭计数器
    SysTick->VAL = 0x00;  // 清空计数器
}

// 延时nms
// 注意nms的范围
// SysTick->LOAD,最大延时为: nms<=0xffffffff*1000/CORE_HZ
// CORE_HZ单位为Hz,nms单位为ms // 50MHz -> 85899ms
void delay_ms(uint16_t nms)
{
    uint32_t temp;
    SysTick->LOAD = (uint32_t)nms * fac_ms; // 时间加载(SysTick->LOAD)
    SysTick->VAL = 0x00;                    // 清空计数器
    SysTick->CTRL = 0x01;                   // 开始倒数
    do
    {
        temp = SysTick->CTRL;
    } while (temp & 0x01 && !(temp & (1 << 16))); // 等待时间到达
    SysTick->CTRL = 0x00; // 关闭计数器
    SysTick->VAL = 0x00;  // 清空计数器
}

// 延时ns
// 注意ns的范围
// SysTick->LOAD,最大延时为: ns<=0xffffffff/CORE_HZ
// CORE_HZ单位为Hz,nms单位为ms // 50MHz -> 85s
void delay_s(uint16_t ns)
{
    uint32_t temp;
    SysTick->LOAD = (uint32_t)ns * fac_s; // 时间加载(SysTick->LOAD)
    SysTick->VAL = 0x00;                  // 清空计数器
    SysTick->CTRL = 0x01;                 // 开始倒数
    do
    {
        temp = SysTick->CTRL;
    } while (temp & 0x01 && !(temp & (1 << 16))); // 等待时间到达
    SysTick->CTRL = 0x00; // 关闭计数器
    SysTick->VAL = 0x00;  // 清空计数器
}
