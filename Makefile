TOPDIR		= $(CURDIR)
SUBDIRS		= src
TARGETS		= hwinfo hwscan
CLEANFILES	= hwinfo hwinfo.static hwscan hwscan.static

include Makefile.common

SHARED_FLAGS	=
OBJS_NO_TINY	= names.o parallel.o modem.o

.PNONY:	fullstatic static shared tiny

hwscan: hwscan.o $(LIBHD)
	$(CC) hwscan.o $(LDFLAGS) -lhd -o $@

hwinfo: hwinfo.o $(LIBHD)
	$(CC) hwinfo.o $(LDFLAGS) -lhd -o $@

# kept for compatibility
shared:
	@make

tiny:
	@make EXTRA_FLAGS=-DLIBHD_TINY SHARED_FLAGS=

static:
	@make SHARED_FLAGS=

fullstatic: static
	$(CC) -static hwinfo.o $(LDFLAGS) -lhd -o hwinfo.static
	$(CC) -static hwscan.o $(LDFLAGS) -lhd -o hwscan.static
	strip -R .note -R .comment hwinfo.static
	strip -R .note -R .comment hwscan.static

install:
	install -d -m 755 /usr/sbin /usr/lib /usr/include
	install -m 755 -s hwinfo /usr/sbin
	install -m 755 -s hwscan /usr/sbin
	if [ -f $(LIBHD_SO) ] ; then \
		install $(LIBHD_SO) /usr/lib ; \
		ln -snf libhd.so.$(LIBHD_VERSION) /usr/lib/libhd.so.$(LIBHD_MAJOR_VERSION) ; \
		ln -snf libhd.so.$(LIBHD_MAJOR_VERSION) /usr/lib/libhd.so ; \
	else \
		install -m 644 $(LIBHD) /usr/lib ; \
	fi
	install -m 644 src/hd/hd.h /usr/include
