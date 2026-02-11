######################################
# Toolchain
######################################

# Set it to yes if you are using the sifive precompiled GCC pack
SIFIVE_GCC_PACK ?= yes

ifeq ($(SIFIVE_GCC_PACK),yes)
    RISCV_NAME ?= riscv64-unknown-elf
    RISCV_PATH ?= /opt/riscv
else
    RISCV_NAME ?= riscv32-unknown-elf
    ifeq ($(MULDIV),yes)
        RISCV_PATH ?= /opt/riscv32im
    else
        RISCV_PATH ?= /opt/riscv32i
    endif
endif

RISCV_CC      := $(RISCV_PATH)/bin/$(RISCV_NAME)-gcc
RISCV_OBJCOPY := $(RISCV_PATH)/bin/$(RISCV_NAME)-objcopy
RISCV_OBJDUMP := $(RISCV_PATH)/bin/$(RISCV_NAME)-objdump

######################################
# ISA / ABI
######################################

MABI=ilp32
MARCH := rv32i
ifeq ($(MULDIV),yes)
    MARCH := $(MARCH)m
endif
ifeq ($(COMPRESSED),yes)
    MARCH := $(MARCH)ac
endif

CFLAGS += -march=$(MARCH) -mabi=$(MABI)
# LDFLAGS += -march=$(MARCH) -mabi=$(MABI)

######################################
# Flags
######################################

ifeq ($(DEBUG),yes)
    CFLAGS += -g3 -O0
else
    CFLAGS += -g -O3
endif

ifeq ($(BENCH), yes)
    CFLAGS += -fno-inline
endif

ifeq ($(FUNCOPT), yes)
    CFLAGS += -ffunction-sections -fdata-sections
    LDFLAGS += -Wl,--gc-sections
else
    CFLAGS += -fno-function-sections -fno-data-sections
endif

ifeq ($(STDLIB), no)
    LDFLAGS += -nostdlib
endif

ifeq ($(MATHLIB), yes)
    LDFLAGS += -lm
endif

CFLAGS  += -MD -fstrict-volatile-bitfields
LDFLAGS += -nostartfiles -lgcc -mcmodel=medany -ffreestanding\
           -Wl,-Bstatic,-T,$(LINKER) \
           -Wl,-Map,$(OBJDIR)/$(PROJNAME).map,--print-memory-usage

######################################
# Targets
######################################

.PHONY: all

all: $(OBJDIR)/$(PROJNAME).elf \
     $(OBJDIR)/$(PROJNAME).hex \
     $(OBJDIR)/$(PROJNAME).asm \
     $(OBJDIR)/$(PROJNAME).v
	@echo "\nBuild successful for project: $(PROJNAME)\n"
	@echo "Output: $(shell pwd)/$(OBJDIR)/$(PROJNAME).elf"

MEMDIR   := $(OBJDIR)/mem
MEMTYPE  := bin
EXTRTEMP := true
mem: $(OBJDIR)/$(PROJNAME).hex
	@echo "\nGenerating .mem from .hex..."
	mkdir -p $(MEMDIR)
	@$(SDK)/InstExtractor.sh $< $(MEMDIR)/$(PROJNAME) $(MEMSIZE) $(MEMTYPE) $(EXTRTEMP)

clean:
	rm -rf $(OBJDIR)

.SECONDARY: $(OBJS)

$(DIRS):
	@mkdir -p $@

######################################
# Link
######################################

$(OBJDIR)/$(PROJNAME).elf: $(OBJS) | $(DIRS)
	@echo "\n-----------------------------\n"
	$(RISCV_CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "\n-----------------------------\n"

######################################
# Compile rules
######################################

$(OBJDIR)/lib/%.o: %.c | $(DIRS)
	$(RISCV_CC) -c $(CFLAGS) $(INC) -o $@ $<

$(OBJDIR)/%.o: %.c | $(DIRS)
	$(RISCV_CC) -c $(CFLAGS) $(INC) -o $@ $<

$(OBJDIR)/%.o: %.cpp | $(DIRS)
	$(RISCV_CC) -c $(CFLAGS) $(INC) -o $@ $<

$(OBJDIR)/%.o: %.S | $(DIRS)
	$(RISCV_CC) -c $(CFLAGS) -D__ASSEMBLY__=1 -o $@ $<

######################################
# Output formats
######################################

%.bin: %.elf
	$(RISCV_OBJCOPY) -O binary $^ $@

%.hex: %.elf
	$(RISCV_OBJCOPY) -O ihex $^ $@

%.v: %.elf
	$(RISCV_OBJCOPY) -O verilog $^ $@

%.asm: %.elf
	$(RISCV_OBJDUMP) -S -d $^ > $@
