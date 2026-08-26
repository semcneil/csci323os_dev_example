// Force compilation checks to confirm we are strictly using the 32-bit cross compiler
#if !defined(__i386__)
#error "This kernel code must be compiled using an i686 target cross-compiler!"
#endif

void kernel_main(void) {
    // Pointer to the hardware text-mode video memory
    volatile char* video_memory = (volatile char*)0xB8000;

    // Word to write to screen
    const char* message = "SUCCESS from CSCI 323!";
    
    // Color attribute byte: 0x0A means Black background (0) with Light Green text (A)
    char color_attribute = 0x0A;

    // Clear screen lines or loop through the string array directly
    for (int i = 0; message[i] != '\0'; i++) {
        // Write the character byte
        video_memory[i * 2] = message[i];
        // Write the color style byte immediately after it
        video_memory[i * 2 + 1] = color_attribute;
    }
}
