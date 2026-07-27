DEMO ?= rthtread
DEMOS := bare rthtread
DEMO_DIR := $(DEMO)

ifeq ($(filter $(DEMO),$(DEMOS)),)
$(error Unsupported DEMO '$(DEMO)'; choose one of: $(DEMOS))
endif

.PHONY: all mem clean list info

all mem clean:
	$(MAKE) -C $(DEMO_DIR) $@

list:
	@printf '%s\n' $(DEMOS)

info:
	@case "$(DEMO)" in \
		bare) runtime=bare; startup=sdk/startup/bare.S; linker=sdk/linker/bare.ld ;; \
		rthtread) runtime=rt-thread; startup=sdk/startup/rtthread.S; linker=sdk/linker/rtthread.ld ;; \
	esac; \
	echo "Demo: $(DEMO)"; echo "Runtime: $$runtime"; \
	echo "Startup: $$startup"; echo "Linker: $$linker"
