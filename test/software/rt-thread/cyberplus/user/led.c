/* 头文件声明 */
#include "led.h"

/* led 初始化 */
void GPIO_init(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2 | GPIO_Pin_3;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
}

/* PWM 初始化 */
void PWM_init(void)
{
    /*GPIO初始化*/
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure); // 将PA15引脚初始化为复用推挽输出
                                           // 受外设控制的引脚，均需要配置为复用模式

    /*配置时钟源*/
    TIM_InternalClockConfig(TIM2); // 选择TIM3为内部时钟，若不调用此函数，TIM默认也为内部时钟

    /*时基单元初始化*/
    TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;              // 定义结构体变量
    TIM_TimeBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;     // 时钟分频，选择不分频，此参数用于配置滤波器时钟，不影响时基单元功能
    TIM_TimeBaseInitStructure.TIM_CounterMode = TIM_CounterMode_Up; // 计数器模式，选择向上计数
    TIM_TimeBaseInitStructure.TIM_Period = 100 - 1;                 // 计数周期，即ARR的值
    TIM_TimeBaseInitStructure.TIM_Prescaler = 50 - 1;               // 预分频器，即PSC的值
    TIM_TimeBaseInitStructure.TIM_RepetitionCounter = 0;            // 重复计数器，高级定时器才会用到
    TIM_TimeBaseInit(TIM2, &TIM_TimeBaseInitStructure);             // 将结构体变量交给TIM_TimeBaseInit，配置TIM3的时基单元

    /*输出比较初始化*/
    TIM_OCInitTypeDef TIM_OCInitStructure;                        // 定义结构体变量
    TIM_OCStructInit(&TIM_OCInitStructure);                       // 结构体初始化，若结构体没有完整赋值
                                                                  // 则最好执行此函数，给结构体所有成员都赋一个默认值
                                                                  // 避免结构体初值不确定的问题
    TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;             // 输出比较模式，选择PWM模式1
    TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;     // 输出极性，选择为高，若选择极性为低，则输出高低电平取反
    TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable; // 输出使能
    TIM_OCInitStructure.TIM_Pulse = 0;                            // 初始的CCR值
    TIM_OC4Init(TIM2, &TIM_OCInitStructure);                      // 将结构体变量交给TIM_OC1Init，配置TIM3的输出比较通道1

    /*TIM使能*/
    TIM_Cmd(TIM2, ENABLE); // 使能TIM3，定时器开始运行
}

void led_flow_breathe(int led_index, int increasing) {
    GPIO_Write(GPIOA, ~(1 << led_index)); // 点亮对应的 LED
    for (int pulse = 0; pulse <= 100; pulse++) {
        TIM_SetCompare4(TIM2, increasing ? pulse : 100 - pulse); // 根据 increasing 控制亮度变化
        rt_thread_delay(5); // 延时
    }
}

/* led 线程 入口函数 */
void th_led_en(void *p_arg)
{
    uint8_t pulse;

    GPIO_init();
    PWM_init();

    for (;;)
    {
        led_flow_breathe(0, 1); // LED 0; 逐渐变亮
        led_flow_breathe(1, 0); // LED 1; 逐渐变暗
        led_flow_breathe(2, 1); // LED 2; 逐渐变亮
        led_flow_breathe(3, 0); // LED 3; 逐渐变暗
    }
}

/* led 初始化 */
long led_init(void)
{
    /* 初始化线程 */
    rt_thread_init(&th_led,                /* 线程控制块 */
                   "th_led ",              /* 线程名称，唯一 */
                   th_led_en,              /* 线程入口地址 */
                   RT_NULL,                /* 线程形参 */
                   &rt_thled_stack[0],     /* 线程栈起始地址 */
                   sizeof(rt_thled_stack), /* 线程栈大小 */
                   6,                      /* 线程优先级 */
                   1);                     /* 线程时间片 */
    /* 启动线程 */
    rt_thread_startup(&th_led);

    printf("led init success\r\n");
}
MSH_CMD_EXPORT(led_init, led init);
