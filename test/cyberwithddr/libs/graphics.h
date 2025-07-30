#ifndef __GRAPHICS_H_
#define __GRAPHICS_H_

typedef struct
{
    uint32_t hSyncStart, hSyncEnd;
    uint32_t hColorStart, hColorEnd;

    uint32_t vSyncStart, vSyncEnd;
    uint32_t vColorStart, vColorEnd;
} Vga_Timing;

static const Vga_Timing vga_h1280_v720_r60 = {
    .hSyncStart = 40 - 1,
    .hSyncEnd = 1650 - 1,
    .hColorStart = 260 - 1,
    .hColorEnd = 1540 - 1,
    .vSyncStart = 5 - 1,
    .vSyncEnd = 750 - 1,
    .vColorStart = 25 - 1,
    .vColorEnd = 745 - 1};

static const Vga_Timing vga_h640_v480_r60 = {
    .hSyncStart = 96,
    .hSyncEnd = 800,
    .hColorStart = 96 + 16,
    .hColorEnd = 800 - 48,
    .vSyncStart = 2,
    .vSyncEnd = 525,
    .vColorStart = 2 + 10,
    .vColorEnd = 525 - 33};

static const Vga_Timing vga_simRes = {
    .hSyncStart = 8,
    .hSyncEnd = 70,
    .hColorStart = 16,
    .hColorEnd = 64,
    .vSyncStart = 2,
    .vSyncEnd = 48,
    .vColorStart = 8,
    .vColorEnd = 40};

static const Vga_Timing vga_simRes_h160_v120 = {
    .hSyncStart = 8,
    .hSyncEnd = 24 + 160,
    .hColorStart = 16,
    .hColorEnd = 16 + 160,
    .vSyncStart = 2,
    .vSyncEnd = 10 + 120,
    .vColorStart = 6,
    .vColorEnd = 6 + 120};

typedef struct
{
    volatile uint32_t STATUS;
    volatile uint32_t FRAME_SIZE;
    volatile uint32_t FRAME_BASE;
    volatile uint32_t DUMMY0[13];
    volatile Vga_Timing TIMING;
} GRAPHICS_TypeDef;

static uint32_t vga_isBusy(GRAPHICS_TypeDef *reg)
{
    return (reg->STATUS & 2) != 0;
}

static void vga_run(GRAPHICS_TypeDef *reg)
{
    reg->STATUS = 1;
}

static void vga_stop(GRAPHICS_TypeDef *reg)
{
    reg->STATUS = 0;
    while (vga_isBusy(reg))
        ;
}

#endif /* __GRAPHICS_H_ */
