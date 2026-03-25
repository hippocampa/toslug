ifneq (,$(findstring Windows,$(OS)))
    SHELL := cmd.exe
endif

ifeq ($(OS),Windows_NT)
    EXT := .exe
    RM := rmdir /s /q
    MKDIR_P = if not exist $(call FIX_PATH,$1) mkdir $(call FIX_PATH,$1)
    EXEC_PREFIX :=
    FIX_PATH = $(subst /,\,$1)
    ZIP := powershell -NoProfile -ExecutionPolicy Bypass -Command Compress-Archive -Force
    TAR :=
    CAT := cmd /c type
    CP := copy /y
    
    # Check if strip exists, otherwise dummy
    STRIP := touch
else
    EXT :=
    RM := rm -rf
    MKDIR_P = mkdir -p $1
    EXEC_PREFIX := ./
    FIX_PATH = $1
    ZIP := zip -j
    TAR := tar -czf
    CAT := cat
    CP := cp
    STRIP := strip
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

# Use strip to remove whitespace
VERSION := $(strip $(shell $(CAT) $(VERSION_FILE)))

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

SRCS := $(SRC_DIR)/main.c
ifeq ($(OS),Windows_NT)
SRCS += $(SRC_DIR)/getopt.c
endif

$(TARGET): $(SRCS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SRCS) -o $@

$(DIST_TARGET): $(TARGET) | $(DIST_DIR)
	$(CP) $(call FIX_PATH,$(TARGET)) $(call FIX_PATH,$(DIST_TARGET))
ifneq (,$(findstring Windows,$(OS)))
	-strip $(DIST_TARGET) 2>NUL || ver > NUL
endif
ifneq ($(OS),Windows_NT)
	@echo "Stripping binary..."
	-$(STRIP) $(DIST_TARGET) 2>/dev/null || true
endif

$(BIN_DIR):
	@$(call MKDIR_P,$(BIN_DIR))

$(DIST_DIR):
	@$(call MKDIR_P,$(DIST_DIR))

clean-dist:
ifneq (,$(findstring Windows,$(OS)))
	-$(RM) $(call FIX_PATH,$(DIST_DIR)) 2>NUL || ver > NUL
else
	$(RM) $(call FIX_PATH,$(DIST_DIR))
endif

# =========================
# PACKAGING
# =========================

package:
ifneq (,$(findstring Windows,$(OS)))
	$(ZIP) -Path "$(call FIX_PATH,$(DIST_TARGET))" -DestinationPath "$(call FIX_PATH,$(DIST_DIR)/$(DIST_NAME).zip)"
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
