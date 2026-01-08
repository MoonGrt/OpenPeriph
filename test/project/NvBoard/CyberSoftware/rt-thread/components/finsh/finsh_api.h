#ifndef FINSH_API_H__
#define FINSH_API_H__

#include "finsh_config.h"

typedef long (*syscall_func)(void);

/* system call table */
struct finsh_syscall
{
    const char*  name;   /* 系统调用的名称 */
    const char*  desc;   /* 系统调用的描述 */
    syscall_func func;   /* 系统调用的函数地址 */     
};
extern struct finsh_syscall *_syscall_table_begin, *_syscall_table_end;

#ifdef FINSH_USING_SYMTAB
    #define FINSH_FUNCTION_EXPORT_CMD(name, cmd, desc)                       \
        const char __fsym_##cmd##_name[] = #cmd;                             \
        const char __fsym_##cmd##_desc[] = #desc;                            \
        RT_USED const struct finsh_syscall __fsym_##cmd SECTION("FSymTab") = \
        {                                                                    \
            __fsym_##cmd##_name,                                             \
            __fsym_##cmd##_desc,                                             \
            (syscall_func)&name                                              \
        };
#endif

#ifdef FINSH_USING_MSH
#define MSH_CMD_EXPORT(command, desc)   \
    FINSH_FUNCTION_EXPORT_CMD(command, __cmd_##command, desc)
#endif

#endif