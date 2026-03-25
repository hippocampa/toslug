#include <ctype.h>
#include <getopt.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h> // getopt

#define FLAG_UNDERSCORE (1U << 0)

void transform(char *str, char *sep);

static const char help_text[] = "toslug\n\n"
                                "usage:\n"
                                "toslug <text> <flags>\n\n"
                                "flags:\n"
                                "-u\tUse hyphen separator. (default)\n"
                                "-U\tUse underscore separator.\n"
                                "-h\tShow help";

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
    case 'h':
      printf("%s\n", help_text);
      return EXIT_FAILURE;

    default:
      fprintf(stderr, "%s\n", help_text);
      return EXIT_FAILURE;
    }
  }

  if (optind >= argc) {
    fprintf(stderr, "Error: Missing text input.\n%s\n", help_text);
    return EXIT_FAILURE;
  }
  char *text = argv[optind];
  char separator = (flags & FLAG_UNDERSCORE) ? '_' : '-';

  transform(text, &separator);
  printf("%s", text);
  return EXIT_SUCCESS;
}

void transform(char *str, char *sep) {
  size_t i = 0;
  size_t j = 0;
  bool last_was_sep = true;
  while (str[i] != '\0') {
    unsigned char c = (unsigned char)str[i];
    if (isalnum(c)) {
      str[j++] = tolower(c);
      last_was_sep = false;
    } else if (!last_was_sep) {
      str[j++] = *sep;
      last_was_sep = true;
    }
    i++;
  }
  if (j > 0 && str[j - 1] == '-') {
    j--;
  }

  str[j] = '\0';
}
