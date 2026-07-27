BACKEND ?= spinal
TOOL ?= $(SCALA_BUILD_TOOL)

SUPPORTED_BACKENDS := verilog spinal chisel
SCALA_BUILD_TOOL ?= sbt
SBT ?= sbt
MILL ?= mill

.PHONY: help configure build test rtl clean clean-all submodules verilog spinal chisel

help:
	@echo "Usage: make BACKEND=<verilog|spinal|chisel> [TOOL=<sbt|mill>] <configure|build|test|rtl|clean>"
	@echo "       make clean-all  # remove all generated files for every backend"
	@echo "Default backend: $(BACKEND)"

configure:
	@case " $(SUPPORTED_BACKENDS) " in \
		*" $(BACKEND) "*) ;; \
		*) echo "Unsupported backend: $(BACKEND)" >&2; exit 2 ;; \
	esac
	@echo "Backend: $(BACKEND)"
	@echo "Source directory: $(CURDIR)/$(BACKEND)"
	@if test "$(BACKEND)" = spinal; then \
		case "$(TOOL)" in sbt|mill) echo "Build tool: $(TOOL)" ;; \
		*) echo "Unsupported Spinal build tool: $(TOOL)" >&2; exit 2 ;; esac; \
	fi
	@if test "$(BACKEND)" = chisel; then \
		case "$(TOOL)" in sbt|mill) echo "Build tool: $(TOOL)" ;; \
		*) echo "Unsupported Chisel build tool: $(TOOL)" >&2; exit 2 ;; esac; \
	fi

build: configure
	@$(MAKE) --no-print-directory $(BACKEND) ACTION=build

test: configure
	@$(MAKE) --no-print-directory $(BACKEND) ACTION=test

rtl: configure
	@$(MAKE) --no-print-directory $(BACKEND) ACTION=rtl

clean: configure
	@$(MAKE) --no-print-directory $(BACKEND) ACTION=clean

# Remove project-local outputs from every supported tool and backend. Keep this
# independent of BACKEND/TOOL so a single invocation cleans mixed builds.
clean-all:
	@$(MAKE) --no-print-directory -C verilog clean-all
	@$(MAKE) --no-print-directory -C spinal clean-all
	@$(MAKE) --no-print-directory -C chisel clean-all
	@$(MAKE) --no-print-directory -C software/bare clean
	@$(MAKE) --no-print-directory -C software/rthtread clean
	@$(MAKE) --no-print-directory -C project/nvboard clean-all
	rm -rf .bloop .bsp .metals out target
	@find . -path './.git' -prune -o -path './thirdpartys' -prune -o \
		-type d \( -name obj_dir -o -name __pycache__ \) -prune -exec rm -rf {} +

submodules:
	git submodule update --init --recursive

verilog:
	@$(MAKE) --no-print-directory -C verilog $(ACTION)

spinal:
	@$(MAKE) --no-print-directory -C spinal TOOL=$(TOOL) SBT=$(SBT) MILL=$(MILL) $(ACTION)

chisel:
	@$(MAKE) --no-print-directory -C chisel TOOL=$(TOOL) SBT=$(SBT) MILL=$(MILL) $(ACTION)
