// Force compilation checks to confirm we are strictly using the 32-bit cross compiler
#if !defined(__i386__)
#error "This kernel code must be compiled using an i686 target cross-compiler!"
#endif

// Helper function to write text at a specific row and column
void print_at(const char* str, int row, int col, char color) {
    volatile char* video_memory = (volatile char*)0xB8000;
    
    // Calculate starting byte offset for (row, col)
    int offset = (row * 80 + col) * 2;

    for (int i = 0; str[i] != '\0'; i++) {
        video_memory[offset + (i * 2)] = str[i];
        video_memory[offset + (i * 2) + 1] = color;
    }
}

void myDelay(volatile unsigned int count) {
    while(count--) {
    }
}

void kernel_main(void) {
    // Pointer to the hardware text-mode video memory
    volatile char* video_memory = (volatile char*)0xB8000;
    char green = 0x0A;
    char cyan  = 0x0B;
    char red   = 0x0C;
    int nRows = 25;
    int nCols = 80;

    // Word to write to screen
    const char* message = "SUCCESS from CSCI 323!";
    
    // Color attribute byte: 0x0A means Black background (0) with Light Green text (A)
    char color_attribute = 0x6F;

    for(int jj = 0; jj < nRows; jj++) {
        for(int ii = 0; ii < nCols; ii++) {
           print_at("#", jj, ii, 0x49); 
           myDelay(1000000);
        }
    }

    // Clear screen lines or loop through the string array directly
    for (int i = 0; message[i] != '\0'; i++) {
        // Write the character byte
        video_memory[i * 2] = message[i];
        // Write the color style byte immediately after it
        video_memory[i * 2 + 1] = color_attribute;
    }
    print_at("SUCCESS from Dr. Seth!", 1, 0, green); // Line 0
    print_at("Welcome to Line 2!",     2, 0, cyan);  // Line 1
    print_at("Running in 32-bit mode", 3, 0, red);   // Line 2
}
