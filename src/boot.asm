; --- Multiboot 1 Constants ---
MBOOT_ALIGN     equ  1 << 0             ; Align modules on page boundaries
MBOOT_MEMINFO   equ  1 << 1             ; Provide memory map information
MBOOT_FLAGS     equ  MBOOT_ALIGN | MBOOT_MEMINFO
MBOOT_MAGIC     equ  0x1BADB002         ; Magic number matching specification
MBOOT_CHECKSUM  equ  -(MBOOT_MAGIC + MBOOT_FLAGS)

; --- Multiboot Header Section ---
section .multiboot
align 4
    dd MBOOT_MAGIC
    dd MBOOT_FLAGS
    dd MBOOT_CHECKSUM

; --- Bootloader Setup and Entrypoint ---
section .text
global start
extern kernel_main                      ; Defined in kernel.c

start:
    cli                                 ; Disable hardware interrupts
    mov esp, stack_space                ; Set up our custom execution stack
    call kernel_main                    ; Call into our C code
    
.halt:
    hlt                                 ; Infinite safety loop if kernel returns
    jmp .halt

; --- Uninitialized Data (Stack Space) ---
section .bss
align 16
stack_space:
    resb 16384                          ; Reserve 16 Kilobytes for the system stack
