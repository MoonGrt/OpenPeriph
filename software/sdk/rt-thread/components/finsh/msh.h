#ifndef __M_SHELL__
#define __M_SHELL__

#include <rtthread.h>

rt_bool_t msh_is_used(void);
int msh_exec(char *cmd, rt_size_t length);
void msh_auto_complete(char *prefix);

#endif