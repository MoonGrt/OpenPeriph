# make clean && make -j $(nproc) && make mem

SUBDIRS := $(wildcard */.)

all:
	for dir in $(SUBDIRS); do \
		(cd $$dir; ${MAKE} all); \
	done

mem:
	for dir in $(SUBDIRS); do \
		(cd $$dir; ${MAKE} mem); \
	done

clean:
	for dir in $(SUBDIRS); do \
		(cd $$dir; ${MAKE} clean); \
	done

.PHONY: all $(SUBDIRS)
