ifeq ($(ARCH),x86_64)
  export KERNEL_DIR = /lib/modules/$(shell uname -r)/build
#  export KERNEL_DIR = /usr/src/linux-4.19.183-uni-col
else ifdef DEVICE
 include $(PWD)/openwrt.mk
endif

# standard flags for module builds
EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DMODULE -O2 -pipe -Wall

TARGET=at803x.o
obj-m:=$(TARGET)

TARGETS := $(obj-m:.o=.ko)
ccflags-y += -Wall

all:
#	make x86
	make arm64
#	make arm
#	make mips
#	make ramips

arch:
	echo "!!! $(DEVICE) !!! $(ARCH) !!! $(KERNEL_DIR) !!!"
	$(MAKE) -C $(KERNEL_DIR) M=$$PWD

x86:
	$(MAKE) arch ARCH=x86_64 DEVICE=x86_native

mips:
	$(MAKE) arch ARCH=mips DEVICE=ath79-mikrotik

ramips:
	$(MAKE) arch ARCH=mips DEVICE=ramips-mt7621

arm:
	$(MAKE) arch ARCH=arm DEVICE=rb3011

arm64:
	$(MAKE) arch ARCH=arm64 DEVICE=rb5009

clean:
		rm -f .*.cmd *.mod.c *.mod *.ko *.o *~ core $(TARGETS)
		rm -Rf .tmp_versions built-in.a *.symvers *.order .tmp_*
