# make clean && make -j $(nproc) && make mem

SUBDIRS := $(wildcard */.)

all:
	for dir in $(SUBDIRS); do \
		if [ -f "$$dir/makefile" ]; then \
			(cd $$dir; $(MAKE) all); \
		fi \
	done

mem:
	for dir in $(SUBDIRS); do \
		if [ -f "$$dir/makefile" ]; then \
			(cd $$dir; $(MAKE) mem); \
		fi \
	done

clean:
	for dir in $(SUBDIRS); do \
		if [ -f "$$dir/makefile" ]; then \
			(cd $$dir; $(MAKE) clean); \
		fi \
	done

.PHONY: all $(SUBDIRS)
