/* 头文件声明 */
#include <rtthread.h>
#include <rthw.h>
#include <shell.h>
#include <dfs.h>
#include "rtconfig.h"
#include "cyber.h"
#include "std.h"
#include "hw_timer.h"

extern void trap_entry(void) __attribute__((weak));

void _init()
{
    /* 设置中断入口函数 */
    asm volatile("csrw mtvec, %0" :: "r" (&trap_entry));
    /* 使能 CPU全局中断，设置权限为 Machine，MPP = 11, MPIE = 1, MIE = 1 */
    asm volatile("csrw mstatus, %0" :: "r" (0x1888));
    /* 使能外部中断，设置权限为 Machine，MEIE = 1, MTIE = 1 */
    asm volatile("csrw mie, %0" :: "r" (0x880));
}

/* USART 初始化 */
void USART_init(void)
{
    /*GPIO初始化*/
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOB, &GPIO_InitStructure); // 将PB0引脚初始化为复用推挽输出
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOB, &GPIO_InitStructure); // 将PB1引脚初始化为上拉输入

    /*USART初始化*/
    USART_InitTypeDef USART_InitStructure;                                          // 定义结构体变量
    USART_InitStructure.USART_BaudRate = 115200;                                    // 波特率
    USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None; // 硬件流控制，不需要  可以不配置，默认为None
    USART_InitStructure.USART_Mode = USART_Mode_Tx | USART_Mode_Rx;                 // 模式，发送模式和接收模式均选择
    USART_InitStructure.USART_Parity = USART_Parity_No;                             // 奇偶校验，不需要
    USART_InitStructure.USART_StopBits = USART_StopBits_1;                          // 停止位，选择1位
    USART_InitStructure.USART_WordLength = USART_WordLength_8b;                     // 字长，选择8位
    USART_Init(USART1, &USART_InitStructure);                                       // 将结构体变量交给USART_Init，配置USART1
    /*中断输出配置*/
    // USART_ITConfig(USART1, USART_IT_RXNE, ENABLE); // 开启串口接收数据的中断

    /*USART使能*/
    USART_Cmd(USART1, ENABLE); // 使能USART1，串口开始运行
    // /*USART发送*/
    // printf("Cyber USART Test\r\n");
}

/* main 函数 */
int main(void)
{
    /* 硬件初始化 */
    rt_hw_interrupt_disable(); /* 关中断 */
    USART_init();              /* 初始化串口 */
    hw_timer_init();           /* 初始化硬件定时器 */
    init_fs();

    /* 系统定时器列表初始化 */
    rt_system_timer_init();
    /* 调度器初始化 */
    rt_system_scheduler_init();
    /* 初始化空闲线程 */
    rt_thread_idle_init();
    /* 初始化 finsh 线程 */
    finsh_system_init();
    /* 启动系统调度器 */
    rt_system_scheduler_start();
}
