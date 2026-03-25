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

# base flags (shared)
CFLAGS_BASE := -std=c17 -Wall -Wextra -Wpedantic
SRC_DIR := src
BIN_DIR := bin

TARGET := $(BIN_DIR)/$(APPNAME)$(EXT)

# default → debug (lebih aman untuk dev)
all: debug

# =========================
# BUILD MODES
# =========================

debug: CFLAGS := $(CFLAGS_BASE) -O0 -g
debug: $(TARGET)
	@echo "Debug build completed."

release: CFLAGS := $(CFLAGS_BASE) -O2 -DNDEBUG
release: $(TARGET)
	@echo "Release build completed."

# =========================
# CORE BUILD
# =========================

$(TARGET): $(SRC_DIR)/main.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR):
	$(MKDIR) $(BIN_DIR)

# =========================
# UTILITIES
# =========================

run: debug
	$(EXEC_PREFIX)$(TARGET)

run-release: release
	$(EXEC_PREFIX)$(TARGET)

clean:
	$(RM) $(call FIX_PATH,$(BIN_DIR))
	@echo "Cleanup process completed."

.PHONY: all debug release run run-release clean
