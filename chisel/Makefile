ROOT := $(abspath ..)
TOOL ?= sbt
SBT ?= sbt
MILL ?= mill

.PHONY: build test rtl clean clean-all check-tool mill-prepare rocket-chip

check-tool:
	@case "$(TOOL)" in sbt|mill) ;; *) echo "Unsupported Chisel build tool: $(TOOL)" >&2; exit 2 ;; esac

build: check-tool
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory rocket-chip; $(SBT) compile; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server chisel.compile; \
	fi

test: check-tool
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory rocket-chip; $(SBT) test; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server chisel.test.test; \
	fi

rtl: check-tool
	@mkdir -p build/rtl
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory rocket-chip; $(SBT) "runMain soc.CyberNvboard --target-dir rtl"; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server chisel.runMain soc.CyberNvboard --target-dir rtl; \
	fi

mill-prepare:
	@mkdir -p build/mill
	@ln -sfn build/mill out

rocket-chip:
	@cd $(ROOT)/thirdpartys/rocket-chip && MILL_VERSION=0.11.6 $(MILL) --no-server 'rocketchip[6.7.0].assembly'

clean:
	rm -rf build/rtl

clean-all:
	rm -rf .bloop .bsp .metals build out target project/project project/target
	rm -rf $(ROOT)/thirdpartys/rocket-chip/out
