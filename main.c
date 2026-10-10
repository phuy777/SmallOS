#include <stdint.h>

void kmain(void){
    volatile uint16_t* vga_buffer = (uint16_t*) 0xB8000;
    const char* str = "hello world";
    uint8_t color = 0x0F;
    int i = 0;
    while(str[i] != '\0'){
        vga_buffer[i] = (color << 8) | str[i];
        i++;
}
while(1){
    __asm__ volatile ("hlt");
}
}