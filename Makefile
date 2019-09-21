ARCH            = x86_64
CC				= gcc
SRC 			= main.c
OBJS            = efistub.o
TARGET          = efistub.efi
CMDLINE 		= initrd=\intel-ucode.img initrd=\initramfs-linux.img root=UUID=3263e30d-3412-4563-9f9a-90a095306d7e rw elevator=noop quiet loglevel=3 rd.udev.log_priority=3 rd.systemd.show_status=auto systemd.show_status=auto systemd.fsck=skip amdgpu.dc=1

EFIINC          = include/efi
EFIINCS         = -I$(EFIINC) -I$(EFIINC)/$(ARCH) -I$(EFIINC)/protocol
LIB 			= lib#/usr/lib64
EFILIB          = lib#/usr/lib
EFI_CRT_OBJS    = $(EFILIB)/crt0-efi-$(ARCH).o
EFI_LDS         = $(EFILIB)/elf_$(ARCH)_efi.lds

CFLAGS          = $(EFIINCS) -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -Wall 
ifeq ($(ARCH),x86_64)
  CFLAGS += -DEFI_FUNCTION_WRAPPER
endif

LDFLAGS         = -nostdlib -znocombreloc -T $(EFI_LDS) -shared -Bsymbolic -L $(EFILIB) -L $(LIB) $(EFI_CRT_OBJS) 

all: $(TARGET)

efistub.o:
		sh replacecmd.sh && $(CC) -g -O3 -c $(SRC) $(CFLAGS) -o efistub.o #-I/usr/include/efi

efistub.so: $(OBJS)
	ld $(LDFLAGS) $(OBJS) -o $@ -lefi -lgnuefi

%.efi: %.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .reloc --target=efi-app-$(ARCH) $^ $@

clean:
	rm $(TARGET) $(OBJS) efistub.so main.c