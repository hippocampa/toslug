#include <getopt.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h> // getopt

#define FLAG_UNDERSCORE (1U << 0)

static const char help_text[] =
    "toslug\n\n"
    "usage:\n"
    "toslug <text> <flags>\n\n"
    "flags:\n"
    "-u\t--use-hyphen\tUse hyphen separator. (default)\n"
    "-U\t--use-underscore\tUse underscore separator.";

int main(int argc, char *argv[]) {
  uint8_t flags = 0; // default to FLAG_HYPHEN
  int opt;

  while ((opt = getopt(argc, argv, "uU")) != -1) {
    switch (opt) {
    case 'u':
      flags &= ~FLAG_UNDERSCORE;
      break;
    case 'U':
      flags |= FLAG_UNDERSCORE;
      break;
    default:
      fprintf(stderr, "%s", help_text);
      return EXIT_FAILURE;
    }
  }

  if (optind >= argc) {
    fprintf(stderr, "Error: Missing text input.\n%s\n", help_text);
    return EXIT_FAILURE;
  }
  char *input_text = argv[optind];
  char separator = (flags & FLAG_UNDERSCORE) ? '_' : '-';
  printf("Separator: %c\n", separator);
  printf("Text: %s\n", input_text);
}
