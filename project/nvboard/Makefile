ROOT := $(abspath ../..)
NVBOARD_HOME ?= $(ROOT)/thirdpartys/nvboard
BUILD_TOOL ?= mill
ROCKET_TRACE ?= 0
SOC ?= spinal
export NVBOARD_HOME

SPINAL_SOURCES := $(shell find $(ROOT)/spinal/src/main/scala -type f -name '*.scala')
CHISEL_SOURCES := $(shell find $(ROOT)/chisel/src/main/scala -type f -name '*.scala')
SDK_SOURCES := $(shell find $(ROOT)/software/sdk -type f ! -path '*/build/*')

ifeq ($(SOC),cyber)
	TOPNAME := CyberNvboardVariant
	RTL := $(ROOT)/spinal/build/rtl/cyber/$(TOPNAME).v
	GENERATOR := soc.CyberNvboardVariant
	SOFTWARE_DIR := $(ROOT)/software/bare
	SOFTWARE_ARGS := SOC=cyber
	FIRMWARE_IMAGE := $(SOFTWARE_DIR)/build/demo.hex
	UART_CYCLES_PER_BIT := 80
else ifeq ($(SOC),cyberplus)
	TOPNAME := CyberPlusNvboardVariant
	RTL := $(ROOT)/spinal/build/rtl/cyberplus/$(TOPNAME).v
	GENERATOR := soc.CyberPlusNvboardVariant
	SOFTWARE_DIR := $(ROOT)/software/rthtread
	FIRMWARE_IMAGE := $(SOFTWARE_DIR)/build/demo.hex
	UART_CYCLES_PER_BIT := 80
else ifeq ($(SOC),spinal)
	TOPNAME := CyberNvboard
	RTL := $(ROOT)/spinal/build/rtl/$(TOPNAME).v
	GENERATOR := soc.CyberNvboard
	SOFTWARE_DIR := $(ROOT)/software/rthtread
	FIRMWARE_IMAGE := $(SOFTWARE_DIR)/build/demo.v
	UART_CYCLES_PER_BIT := 80
else ifeq ($(SOC),chisel)
	TOPNAME := CyberNvboard
	RTL := $(ROOT)/chisel/build/rtl/$(TOPNAME).sv
	SOFTWARE_DIR := $(ROOT)/software/rthtread
	SOFTWARE_ARGS := PLATFORM=rocket
	FIRMWARE_IMAGE := $(SOFTWARE_DIR)/build/demo.mem32
	UART_CYCLES_PER_BIT := 80
else
$(error Unsupported SOC '$(SOC)'; use cyber, cyberplus, spinal, or chisel)
endif

NXDC_FILES := constr/$(TOPNAME).nxdc
VSRCS := $(RTL)
SOFTWARE_SOURCES := $(shell find $(SOFTWARE_DIR) -type f ! -path '*/build/*') $(SDK_SOURCES)

VERILATOR := verilator
VERILATOR_CFLAGS += -MMD --build -cc -O3 --x-assign fast --x-initial fast --noassert
ifeq ($(SOC):$(ROCKET_TRACE),chisel:0)
	VERILATOR_CFLAGS += -DPRINTF_COND=0
endif
BUILD_DIR := ./build/$(SOC)
OBJ_DIR := $(BUILD_DIR)/obj_dir
BIN := $(BUILD_DIR)/$(TOPNAME)

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

SRC_AUTO_BIND := $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

CSRCS := $(shell find $(abspath ./csrc) -name '*.c' -o -name '*.cc' -o -name '*.cpp')
CSRCS += $(SRC_AUTO_BIND)

override NVBOARD_BUILD_DIR := $(abspath $(BUILD_DIR)/nvboard)
include $(NVBOARD_HOME)/scripts/nvboard.mk

CXXFLAGS += $(addprefix -I,$(INC_PATH)) -I$(NVBOARD_HOME)/include
CXXFLAGS += -DTOP_NAME=V$(TOPNAME)
CXXFLAGS += -DTOP_$(TOPNAME)
CXXFLAGS += -DUART_CYCLES_PER_BIT=$(UART_CYCLES_PER_BIT)

$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) --top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS ,$(CXXFLAGS)) $(addprefix -LDFLAGS ,$(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN)) --Wno-WIDTH

all: default

$(FIRMWARE_IMAGE): $(SOFTWARE_SOURCES)
	$(MAKE) -C $(SOFTWARE_DIR) clean
	$(MAKE) -C $(SOFTWARE_DIR) $(SOFTWARE_ARGS)

firmware: $(FIRMWARE_IMAGE)

ifneq ($(filter $(SOC),cyber cyberplus),)
$(RTL): $(FIRMWARE_IMAGE) $(SPINAL_SOURCES)
	@mkdir -p $(ROOT)/spinal/build
	@if test "$(BUILD_TOOL)" = mill; then \
		cd $(ROOT)/spinal && mill --no-server OpenPeriph.runMain $(GENERATOR); \
	elif test "$(BUILD_TOOL)" = sbt; then \
		cd $(ROOT)/spinal && sbt -Dsbt.global.base=build/sbt/global -Dsbt.boot.directory=build/sbt/boot -Dsbt.ivy.home=build/sbt/ivy "runMain $(GENERATOR)"; \
	else echo "Unsupported BUILD_TOOL=$(BUILD_TOOL)" >&2; exit 2; fi
else ifeq ($(SOC),spinal)
$(RTL): $(FIRMWARE_IMAGE)
	$(MAKE) -C $(ROOT) BACKEND=spinal TOOL=$(BUILD_TOOL) rtl
else
$(RTL): $(FIRMWARE_IMAGE) $(CHISEL_SOURCES)
	$(MAKE) -C $(ROOT) BACKEND=chisel TOOL=$(BUILD_TOOL) rtl
endif

run: $(BIN)
	@cd $(dir $(RTL)) && NVBOARD_HOME=$(NVBOARD_HOME) $(abspath $(BIN))

clean:
	rm -f $(BIN)

clean-all:
	rm -rf ./build

.PHONY: default all firmware clean clean-all run
