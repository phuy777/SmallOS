CC := x86_64-elf-gcc
LD := x86_64-elf-ld

BUILD_DIR := build
KERNEL := $(BUILD_DIR)/kernel.elf
ISO_ROOT := $(BUILD_DIR)/iso
ISO := $(BUILD_DIR)/smallos.iso
GRUB_CFG := grub/grub.cfg
GRUB_MKRESCUE := grub-mkrescue

CFLAGS := -m64 -std=gnu11 -O2 -Wall -Wextra \
	-ffreestanding -fno-builtin -fno-stack-protector \
	-fno-pic -fno-pie -mno-red-zone
ASFLAGS := -m64
LDFLAGS := -m elf_x86_64

.PHONY: all iso clean

all: $(KERNEL)

iso: $(ISO)

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/boot.o: boot.S Makefile | $(BUILD_DIR)
	$(CC) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR)/main.o: main.c Makefile | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(BUILD_DIR)/boot.o $(BUILD_DIR)/main.o linker.ld
	$(LD) $(LDFLAGS) -T linker.ld -e start -o $@ $(BUILD_DIR)/boot.o $(BUILD_DIR)/main.o

$(ISO): $(KERNEL) $(GRUB_CFG) Makefile
	mkdir -p $(ISO_ROOT)/boot/grub
	cp $(KERNEL) $(ISO_ROOT)/boot/kernel.elf
	cp $(GRUB_CFG) $(ISO_ROOT)/boot/grub/grub.cfg
	$(GRUB_MKRESCUE) -o $@ $(ISO_ROOT)

clean:
	rm -rf $(BUILD_DIR)
