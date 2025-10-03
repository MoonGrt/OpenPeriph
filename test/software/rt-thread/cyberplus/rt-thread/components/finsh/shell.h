#ifndef __SHELL_H__
#define __SHELL_H__

#include <rtthread.h>
#include "finsh.h"

#ifndef FINSH_CMD_SIZE
#define FINSH_CMD_SIZE      32
#endif

#define FINSH_PROMPT        finsh_get_prompt()
const char* finsh_get_prompt(void);

#ifdef FINSH_USING_HISTORY
#ifndef FINSH_HISTORY_LINES
#define FINSH_HISTORY_LINES 5
#endif
#endif

#ifndef FINSH_THREAD_NAME
#define FINSH_THREAD_NAME   "tshell "
#endif

#ifdef FINSH_USING_AUTH
#ifndef FINSH_PASSWORD_MAX
#define FINSH_PASSWORD_MAX RT_NAME_MAX
#endif
#ifndef FINSH_PASSWORD_MIN
#define FINSH_PASSWORD_MIN 5
#endif
#ifndef FINSH_DEFAULT_PASSWORD
#define FINSH_DEFAULT_PASSWORD "cyber"
#endif
#endif /* FINSH_USING_AUTH */

enum input_stat
{
    WAIT_NORMAL,
    WAIT_SPEC_KEY,
    WAIT_FUNC_KEY,
};

struct finsh_shell
{
    enum input_stat stat;

    rt_uint8_t echo_mode : 1;
    rt_uint8_t prompt_mode : 1;

#ifdef FINSH_USING_HISTORY
    rt_uint16_t current_history;
    rt_uint16_t history_count;

    char cmd_history[FINSH_HISTORY_LINES][FINSH_CMD_SIZE];
#endif

    char line[FINSH_CMD_SIZE];
    rt_uint16_t line_position;
    rt_uint16_t line_curpos;

#ifdef FINSH_USING_AUTH
    char password[FINSH_PASSWORD_MAX];
#endif
};

int finsh_system_init(void);

#endif
