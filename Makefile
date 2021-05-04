obj-m := tcp_newcwv.o

IDIR= /lib/modules/$(shell uname -r)/kernel/net/ipv4/
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all: 
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install_newcwv:
	install -v -m 644 tcp_newcwv.ko $(IDIR)
	depmod
	modprobe tcp_newcwv
	sysctl -w net.ipv4.tcp_allowed_congestion_control="$(shell sysctl net.ipv4.tcp_allowed_congestion_control -n) newcwv"


clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -rf .cache.mk \
        .tcp_newcwv.ko.cmd \
        .tcp_newcwv.mod.o.cmd \
        .tcp_newcwv.o.cmd \
        .tmp_versions/ \
        Module.symvers \
        modules.order \
        tcp_newcwv.ko \
        tcp_newcwv.mod.c \
        tcp_newcwv.mod.o \
        tcp_newcwv.o

push: all
	cp tcp_newcwv.ko /usr/src/WM_with_TMIX/
	cd /usr/src/WM_with_TMIX/; ./makefs

indent:
	indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1 tcp_newcwv.c

