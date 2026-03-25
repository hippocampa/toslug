ifeq ($(OS),Windows_NT)
    EXT := .exe
    RM := rmdir /s /q
    MKDIR := mkdir
    EXEC_PREFIX :=
    FIX_PATH = $(subst /,\,$1)
else
    EXT :=
    RM := rm -rf
    MKDIR := mkdir -p
    EXEC_PREFIX := ./
    FIX_PATH = $1
endif

APPNAME := toslug
CC      := gcc
CFLAGS  := -std=c17 -Wall -Wextra -Wpedantic -O2 -g
SRC_DIR := src
BIN_DIR := bin
TARGET  := $(BIN_DIR)/$(APPNAME)$(EXT)

all: $(TARGET)
	@echo "Build process completed successfully."

$(TARGET): $(SRC_DIR)/main.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR):
	$(MKDIR) $(BIN_DIR)

run: $(TARGET)
	$(EXEC_PREFIX)$(TARGET)

clean:
	$(RM) $(call FIX_PATH,$(BIN_DIR))
	@echo "Cleanup process completed."

.PHONY: all run clean
