#include <stdio.h>

/*
    This does the same as the assembly strcpy function
    
    As ARM is a LOAD/STORE architecture, we use LDR(B) in it, whereas here we use pointers!
*/

char* my_strcpy(char* dest, const char* src) {
    char* original_dest = dest;
    
    while ((*dest++ = *src++) != '\0');
        
    return original_dest;
}

int main() {
    const char* source = "Hello World";
    char destination[30] = "###########################";
    
    my_strcpy(destination, source);
    
    printf("Copied '%s' to '%s'\n", source, destination);
    
    return 0;
}