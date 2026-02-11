# make clean && make -j $(nproc) && make mem

######################################
# Project config
######################################

PROJNAME := pinsec
OBJDIR   := build
MEMSIZE  := 2048

DEBUG    ?= yes
BENCH    ?= no
FUNCOPT  ?= yes
MULDIV   ?= yes
STDLIB   ?= no
MATHLIB  ?= no

######################################
# Directory layout
######################################

# LIB directory
SDK := ../../sdk
# Linker path
LINKER := ./linker.ld

######################################
# Source files
######################################

# Public library source code
LIB_DIR := ./libs
LIB_SRCS := $(notdir $(wildcard $(LIB_DIR)/*.c))

# Project source code
SRC_DIR := ./src
SRC_CPP_SRCS := $(shell find $(SRC_DIR) -name '*.cpp')
SRC_C_SRCS := $(shell find $(SRC_DIR) -name '*.c')
SRC_S_SRCS := $(shell find $(SRC_DIR) -name '*.S')
SRC_SRCS := $(SRC_CPP_SRCS) $(SRC_C_SRCS) $(SRC_S_SRCS)

######################################
# Object files layout
######################################

LIB_OBJS := $(addprefix $(OBJDIR)/lib/, $(LIB_SRCS:.c=.o))

SRC_OBJS := $(addprefix $(OBJDIR)/, $(SRC_SRCS))
SRC_OBJS := $(SRC_OBJS:.cpp=.o)
SRC_OBJS := $(SRC_OBJS:.c=.o)
SRC_OBJS := $(SRC_OBJS:.S=.o)

OBJS := $(LIB_OBJS) $(STD_OBJS) $(SRC_OBJS)
DIRS := $(sort $(dir $(OBJS)))

######################################
# Include paths & Search paths
######################################

# Include paths
INC += -I$(LIB_DIR) -I$(STD_DIR)
INC += $(addprefix -I, $(shell find $(SRC_DIR) -type d))
# Search paths
VPATH += $(LIB_DIR) $(STD_DIR) $(SRC_DIR)

######################################
# build.mk
######################################

include $(SDK)/build.mk
