#include <malloc.h>
#include <stdio.h>
#include <string.h>

#define ADDR_PER_ROW 16
#define ROWS 3

void memdump(unsigned char *str, unsigned zeilen);
int memreplace(char *string, char cin, char cout, char **caddr);

int main(int argc, char *argv[]) {
  memdump((unsigned char *)*argv, ROWS);
  printf("\n");
  char *copy = malloc(argc * sizeof(char));
  strcpy(copy, *argv);

  // printf("\n%s", copy);

  char *returnVal[2]; // returnVal[0] -> Count of exchanges | [1] -> last -1
                      // exchange address
  memreplace(copy, 'i', 'j', returnVal);
  memdump((unsigned char *)copy, 1);

  free(copy);
  return 0;
}

void printHeader() {
  // Header
  printf("%s", "ADDR ");
  // Hex
  for (int i = 0; i < ADDR_PER_ROW; i++) {
    printf("0%X ", i);
  }
  // Ascii
  for (int i = 0; i < ADDR_PER_ROW; i++) {
    printf("%X", i);
  }

  printf("\n");
}

void memdump(unsigned char *str, unsigned zeilen) {
  printHeader();

  for (int zeile = 0; zeile < zeilen; zeile++) {
    // * 16, da 16 Byte pro Zeile im memdump
    printf("0x%X ", str[zeile * ADDR_PER_ROW]);

    for (int c = 0; c < ADDR_PER_ROW; c++) {

      char character = str[zeile];
      if (character < 16) {
        printf("0%x ", character);
      } else {
        printf("%x ", character);
      }
    }
    for (int c = 0; c < ADDR_PER_ROW; c++) {
      printf("%c", str[c]);
    }
    printf("\n");
  }
}

int memreplace(char *string, char cin, char cout, char **caddr) { return 0; }
