#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

static const char helpText[] = 
  "toslug\n\n"
  "usage:\n"
  "toslug <text> <flags>\n\n"
  "flags:\n"
  "-u\tUse hyphen separator. (default)\n"
  "-U\tUse underscore separator.";

enum Separator{
  HYPHEN,
  UNDERSCORE
};




int main(int argc, char *argv[]){
  enum Separator sep = HYPHEN;
  if (argc < 2) {
    fprintf(stderr, "%s\n", helpText);
    return EXIT_FAILURE;
  } else{
    for (size_t i = 2 ; i < argc ;i++) {
      if (strcmp(argv[i], "-u")) {
        sep = HYPHEN;
      }
    }
    printf("%s\n", );

  }
  return EXIT_SUCCESS;
}
