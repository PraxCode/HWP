#include <malloc.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define ADDR_PER_ROW 16

void memdump(unsigned char *memblock, unsigned length);
int findstring(char **string_array, char *searched_string);

int main(int argc, char **argv)
{
    if (argc != 3)
    {
        printf("%s", "Invalid Use: Need 3 arguments");
        return 0;
    }

    size_t length = strlen(argv[1]) + 1;
    char *string = malloc(length * sizeof(char));
    strcpy(string, argv[1]);

    memdump((unsigned char *) string, length);
    printf("\n");

    char *searched = argv[2];
    int count = findstring(&string, searched);
    printf("After Function: %p::0x%p\n", searched, &searched);
    if (searched != NULL){
        printf("Address of penultimate substring, that has been found: 0x%p.\nCount of substring-occurrences: %i", searched, count);
    } else {
        printf("%s", "NULL");
    }
    free(string);
    return 0;
}

void printheader()
{
    // Header
    printf("%s", "ADDR\t\t");
    // Ascii
    for (int i = 0; i < ADDR_PER_ROW; i++)
    {
        printf("%X", i);
    }
    printf("\n");
}

void memdump(unsigned char *memblock, unsigned length)
{
    int needed_rows = (int) (length / 16);
    if (length % 16 != 0)
        needed_rows++;

    printheader();

    uintptr_t addr = (uintptr_t) memblock & ~(uintptr_t) 0xF; // Last nibble should be 0
    memblock = (unsigned char *) addr;
    for (int zeile = 0; zeile < needed_rows; zeile++)
    {
        // char addr = str[zeile * ADDR_PER_ROW];
        printf("0x%X\t", (unsigned int) addr);

        for (int c = 0; c < ADDR_PER_ROW; c++)
        {
            unsigned char character = memblock[c + (zeile * ADDR_PER_ROW)];
            if (character < 32 || character > 127)
                printf("%s", ".");
            else
                printf("%c", memblock[c + (zeile * ADDR_PER_ROW)]);
        }
        printf("\n");
        addr += 16;
    }
}

int findstring(char **string_array, char *searched_string)
{
    size_t length_of_searched = strlen(searched_string);
    if (length_of_searched == 0){
        searched_string = NULL;
        return 0;
    }

    char *string = *string_array;
    int occurrences = 0;
    char *last_addr = NULL;
    char *penultimate_addr = NULL;

    char *substring = string;
    while (substring)
    {
        // strstr() returns address of first substring-occurrence,
        // so the ptr needs to be moved by the length of the searched string
        substring = strstr(substring + length_of_searched, searched_string);
        if (!substring)
            break;

        occurrences++;
        penultimate_addr = last_addr;
        last_addr = substring;
    }

    searched_string = penultimate_addr;
    printf("\nIn Function: 0x%p::0x%p\n", searched_string, penultimate_addr);
    return occurrences;
}
