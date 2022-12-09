#include <stdlib.h>

extern int addsub(int num1, int num2, char operation, unsigned short *flags);

typedef struct {
  int num1;
  char operation;
  int num2;
  unsigned short *flags;
  int result;
} result_info;

void build_result_info(result_info *ri, char **argv) {
  ri->num1 = atoi(argv[0]);
  ri->operation = atoi(argv[1]);
  ri->num2 = atoi(argv[2]);

  ri->result = addsub(ri->num1, ri->num2, ri->operation, ri->flags);
}

void print_flags(unsigned short *flags) {}
void cite_signed(result_info *ri) {}
void cite_unsigned(result_info *ri) {}

int main(int argc, char *argv[]) {
  if (argc != 3) {
    return -1;
  }

  result_info ri;
  build_result_info(&ri, argv);

  print_flags(ri.flags);
  cite_signed(&ri);
  cite_unsigned(&ri);

  return 0;
}
