VERILATOR ?= verilator
TOP := Apb3Peripherals
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj_dir
BIN := $(BUILD_DIR)/peripherals_test
MEM_BIN := $(BUILD_DIR)/mem_test
VSRCS := $(sort $(abspath $(wildcard vsrc/*.sv vsrc/periph/*.sv vsrc/graphic/*.sv)))
TEST_SRC := $(abspath csrc/peripherals_test.cpp)
MEM_TEST_SRC := $(abspath csrc/mem_test.cpp)

.PHONY: all build test rtl clean clean-all

all: build

build: $(BIN)

$(BIN): $(VSRCS) $(TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	$(VERILATOR) --cc --exe --build --top-module $(TOP) \
		--Mdir $(OBJ_DIR) -Wall -Wno-DECLFILENAME -Wno-UNUSED \
		-CFLAGS -std=c++17 -o $(abspath $(BIN)) $(VSRCS) $(TEST_SRC)

$(MEM_BIN): vsrc/periph/axi4mem.sv $(MEM_TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	$(VERILATOR) --cc --exe --build --top-module Axi4Mem \
		--Mdir $(BUILD_DIR)/mem_obj_dir -Wall -Wno-DECLFILENAME -Wno-UNUSED \
		-CFLAGS -std=c++17 -o $(abspath $(MEM_BIN)) $^

test: $(BIN) $(MEM_BIN)
	$(BIN)
	$(MEM_BIN)

rtl:
	$(VERILATOR) --lint-only --top-module $(TOP) -Wall -Wno-DECLFILENAME -Wno-UNUSED $(VSRCS)

clean:
	rm -f $(BIN) $(MEM_BIN)

clean-all:
	rm -rf $(BUILD_DIR)
