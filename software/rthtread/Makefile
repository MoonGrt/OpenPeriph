# make clean && make -j $(nproc) && make mem

######################################
# Project config
######################################

PROJNAME := demo
OBJDIR   := build
MEMSIZE  := 16384

DEBUG    ?= yes
BENCH    ?= no
FUNCOPT  ?= yes
MULDIV   ?= yes
STDLIB   ?= no
MATHLIB  ?= no
PLATFORM ?= cyber

ifeq ($(PLATFORM),rocket)
CFLAGS += -DOPENPERIPH_ROCKET
endif

######################################
# Directory layout
######################################

# SDK directory
SDK := ../sdk
# Linker path
LINKER := $(SDK)/linker/rtthread.ld
STARTUP := $(SDK)/startup/rtthread.S

######################################
# Source files
######################################

# Public library source code
LIB_DIR := $(SDK)/lib
LIB_SRCS := $(notdir $(wildcard $(LIB_DIR)/*.c))
# Standard library source code
STD_DIR := $(SDK)/std
STD_SRCS := $(notdir $(wildcard $(STD_DIR)/*.c))

# RT-Thread source code
RTTHREAD_DIR := $(SDK)/rt-thread
RTTHREAD_C_SRCS := $(notdir \
    $(shell find $(RTTHREAD_DIR)/src -name '*.c') \
    $(shell find $(RTTHREAD_DIR)/libcpu -name '*.c') \
    $(shell find $(RTTHREAD_DIR)/components/finsh -name '*.c') \
    $(shell find $(RTTHREAD_DIR)/components/dfs -name '*.c'))
RTTHREAD_S_SRCS := $(notdir $(shell find $(RTTHREAD_DIR)/libcpu -name '*.S'))

# User source code
USER_DIR := ./src
USER_CPP_SRCS := $(notdir $(shell find $(USER_DIR) -name '*.cpp'))
USER_C_SRCS := $(notdir $(shell find $(USER_DIR) -name '*.c'))
USER_S_SRCS := $(notdir $(shell find $(USER_DIR) -name '*.S'))

SRC_SRCS := $(USER_CPP_SRCS) $(USER_C_SRCS) $(USER_S_SRCS) $(RTTHREAD_C_SRCS) $(RTTHREAD_S_SRCS)

######################################
# Object files layout
######################################

LIB_OBJS := $(addprefix $(OBJDIR)/lib/, $(LIB_SRCS:.c=.o))
STD_OBJS := $(addprefix $(OBJDIR)/lib/, $(STD_SRCS:.c=.o))

SRC_OBJS := $(addprefix $(OBJDIR)/, $(SRC_SRCS))
SRC_OBJS := $(SRC_OBJS:.cpp=.o)
SRC_OBJS := $(SRC_OBJS:.c=.o)
SRC_OBJS := $(SRC_OBJS:.S=.o)

STARTUP_OBJ := $(OBJDIR)/startup.o
OBJS := $(LIB_OBJS) $(STD_OBJS) $(SRC_OBJS) $(STARTUP_OBJ)
DIRS := $(sort $(dir $(OBJS)))

######################################
# Include paths & Search paths
######################################

# Include paths
INC += -I$(LIB_DIR) -I$(STD_DIR)
INC += $(addprefix -I, $(shell find $(RTTHREAD_DIR) -type d))
INC += $(addprefix -I, $(shell find $(USER_DIR) -type d))
# Search paths
VPATH += $(LIB_DIR) $(STD_DIR) $(RTTHREAD_DIR) $(USER_DIR)
VPATH += $(shell find $(RTTHREAD_DIR) $(USER_DIR) -type d)

######################################
# build.mk
######################################

include $(SDK)/build.mk

$(STARTUP_OBJ): $(STARTUP) | $(DIRS)
	$(RISCV_CC) -c $(CFLAGS) -D__ASSEMBLY__=1 -o $@ $<
