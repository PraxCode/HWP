#include <malloc.h>
#include <stdio.h>
#include <string.h>

#define ADDR_PER_ROW 16

void memdump(unsigned char *str, unsigned zeilen);
int memreplace(char *string, char cin, char cout, char **caddr);

int main(int argc, char *argv[]) {
  memdump((unsigned char *)*argv, 3);
  printf("\n");
  char *copy = malloc(argc * sizeof(char));
  strcpy(copy, *argv);

  printf("\n%s", copy);

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

      char character = str[c];
      if (character < 16) {
        printf("0%x ", character);
      } else {
        printf("%x ", character);
      }
    }
    printf("\n");
  }

  // print str[zeile]
  // loop over chars and print (format)
  // Somehow manage segmention fault
}
int memreplace(char *string, char cin, char cout, char **caddr) { return 0; }
