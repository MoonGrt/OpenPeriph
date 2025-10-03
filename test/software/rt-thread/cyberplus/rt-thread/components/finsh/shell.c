#include <rthw.h>
#include "finsh_config.h"

#ifdef RT_USING_FINSH

#include "finsh.h"
#include "shell.h"
#include "cyber.h"

#ifdef FINSH_USING_MSH
#include "msh.h"
#endif

#define NULL ((void *)0)

#ifndef RT_USING_HEAP
/* finsh 线程控制块 */
static struct rt_thread finsh_thread;

/* finsh 线程栈 */
ALIGN(RT_ALIGN_SIZE)
static char finsh_thread_stack[FINSH_THREAD_STACK_SIZE];

/* finsh_shell 结构体 */
struct finsh_shell _shell;
#endif

/* finsh symtab */
#ifdef FINSH_USING_SYMTAB
struct finsh_syscall *_syscall_table_begin = NULL;
struct finsh_syscall *_syscall_table_end = NULL;
#endif

struct finsh_shell *shell;

const char *finsh_get_prompt()
{
#define _MSH_PROMPT "msh >"

    static char finsh_prompt[RT_CONSOLEBUF_SIZE + 1] = {0};

    rt_strncpy(finsh_prompt, _MSH_PROMPT, RT_CONSOLEBUF_SIZE);

    return finsh_prompt;
}

static int finsh_getchar(void)
{
    // int ch = uart_getc();
    int ch = USART_ReceiveData(USART1);

    /* 如果未获取到字符，则让出处理器 */
    if (ch < 0)
    {
        rt_thread_delay(1);
    }

    return ch;
}

#ifdef FINSH_USING_AUTH
/**
 * set a new password for finsh
 *
 * @param password new password
 *
 * @return result, RT_EOK on OK, -RT_ERROR on the new password length is less than
 *  FINSH_PASSWORD_MIN or greater than FINSH_PASSWORD_MAX
 */
rt_err_t finsh_set_password(const char *password) {
    rt_ubase_t level;
    rt_size_t pw_len = rt_strlen(password);

    if (pw_len < FINSH_PASSWORD_MIN || pw_len > FINSH_PASSWORD_MAX)
        return -RT_ERROR;

    level = rt_hw_interrupt_disable();
    rt_strncpy(shell->password, password, FINSH_PASSWORD_MAX);
    rt_hw_interrupt_enable(level);

    return RT_EOK;
}

/**
 * get the finsh password
 *
 * @return password
 */
const char *finsh_get_password(void)
{
    return shell->password;
}

static void finsh_wait_auth(void)
{
    int ch;
    rt_bool_t input_finish = RT_FALSE;
    char password[FINSH_PASSWORD_MAX] = { 0 };
    rt_size_t cur_pos = 0;
    /* password not set */
    if (rt_strlen(finsh_get_password()) == 0) return;

    while (1)
    {
        printf("Password for login: ");
        while (!input_finish)
        {
            while (1)
            {
                /* read one character from device */
                ch = finsh_getchar();
                if (ch < 0)
                {
                    continue;
                }

                if (ch >= ' ' && ch <= '~' && cur_pos < FINSH_PASSWORD_MAX)
                {
                    /* change the printable characters to '*' */
                    printf("*");
                    password[cur_pos++] = ch;
                }
                else if (ch == '\b' && cur_pos > 0)
                {
                    /* backspace */
                    cur_pos--;
                    password[cur_pos] = '\0';
                    printf("\b \b");
                }
                else if (ch == '\r' || ch == '\n')
                {
                    printf("\r\n");
                    input_finish = RT_TRUE;
                    break;
                }
            }
        }
        if (!rt_strncmp(shell->password, password, FINSH_PASSWORD_MAX)) return;
        else
        {
            /* authentication failed, delay 2S for retry */
            rt_thread_delay(1 * RT_TICK_PER_SECOND);
            printf("Sorry, try again.\r\n");
            cur_pos = 0;
            input_finish = RT_FALSE;
            rt_memset(password, '\0', FINSH_PASSWORD_MAX);
        }
    }
}
#endif /* FINSH_USING_AUTH */

static void shell_auto_complete(char *prefix)
{
    printf("\n");
#ifdef FINSH_USING_MSH
    if (msh_is_used() == RT_TRUE)
    {
        msh_auto_complete(prefix);
    }
    else
#endif
    {
#ifndef FINSH_USING_MSH_ONLY
        extern void list_prefix(char * prefix);
        list_prefix(prefix);
#endif
    }

    printf("\r%s%s", FINSH_PROMPT, prefix);
}

#ifdef FINSH_USING_HISTORY
static rt_bool_t shell_handle_history(struct finsh_shell *shell)
{
    printf("\r%s%s", FINSH_PROMPT, shell->line);
    return RT_FALSE;
}

static void shell_push_history(struct finsh_shell *shell)
{
    if (shell->line_position != 0)
    {
        /* push history */
        if (shell->history_count >= FINSH_HISTORY_LINES)
        {
            /* if current cmd is same as last cmd, don't push */
            if (rt_memcmp(&shell->cmd_history[FINSH_HISTORY_LINES - 1], shell->line, FINSH_CMD_SIZE))
            {
                /* move history */
                int index;
                for (index = 0; index < FINSH_HISTORY_LINES - 1; index ++)
                {
                    rt_memcpy(&shell->cmd_history[index][0],
                           &shell->cmd_history[index + 1][0], FINSH_CMD_SIZE);
                }
                rt_memset(&shell->cmd_history[index][0], 0, FINSH_CMD_SIZE);
                rt_memcpy(&shell->cmd_history[index][0], shell->line, shell->line_position);

                /* it's the maximum history */
                shell->history_count = FINSH_HISTORY_LINES;
            }
        }
        else
        {
            /* if current cmd is same as last cmd, don't push */
            if (shell->history_count == 0 || rt_memcmp(&shell->cmd_history[shell->history_count - 1], shell->line, FINSH_CMD_SIZE))
            {
                shell->current_history = shell->history_count;
                rt_memset(&shell->cmd_history[shell->history_count][0], 0, FINSH_CMD_SIZE);
                rt_memcpy(&shell->cmd_history[shell->history_count][0], shell->line, shell->line_position);

                /* increase count and set current history position */
                shell->history_count ++;
            }
        }
    }
    shell->current_history = shell->history_count;
}
#endif

/* finsh 线程入口函数 */
void finsh_thread_entry(void *parameter)
{
    int ch;

    /* normal is echo mode */
    shell->echo_mode = 1;

    rt_show_version();

#ifdef FINSH_USING_AUTH
    /* set the default password when the password isn't setting */
    if (rt_strlen(finsh_get_password()) == 0)
    {
        if (finsh_set_password(FINSH_DEFAULT_PASSWORD) != RT_EOK)
        {
            printf("Finsh password set failed.\r\n");
        }
    }
    /* waiting authenticate success */
    finsh_wait_auth();
#endif

    printf(FINSH_PROMPT);

    while (1)
    {
        ch = finsh_getchar();

        /* received null or error */
        if (ch < 0 || ch == '\0' || ch == 0xFF) continue;
        /* handle tab key */
        else if (ch == '\t')
        {
            int i;
            /* move the cursor to the beginning of line */
            for (i = 0; i < shell->line_curpos; i++)
                printf("\b");

            /* auto complete */
            shell_auto_complete(&shell->line[0]);
            /* re-calculate position */
            shell->line_curpos = shell->line_position = rt_strlen(shell->line);

            continue;
        }
        /* handle backspace key */
        else if (ch == 0x7f || ch == 0x08)
        {
            /* note that shell->line_curpos >= 0 */
            if (shell->line_curpos == 0)
                continue;

            shell->line_position--;
            shell->line_curpos--;

            if (shell->line_position > shell->line_curpos)
            {
                int i;

                rt_memmove(&shell->line[shell->line_curpos],
                           &shell->line[shell->line_curpos + 1],
                           shell->line_position - shell->line_curpos);
                shell->line[shell->line_position] = 0;

                printf("\b%s  \b", &shell->line[shell->line_curpos]);

                /* move the cursor to the origin position */
                for (i = shell->line_curpos; i <= shell->line_position; i++)
                    printf("\b");
            }
            else
            {
                printf("\b \b");
                shell->line[shell->line_position] = 0;
            }
            continue;
        }

        /*
         * handle control key
         * up key  : 0x1b 0x5b 0x41
         * down key: 0x1b 0x5b 0x42
         * right key:0x1b 0x5b 0x43
         * left key: 0x1b 0x5b 0x44
         */
        if (ch == 0x1b)
        {
            shell->stat = WAIT_SPEC_KEY;
            continue;
        }
        else if (shell->stat == WAIT_SPEC_KEY)
        {
            if (ch == 0x5b)
            {
                shell->stat = WAIT_FUNC_KEY;
                continue;
            }
            shell->stat = WAIT_NORMAL;
        }
        else if (shell->stat == WAIT_FUNC_KEY)
        {
            shell->stat = WAIT_NORMAL;
            if (ch == 0x41) /* up key */
            {
#ifdef FINSH_USING_HISTORY
                /* prev history */
                if (shell->current_history > 0)
                    shell->current_history --;
                else
                {
                    shell->current_history = 0;
                    continue;
                }
                /* copy the history command */
                rt_memcpy(shell->line, &shell->cmd_history[shell->current_history][0],FINSH_CMD_SIZE);
                shell->line_curpos = shell->line_position = rt_strlen(shell->line);
                shell_handle_history(shell);
#endif
                continue;
            }
            else if (ch == 0x42) /* down key */
            {
#ifdef FINSH_USING_HISTORY
                /* next history */
                if (shell->current_history < shell->history_count - 1)
                    shell->current_history ++;
                else
                {
                    /* set to the end of history */
                    if (shell->history_count != 0)
                        shell->current_history = shell->history_count - 1;
                    else
                        continue;
                }
                rt_memcpy(shell->line, &shell->cmd_history[shell->current_history][0],
                       FINSH_CMD_SIZE);
                shell->line_curpos = shell->line_position = rt_strlen(shell->line);
                shell_handle_history(shell);
#endif
                continue;
            }
            else if (ch == 0x44) /* left key */
            {
                if (shell->line_curpos)
                {
                    printf("\b");
                    shell->line_curpos --;
                }
                continue;
            }
            else if (ch == 0x43) /* right key */
            {
                if (shell->line_curpos < shell->line_position)
                {
                    printf("%c", shell->line[shell->line_curpos]);
                    shell->line_curpos ++;
                }
                continue;
            }
        }

        /* handle end of line, break */
        if (ch == '\r' || ch == '\n')
        {
#ifdef FINSH_USING_HISTORY
            shell_push_history(shell);
#endif

#ifdef FINSH_USING_MSH
            if (msh_is_used() == RT_TRUE)
            {
                if (shell->echo_mode)
                    printf("\r\n");
                msh_exec(shell->line, shell->line_position);
            }
#endif

            printf(FINSH_PROMPT);
            rt_memset(shell->line, 0, sizeof(shell->line));
            shell->line_curpos = shell->line_position = 0;
            continue;
        }

        /* it's a large line, discard it */
        if (shell->line_position >= FINSH_CMD_SIZE)
            shell->line_position = 0;

        /* normal character */
        if (shell->line_curpos < shell->line_position)
        {
            int i;

            rt_memmove(&shell->line[shell->line_curpos + 1],
                       &shell->line[shell->line_curpos],
                       shell->line_position - shell->line_curpos);
            shell->line[shell->line_curpos] = ch;
            if (shell->echo_mode)
                printf("%s", &shell->line[shell->line_curpos]);

            /* move the cursor to new position */
            for (i = shell->line_curpos; i < shell->line_position; i++)
                printf("\b");
        }
        else
        {
            shell->line[shell->line_position] = ch;
            if (shell->echo_mode)
                printf("%c", ch);
        }

        ch = 0;
        shell->line_position++;
        shell->line_curpos++;
        if (shell->line_position >= FINSH_CMD_SIZE)
        {
            /* clear command line */
            shell->line_position = 0;
            shell->line_curpos = 0;
        }
    } /* end of device read */
}

void finsh_system_function_init(const void *begin, const void *end)
{
    _syscall_table_begin = (struct finsh_syscall *)begin;
    _syscall_table_end = (struct finsh_syscall *)end;
}

/* finsh 线程初始化函数 */
int finsh_system_init(void)
{
    rt_err_t result = RT_EOK;
    rt_thread_t tid;

    /* GNU GCC Compiler and TI CCS */
    extern const int __fsymtab_start;
    extern const int __fsymtab_end;
    finsh_system_function_init(&__fsymtab_start, &__fsymtab_end);

    shell = &_shell;
    tid = &finsh_thread;
    result = rt_thread_init(&finsh_thread,
                            FINSH_THREAD_NAME,
                            finsh_thread_entry,
                            RT_NULL,
                            &finsh_thread_stack[0],
                            sizeof(finsh_thread_stack),
                            FINSH_THREAD_PRIORITY,
                            10);

    if (tid != NULL && result == RT_EOK)
        rt_thread_startup(tid);
    return 0;
}

#endif /* RT_USING_FINSH */
