#include <malloc.h>
#include <stdio.h>
#include <string.h>

void memdump(unsigned char *str, unsigned zeilen);
int memreplace(char *string, char cin, char cout, char **caddr);

int main(int argc, char *argv[]) {
  memdump((unsigned char *)*argv, 3);
  char *copy = malloc(argc * sizeof(char));
  strcpy(copy, *argv);

  printf("\n%s", copy);

  free(copy);
  return 0;
}

void memdump(unsigned char *str, unsigned zeilen) {
  // Header
  printf("%s", "ADDR ");
  // Hex
  for (int i = 0; i < 16; i++) {
    printf("0%X ", i);
  }
  // Ascii
  for (int i = 0; i < 16; i++) {
    printf("%X", i);
  }
  printf("\n");

  for (int zeile = 0; zeile < zeilen; zeile++) {
    // sizeof unnötig, da sizeof(char) = 1
    // * 16, da 16 Byte pro Zeile im memdump
    printf("0x%X\n", str[zeile * 16 * sizeof(char)]);
  }

  // print str[zeile]
  // loop over chars and print
  // Somehow manage segmention fault
}
int memreplace(char *string, char cin, char cout, char **caddr) { return 0; }
