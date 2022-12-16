#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

extern int addsub(int num1, int num2, char operation, unsigned short *flags);

typedef struct {
  int num1;
  char operation;
  int num2;
  unsigned short *flags;
  int result;
} result_info;

void init_result_info(result_info *ri, char **argv) {
  ri->num1 = atoi(argv[1]);
  ri->operation = argv[2][0];
  ri->num2 = atoi(argv[3]);
  ri->flags = malloc(sizeof(unsigned short));

  ri->result = addsub(ri->num1, ri->num2, ri->operation, ri->flags);
}

void print_flags(unsigned short *flags) {
  char str[16];
  sprintf(str, "%b", *flags);
  printf("Flags:\nODITSZAPC\n%s\n", str);
}

void cite_signed(result_info *ri) {
}

void cite_unsigned(result_info *ri) {
}

int main(int argc, char *argv[]) {
  if (argc != 4) {
    fprintf(stderr, "Invalid use! Should be: <number1> <operation> <number2>");
    return -1;
  }

  result_info ri;
  init_result_info(&ri, argv);

  print_flags(ri.flags);
  cite_signed(&ri);

  free(ri.flags);
  return 0;
}
