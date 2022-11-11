#include <assert.h>
#include <malloc.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define ADDR_PER_ROW 16
#define ROWS 3

void memdump(unsigned char *str, unsigned zeilen);
int findstring(char **start, char *a);

int main(int argc, char **argv) {
  if (argc != 3) {
    printf("%s", "Invalid Use: Need 3 arguments");
    return 0;
  }

  int length = strlen(argv[1]);
  int needed_rows = (length / 16);
  if (length % 16 != 0) {
    needed_rows++;
  }
  printf("Needed Rows: %i\n", needed_rows);

  memdump((unsigned char *)argv[1], needed_rows);
  printf("\n");

  return 0;
}

void printheader() {
  // Header
  printf("%s", "ADDR ");
  // Ascii
  for (int i = 0; i < ADDR_PER_ROW; i++) {
    printf("%X", i);
  }
  printf("\n");
}

void memdump(unsigned char *str, unsigned zeilen) {
  printheader();

  // Find next address that divides 16
  // unsigned char *addr = (unsigned char *)(*str & 0xF0);

  uintptr_t addr = (uintptr_t)str & 0xF0;
  for (int zeile = 0; zeile < zeilen; zeile++) {
    // char addr = str[zeile * ADDR_PER_ROW];
    printf("0x%X ", (unsigned int)addr);

    for (int c = 0; c < ADDR_PER_ROW; c++) {
      printf("%c", str[c + (zeile * ADDR_PER_ROW)]);
    }
    printf("\n");
    addr += 16;
  }
}

int findstring(char **start, char *a) { return 0; }
