#include <stdio.h>

const char *helpText = 
  "toslug\n\n"
  "usage:\n"
  "toslug <text> <flags>\n\n"
  "flags:\n"
  "-h\t--use-hyphen\tUse hyphen separator. (default)\n"
  "-u\t--use-underscore\tUse underscore separator.";
;


int main(int argc, char *argv[]){
  if (argc < 2) {
    printf("%s\n", helpText);

  }
}
