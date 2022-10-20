#include <malloc.h>
#include <stdio.h>
#include <string.h>

void memdump(unsigned char *str, unsigned zeilen);
int memreplace(char *string, char cin, char cout, char **caddr);

int main(int argc, char *argv[]) {
  char *copy = malloc(argc * sizeof(char));
  strcpy(copy, *argv);

  printf("%s", copy);

  free(copy);
  return 0;
}

void memdump(unsigned char *str, unsigned zeilen) {}
int memreplace(char *string, char cin, char cout, char **caddr) { return 0; }
