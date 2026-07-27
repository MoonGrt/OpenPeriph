TOOL ?= sbt
SBT ?= sbt
MILL ?= mill
SBT_OPTS += -Dsbt.global.base=$(CURDIR)/build/sbt/global
SBT_OPTS += -Dsbt.boot.directory=$(CURDIR)/build/sbt/boot
SBT_OPTS += -Dsbt.ivy.home=$(CURDIR)/build/sbt/ivy

.PHONY: build test rtl periph-rtl clean clean-all check-tool sbt-prepare mill-prepare

check-tool:
	@case "$(TOOL)" in sbt|mill) ;; *) echo "Unsupported Spinal build tool: $(TOOL)" >&2; exit 2 ;; esac

build: check-tool
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory sbt-prepare; SBT_OPTS="$(SBT_OPTS)" $(SBT) compile; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server OpenPeriph.compile; \
	fi

test: check-tool
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory sbt-prepare; SBT_OPTS="$(SBT_OPTS)" $(SBT) test; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server OpenPeriph.test.test; \
	fi

rtl: check-tool
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory sbt-prepare; SBT_OPTS="$(SBT_OPTS)" $(SBT) "runMain soc.CyberNvboard"; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server OpenPeriph.runMain soc.CyberNvboard; \
	fi

periph-rtl: check-tool
	@mkdir -p build/rtl/periph
	@if test "$(TOOL)" = sbt; then \
		$(MAKE) --no-print-directory sbt-prepare; SBT_OPTS="$(SBT_OPTS)" $(SBT) "runMain periph.PeripheralRtl"; \
	else \
		$(MAKE) --no-print-directory mill-prepare; $(MILL) --no-server OpenPeriph.runMain periph.PeripheralRtl; \
	fi

sbt-prepare:
	@mkdir -p build/sbt/logs build/sbt/meta build/sbt/meta-project
	@test -e target || ln -s build/sbt/logs target
	@test -e project/target || ln -s ../build/sbt/meta project/target
	@test -e project/project || ln -s ../build/sbt/meta-project project/project

mill-prepare:
	@mkdir -p build/mill
	@ln -sfn build/mill out

clean:
	rm -rf build/rtl

clean-all:
	rm -rf .bloop .bsp .metals build out target verbose.log project/project project/target
