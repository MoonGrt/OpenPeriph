#ifndef __RT_DEF_H__
#define __RT_DEF_H__

/* include rtconfig header to import configuration */
#include <rtconfig.h>

/* RT-Thread basic data type definitions */
typedef signed   char                   rt_int8_t;      /**<  8bit integer type */
typedef signed   short                  rt_int16_t;     /**< 16bit integer type */
typedef signed   int                    rt_int32_t;     /**< 32bit integer type */
typedef unsigned char                   rt_uint8_t;     /**<  8bit unsigned integer type */
typedef unsigned short                  rt_uint16_t;    /**< 16bit unsigned integer type */
typedef unsigned int                    rt_uint32_t;    /**< 32bit unsigned integer type */

typedef int                             rt_bool_t;      /**< boolean type */
typedef long                            rt_base_t;      /**< Nbit CPU related date type */
typedef unsigned long                   rt_ubase_t;     /**< Nbit unsigned CPU related data type */

typedef rt_base_t                       rt_err_t;       /**< Type for error number */
typedef rt_uint32_t                     rt_time_t;      /**< Type for time stamp */
typedef rt_uint32_t                     rt_tick_t;      /**< Type for tick count */
typedef rt_base_t                       rt_flag_t;      /**< Type for flags */
typedef rt_ubase_t                      rt_size_t;      /**< Type for size number */
typedef rt_ubase_t                      rt_dev_t;       /**< Type for device */
typedef rt_base_t                       rt_off_t;       /**< Type for offset */

/* boolean type definitions */
#define RT_TRUE                         1               /**< boolean true */
#define RT_FALSE                        0               /**< Type for false */

/* maximum value of base type */
#define RT_UINT8_MAX                    0xff            /**< Maxium number of UINT8 */
#define RT_UINT16_MAX                   0xffff          /**< Maxium number of UINT16 */
#define RT_UINT32_MAX                   0xffffffff      /**< Maxium number of UINT32 */
#define RT_TICK_MAX                     RT_UINT32_MAX   /**< Maxium number of tick */

/* RT-Thread error code definitions */
#define RT_EOK                          0               /**< There is no error */
#define RT_ERROR                        1               /**< A generic error happens */
#define RT_ETIMEOUT                     2               /**< Timed out */
#define RT_EFULL                        3               /**< The resource is full */
#define RT_EEMPTY                       4               /**< The resource is empty */
#define RT_ENOMEM                       5               /**< No memory */
#define RT_ENOSYS                       6               /**< No system */
#define RT_EBUSY                        7               /**< Busy */
#define RT_EIO                          8               /**< IO error */
#define RT_EINTR                        9               /**< Interrupted system call */
#define RT_EINVAL                       10              /**< Invalid argument */


/* Compiler Related Definitions */
#if defined (__GNUC__)                                  /* GNU GCC Compiler */
    #ifdef RT_USING_NEWLIB
        #include <stdarg.h>
    #else 
    #endif

    #define SECTION(x)                  __attribute__((section(x)))
    #define RT_UNUSED                   __attribute__((unused))
    #define RT_USED                     __attribute__((used))
    #define ALIGN(n)                    __attribute__((aligned(n)))
    #define RT_WEAK                     __attribute__((weak))
    #define rt_inline                   static __inline
#else
    #error not supported tool chain
#endif

/**
 * @ingroup BasicDef
 *
 * @def RT_ALIGN(size, align)
 * Return the most contiguous size aligned at specified width. RT_ALIGN(13, 4)
 * would return 16.
 */
#define RT_ALIGN(size, align)          (((size) + (align) -1) & ~((align) - 1))           

/**
 * @ingroup BasicDef
 *
 * @def RT_ALIGN_DOWN(size, align)
 * Return the down number of aligned at specified width. RT_ALIGN_DOWN(13, 4)
 * would return 12.
 */
#define RT_ALIGN_DOWN(size, align)     ((size) & ~((align) - 1))

#define RT_NULL                        (0)

/**
 * Double List structure
 */
struct rt_list_node
{
    struct rt_list_node *next;                          /**< point to next node. */
    struct rt_list_node *prev;                          /**< point to prev node. */
};
typedef struct rt_list_node rt_list_t;                  /**< Type for lists. */

/**
 * Single List structure 
 */
struct rt_slist_node
{
    struct rt_slist_node *next;                         /**< point to prev node. */
};
typedef struct rt_slist_node rt_slist_t;                /**< Type for single lists. */

/**
 * Base structure of Kernel object
 */
struct rt_object
{
    char       name[RT_NAME_MAX];       /* 内核对象的名字 */
    rt_uint8_t type;                    /* 内核对象的类型 */
    rt_uint8_t flag;                    /* 内核对象的状态 */

    rt_list_t  list;                    /* 内核对象的 list 节点 */
};
typedef struct rt_object *rt_object_t;  /* 内核对象指针类型重定义 */

/**
 *  The object type can be one of the follows with specific
 *  macros enabled:
 *  - Thread
 *  - Semaphore
 *  - Mutex
 *  - Event
 *  - MailBox
 *  - MessageQueue
 *  - MemHeap
 *  - MemPool
 *  - Device
 *  - Timer
 *  - Unknown
 *  - Static
 */
enum rt_object_class_type
{
    RT_Object_Class_Null          = 0x00,      /* 对象未使用 */
    RT_Object_Class_Thread        = 0x01,      /* 线程 */
    RT_Object_Class_Semaphore     = 0x02,      /* 信号量 */
    RT_Object_Class_Mutex         = 0x03,      /* 互斥量 */
    RT_Object_Class_Event         = 0x04,      /* 事件 */
    RT_Object_Class_MailBox       = 0x05,      /* 邮箱 */
    RT_Object_Class_MessageQueue  = 0x06,      /* 消息队列 */
    RT_Object_Class_MemHeap       = 0x07,      /* 内存堆 */
    RT_Object_Class_MemPool       = 0x08,      /* 内存池 */
    RT_Object_Class_Device        = 0x09,      /* 设备 */
    RT_Object_Class_Timer         = 0x0a,      /* 定时器 */
    RT_Object_Class_Unknown       = 0x0c,      /* 未知对象 */
    RT_Object_Class_Static        = 0x80       /* 静态对象 */
};

/**
 * The information of the kernel object
 * 作为对象容器的表头节点
 */
struct rt_object_information
{
    enum rt_object_class_type type;             /* 对象类型 */
    rt_list_t                 object_list;      /* 对象 list 节点 */
    rt_size_t                 object_size;      /* 对象大小 */
};

/**
 * clock & timer macros
 */
#define RT_TIMER_FLAG_DEACTIVATED       0x0         /* 定时器未激活 */
#define RT_TIMER_FLAG_ACTIVATED         0x1         /* 定时器已激活 */
#define RT_TIMER_FLAG_ONE_SHOT          0x0         /* 单次定时 */
#define RT_TIMER_FLAG_PERIODIC          0x2         /* 周期定时 */

#define RT_TIMER_FLAG_HARD_TIMER        0x0         /* 硬件定时器，定时器回调函数在 tick isr 中调用 */
#define RT_TIMER_FLAG_SOFT_TIMER        0x4         /* 软件定时器，定时器回调函数在定时器线程中调用 */

#define RT_TIMER_CTRL_SET_TIME          0x0         /* 设置定时器 tick 控制指令 */
#define RT_TIMER_CTRL_GET_TIME          0x1         /* 获取定时器 tick 控制指令 */
#define RT_TIMER_CTRL_SET_ONESHOT       0x2         /* 设置定时器为单次定时 */
#define RT_TIMER_CTRL_SET_PERIODIC      0x3         /* 设置定时器为周期定时 */
#define RT_TIMER_CTRL_GET_STATE         0x4         /* 获取定时器运行状态，激活还是未激活 */

#ifndef RT_TIMER_SKIP_LIST_LEVEL
#define RT_TIMER_SKIP_LIST_LEVEL          1
#endif

#ifndef RT_TIMER_SKIP_LIST_MASK
#define RT_TIMER_SKIP_LIST_MASK         0x3
#endif

/**
 * timer structure
 */
struct rt_timer
{
    struct rt_object parent;                        /* 从 rt_object 继承 */

    rt_list_t        row[RT_TIMER_SKIP_LIST_LEVEL];

    void (*timeout_func)(void *parameter);          /* 超时函数 */
    void            *parameter;                     /* 超时函数形参 */

    rt_tick_t        init_tick;                     /* 定时器需要延时的时间 */
    rt_tick_t        timeout_tick;                  /* 定时器超时时的系统节拍数 */
};
typedef struct rt_timer *rt_timer_t;

/*
 * Thread
 */

/**
 * thread state definitions
 * 线程状态定义
 */
#define RT_THREAD_INIT              0x00                /* 初始态 */
#define RT_THREAD_READY             0x01                /* 就绪态 */
#define RT_THREAD_SUSPEND           0x02                /* 挂起态 */
#define RT_THREAD_RUNNING           0x03                /* 运行态 */
#define RT_THREAD_BLOCK             RT_THREAD_SUSPEND   /* 阻塞态 */
#define RT_THREAD_CLOSE             0x04                /* 关闭态 */
#define RT_THREAD_STAT_MASK         0x0f


/**
 * Thread structure 
 */
struct rt_thread
{
    /* rt object */
    char        name[RT_NAME_MAX];              /* 对象名称 */
    rt_uint8_t  type;                           /* 对象类型 */
    rt_uint8_t  flags;                          /* 对象状态 */
    rt_list_t   list;                           /* 对象的 list 节点 */

    rt_list_t   tlist;                          /* 线程的 list 节点 */

    /* stack point and entry */
    void        *sp;                            /* 线程当前栈顶指针 */
    void        *entry;                         /* 线程函数入口 */
    void        *parameter;                     /* 线程函数的传入参数 */
    void        *stack_addr;                    /* 线程栈起始地址 */
    rt_uint32_t  stack_size;                    /* 线程栈大小，单位为字节 */

    rt_err_t     error;                         /* 错误码 */

    rt_uint8_t   stat;                          /* 线程状态 */

    rt_uint8_t   current_priority;              /* 线程当前优先级 */
    rt_uint8_t   init_priority;                 /* 线程初始优先级 */
    rt_uint32_t  number_mask;                   /* 当前优先级掩码 */

    rt_ubase_t   init_tick;                     /* 初始时间片 */
    rt_ubase_t   remaining_tick;                /* 剩余时间片 */
    
    struct rt_timer thread_timer;               /* 内置线程定时器 */
};
typedef struct rt_thread *rt_thread_t;

#endif
