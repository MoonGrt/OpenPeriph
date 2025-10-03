#include <rtthread.h>
#include <rthw.h>

/*
 * define object_info for the number of rt_object_container items.
 * 里面的成员随 config 文件中的定义而变化，作为容器数组的下标。
 * 注：如果枚举类型的成员值没有具体指定，那么后一个值是在前一个成员值的基础上加 1
 */
enum rt_object_info_type
{
    RT_Object_Info_Thread = 0,                         /* 线程 */
#ifdef RT_USING_SEMAPHORE
    RT_Object_Info_Semaphore,                          /* 信号量 */
#endif
#ifdef RT_USING_MUTEX
    RT_Object_Info_Mutex,                              /* 互斥量 */
#endif
#ifdef RT_USING_EVENT
    RT_Object_Info_Event,                              /* 事件 */
#endif
#ifdef RT_USING_MAILBOX
    RT_Object_Info_MailBox,                            /* 邮箱 */
#endif
#ifdef RT_USING_MESSAGEQUEUE
    RT_Object_Info_MessageQueue,                       /* 消息队列 */
#endif
#ifdef RT_USING_MEMHEAP
    RT_Object_Info_MemHeap,                            /* 内存堆 */
#endif
#ifdef RT_USING_MEMPOOL
    RT_Object_Info_MemPool,                            /* 内存池 */
#endif
#ifdef RT_USING_DEVICE
    RT_Object_Info_Device,                             /* 设备 */
#endif
    RT_Object_Info_Timer,                              /* 定时器 */
    RT_Object_Info_Unknown,                            /* 未知对象 */
};

/* 初始化 rt_object_container 对应下标的头节点 */
#define _OBJ_CONTAINER_LIST_INIT(c)   \
    {&(rt_object_container[c].object_list), &(rt_object_container[c].object_list)}

/* 容器定义，头节点为 rt_object_information 类型，头节点之后的为 rt_object 类型 */
static struct rt_object_information rt_object_container[RT_Object_Info_Unknown] =
{
    /* 初始化线程对象容器 */
    {
        RT_Object_Class_Thread, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_Thread),
        sizeof(struct rt_thread)
    },
#ifdef RT_USING_SEMAPHORE
    /* 初始化信号量对象容器 */
    {
        RT_Object_Class_Semaphore, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_Semaphore), 
        sizeof(struct rt_semaphore)
    },
#endif
#ifdef RT_USING_MUTEX
    /* 初始化互斥量对象容器 */
    {
        RT_Object_Class_Mutex,
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_Mutex), 
        sizeof(struct rt_mutex)
    },
#endif
#ifdef RT_USING_EVENT
    /* 初始化事件对象容器 */
    {
        RT_Object_Class_Event, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_Event), 
        sizeof(struct rt_event)
    },
#endif
#ifdef RT_USING_MAILBOX
    /* 初始化邮箱对象容器 */
    {
        RT_Object_Class_MailBox, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_MailBox), 
        sizeof(struct rt_mailbox)
    },
#endif
#ifdef RT_USING_MESSAGEQUEUE
    /* 初始化消息队列容器对象 */
    {
        RT_Object_Class_MessageQueue, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_MessageQueue), 
        sizeof(struct rt_messagequeue)
    },
#endif
#ifdef RT_USING_MEMHEAP
    /* 初始化内存堆容器对象 */
    {
        RT_Object_Class_MemHeap, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_MemHeap), 
        sizeof(struct rt_memheap)
    },
#endif
#ifdef RT_USING_MEMPOOL
    /* 初始化内存池对象容器 */
    {
        RT_Object_Class_MemPool,
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_MemPool), 
        sizeof(struct rt_mempool)
    },
#endif
#ifdef RT_USING_DEVICE
    /* 初始化设备对象容器 */
    {
        RT_Object_Class_Device, 
        _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_Device),
        sizeof(struct rt_device)
    },
#endif
    /* 初始化定时器对象容器 */
    //{
    //    RT_Object_Class_Timer, 
    //    _OBJ_CONTAINER_LIST_INIT(RT_Object_Info_Timer),
    //    sizeof(struct rt_timer)
    //},
};

/**
 * This function will return the specified type of object information.
 * 获取指定类型的对象头节点指针
 *
 * @param type the type of object, which can be
 *             RT_Object_Class_Thread/Semaphore/Mutex... etc
 *
 * @return the object type information or RT_NULL
 */
struct rt_object_information *
rt_object_get_information(enum rt_object_class_type type)
{
    int index;

    for (index = 0; index < RT_Object_Info_Unknown; index ++)
        if (rt_object_container[index].type == type)
            return &rt_object_container[index];

    return RT_NULL;
}

/**
 * This function will initialize an object and add it to object system
 * management.
 * 该函数会初始化对象并将对象添加到容器中
 *
 * @param object the specified object to be initialized.
 * @param type the object type.
 * @param name the object name. In system, the object's name must be unique.
 */
void rt_object_init(struct rt_object         *object,
                    enum rt_object_class_type type,
                    const char               *name)
{
    register rt_base_t temp;
    struct rt_object_information *information;

    /* 获取对象信息，即从 rt_object_container 里拿到对应对象头节点指针 */
    information = rt_object_get_information(type);

    /* 设置对象类型为静态 */
    object->type = type | RT_Object_Class_Static;

    /* 拷贝名字 */
    rt_strncpy(object->name, name, RT_NAME_MAX);

    /* 关中断 */
    temp = rt_hw_interrupt_disable();

    /* 将对象插入到容器的对应列表中，不同类型的对象所在的列表不一样 */
    rt_list_insert_after(&(information->object_list), &(object->list));

    /* 恢复中断 */
    rt_hw_interrupt_enable(temp);
}