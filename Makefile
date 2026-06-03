# Automatically determine the current working absolute directory path across Linux, Mac, and Windows
ifeq ($(OS),Windows_NT)
    CURRENT_DIR := $(CURDIR)
else
    CURRENT_DIR := $(shell pwd)
endif

# --- Configuration Variables ---
IMAGE_NAME     = os-dev-env:v1
CONTAINER_CMD  = docker run --rm -v "$(CURRENT_DIR)":/workspace $(IMAGE_NAME)


# --- Cross-Compiler Names (Inside Container) ---
CC  = i686-linux-gnu-gcc
LD  = i686-linux-gnu-ld
AS  = nasm

# --- Host Entrypoint Targets ---
.PHONY: build
build:
	@echo "Spawning Docker container to compile source code..."
	$(CONTAINER_CMD) make internal_build

.PHONY: run
run:
	@echo "Launching QEMU Emulator on your host machine..."
	qemu-system-i386 -kernel build/myos.bin

# --- Internal Container Target ---
# Do not run this target directly on your host machine terminal.
.PHONY: internal_build
internal_build:
	@mkdir -p build
	@echo "Assembling bootloader entrypoint..."
	$(AS) -f elf32 src/boot.asm -o build/boot.o
	
	@echo "Compiling C kernel source..."
	$(CC) -c src/kernel.c -o build/kernel.o -ffreestanding -O2 -Wall -Wextra
	
	@echo "Linking objects together using cross-compiler configuration..."
	$(LD) -T src/linker.ld -o build/myos.bin build/boot.o build/kernel.o
	@echo "Compilation completed cleanly."
