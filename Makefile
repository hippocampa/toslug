ifeq ($(OS),Windows_NT)
    EXT := .exe
    RM := rmdir /s /q
    MKDIR := mkdir
    EXEC_PREFIX :=
    FIX_PATH = $(subst /,\,$1)
    ZIP := powershell Compress-Archive
    TAR :=
else
    EXT :=
    RM := rm -rf
    MKDIR := mkdir -p
    EXEC_PREFIX := ./
    FIX_PATH = $1
    ZIP := zip -j
    TAR := tar -czf
endif

APPNAME := toslug
CC := gcc

# =========================
# VERSION (from file)
# =========================

VERSION_FILE := VERSION

ifeq ($(wildcard $(VERSION_FILE)),)
$(error VERSION file not found)
endif

VERSION := $(shell cat $(VERSION_FILE))

# =========================
# FLAGS
# =========================

CFLAGS_BASE := -std=c17 -Wall -Wextra -Wpedantic

# =========================
# DIRS
# =========================

SRC_DIR := src
BIN_DIR := bin
DIST_DIR := dist

TARGET := $(BIN_DIR)/$(APPNAME)$(EXT)

# =========================
# PLATFORM DETECTION
# =========================

UNAME_S := $(shell uname -s 2>/dev/null)

ifeq ($(OS),Windows_NT)
    PLATFORM := windows
else ifeq ($(UNAME_S),Linux)
    PLATFORM := linux
else ifeq ($(UNAME_S),Darwin)
    PLATFORM := macos
else
    PLATFORM := unknown
endif

DIST_NAME := $(APPNAME)-$(VERSION)-$(PLATFORM)
DIST_TARGET := $(DIST_DIR)/$(DIST_NAME)$(EXT)

# =========================
# DEFAULT
# =========================

all: debug

# =========================
# BUILD MODES
# =========================

debug: CFLAGS := $(CFLAGS_BASE) -O0 -g
debug: $(TARGET)
	@echo "Debug build completed."

release: CFLAGS := $(CFLAGS_BASE) -O2 -DNDEBUG
release: clean-dist $(DIST_TARGET) package checksum
	@echo "Release build completed → dist/ ready."

# =========================
# CORE BUILD
# =========================

$(TARGET): $(SRC_DIR)/main.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(DIST_TARGET): $(TARGET) | $(DIST_DIR)
	cp $(TARGET) $(DIST_TARGET)
	@echo "Stripping binary..."
	-strip $(DIST_TARGET) 2>/dev/null || true

$(BIN_DIR):
	$(MKDIR) $(BIN_DIR)

$(DIST_DIR):
	$(MKDIR) $(DIST_DIR)

clean-dist:
	$(RM) $(call FIX_PATH,$(DIST_DIR))

# =========================
# PACKAGING
# =========================

package:
ifeq ($(OS),Windows_NT)
	$(ZIP) $(DIST_DIR)/$(DIST_NAME).zip $(DIST_TARGET)
else
	$(TAR) $(DIST_DIR)/$(DIST_NAME).tar.gz -C $(DIST_DIR) $(DIST_NAME)
endif
	@echo "Package created."

# =========================
# CHECKSUM
# =========================

checksum:
ifeq ($(OS),Windows_NT)
	certutil -hashfile $(DIST_TARGET) SHA256 > $(DIST_TARGET).sha256
else
	sha256sum $(DIST_TARGET) > $(DIST_TARGET).sha256
endif
	@echo "Checksum generated."

# =========================
# UTILITIES
# =========================

run: debug
	$(EXEC_PREFIX)$(TARGET)

run-release: release
	$(EXEC_PREFIX)$(DIST_TARGET)

clean:
	$(RM) $(call FIX_PATH,$(BIN_DIR))
	$(RM) $(call FIX_PATH,$(DIST_DIR))
	@echo "Cleanup completed."

.PHONY: all debug release package checksum clean clean-dist run run-release
