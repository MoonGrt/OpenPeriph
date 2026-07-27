#ifndef __FINSH_H__
#define __FINSH_H__

#include <rtthread.h>
#include "finsh_api.h"

#define FINSH_NEXT_SYSCALL(index)  index++
#define FINSH_NEXT_SYSVAR(index)   index++

/* system variable table */
struct finsh_sysvar
{
    const char*     name;   /* 变量的名称 */
    rt_uint8_t      type;   /* 变量的类型 */
    void*           var;    /* 变量的地址 */
};

#endif