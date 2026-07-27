#include "cyber.h"
#include "dvtt.h"
#include "vga_test.h"

#define VGA_WIDTH 640U
#define VGA_HEIGHT 480U
#define VGA_HSYNC 96U
#define VGA_HBACK 48U
#define VGA_HFRONT 16U
#define VGA_VSYNC 2U
#define VGA_VBACK 33U
#define VGA_VFRONT 10U

#define DVTT_TPCR (*(volatile uint32_t *)(DVTT_BASE + 0x4cU))

void vga_color_bar_init(void)
{
    DVTT_InitTypeDef config;

    config.DVTT_HSPolarity = DVTT_HSPolarity_AL;
    config.DVTT_VSPolarity = DVTT_VSPolarity_AL;
    config.DVTT_DEPolarity = DVTT_DEPolarity_AL;
    config.DVTT_PCPolarity = DVTT_PCPolarity_IPC;
    config.DVTT_HorizontalSync = VGA_HSYNC - 1U;
    config.DVTT_VerticalSync = VGA_VSYNC - 1U;
    config.DVTT_AccumulatedHBP = VGA_HSYNC + VGA_HBACK - 1U;
    config.DVTT_AccumulatedVBP = VGA_VSYNC + VGA_VBACK - 1U;
    config.DVTT_AccumulatedActiveW = VGA_HSYNC + VGA_HBACK + VGA_WIDTH - 1U;
    config.DVTT_AccumulatedActiveH = VGA_VSYNC + VGA_VBACK + VGA_HEIGHT - 1U;
    config.DVTT_TotalWidth = VGA_HSYNC + VGA_HBACK + VGA_WIDTH + VGA_HFRONT - 1U;
    config.DVTT_TotalHeigh = VGA_VSYNC + VGA_VBACK + VGA_HEIGHT + VGA_VFRONT - 1U;
    config.DVTT_BackgroundRedValue = 0U;
    config.DVTT_BackgroundGreenValue = 0U;
    config.DVTT_BackgroundBlueValue = 0U;

    DVTT_Init(&config);
    DVTT_TPCR = 1U;
    DVTT_Cmd(ENABLE);
}
