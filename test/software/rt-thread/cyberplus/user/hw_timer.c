#include "cyber.h"
#include "hw_timer.h"

extern void SysTick_Handler(void) __attribute__((weak));

/* 初始化硬件定时器 */
void hw_timer_init()
{
	/*配置时钟源*/
    TIM_InternalClockConfig(TIM1); // 选择TIM1为内部时钟，若不调用此函数，TIM默认也为内部时钟

    /*时基单元初始化*/
    TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;              // 定义结构体变量
    TIM_TimeBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;     // 时钟分频，选择不分频，此参数用于配置滤波器时钟，不影响时基单元功能
    TIM_TimeBaseInitStructure.TIM_CounterMode = TIM_CounterMode_Up; // 计数器模式，选择向上计数
    TIM_TimeBaseInitStructure.TIM_Period = 50000 - 1;               // 计数周期，即ARR的值
    TIM_TimeBaseInitStructure.TIM_Prescaler = 1 - 1;                // 预分频器，即PSC的值
    TIM_TimeBaseInitStructure.TIM_RepetitionCounter = 0;            // 重复计数器，高级定时器才会用到
    TIM_TimeBaseInit(TIM1, &TIM_TimeBaseInitStructure);             // 将结构体变量交给TIM_TimeBaseInit，配置TIM1的时基单元

    /*中断输出配置*/
    TIM_ClearFlag(TIM1, TIM_FLAG_Update);      // 清除定时器更新标志位
                                               // TIM_TimeBaseInit函数末尾，手动产生了更新事件
                                               // 若不清除此标志位，则开启中断后，会立刻进入一次中断
                                               // 如果不介意此问题，则不清除此标志位也可
    TIM_ITConfig(TIM1, TIM_IT_Update, ENABLE); // 开启TIM1的更新中断

    /*TIM使能*/
    TIM_Cmd(TIM1, ENABLE); // 使能TIM1，定时器开始运行
}

/* 定时器中断处理函数 */
void hw_timer_irq_handler()
{
    /*!< TIM */
    if (TIM_GetITStatus(TIM1, TIM_IT_Update) == SET) // 判断是否是TIM1的更新事件触发的中断
    {
        TIM_ClearITPendingBit(TIM1, TIM_IT_Update); // 清除TIM1更新事件的中断标志位
                                                    // 中断标志位必须清除
                                                    // 否则中断将连续不断地触发，导致主程序卡死
        /* 调用 SysTick_Handler 处理函数 */
        SysTick_Handler();
    }
}
