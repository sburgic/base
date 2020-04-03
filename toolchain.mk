## Name
##   toolchain.mk
##
## Purpose
##   Toolchain definitions
##
## Revision
##    30-Mar-2020 (SSB) [] Initial
##    02-Apr-2020 (SSB) [] Remove linker script location. It shall be defined
##                         in the project central makefile
##    03-Apr-2020 (SSB) [] Update LDFLAGS_DEBUG

# Toolchain location
TOOLCHAIN_ROOT    ?= C:/gcc-arm-none-eabi
TARGET_TRIPLET    := arm-none-eabi
TOOLCHAIN_BIN_DIR := $(TOOLCHAIN_ROOT)/bin
TOOLCHAIN_INC_DIR := $(TOOLCHAIN_ROOT)/$(TARGET_TRIPLET)/include
TOOLCHAIN_LIB_DIR := $(TOOLCHAIN_ROOT)/$(TARGET_TRIPLET)/lib

# Tools location and definiton
CC     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-gcc
LD     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-ld
AR     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-ar
AS     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-as
OBJCPY := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-objcopy
OBJDMP := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-objdump
SIZE   := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-size

# Common flags for all tools
TOOLCHAIN_COMMON_FLAGS := -mcpu=cortex-m4 \
                          -mthumb \
                          -mfloat-abi=hard \
                          -mfpu=fpv4-sp-d16 \
                          -fmessage-length=0 \
                          -ffunction-sections \
                          -fdata-sections
# C standard
TOOLCHAIN_CSTANDARD := -std=gnu99

# Linker flags
LDFLAGS      := -T$(LDSCRIPT) \
                -static \
                -Wl,-cref,-u,Reset_Handler \
                -Wl,-Map=$(BIN_DIR)/$(PROJECT_NAME).map \
                -Wl,--gc-sections \
                -Wl,--defsym=malloc_getpagesize_P=0x80 \
                -Wl,--start-group -lc -lm -Wl,--end-group \
                --specs=nano.specs

# Compiler flags
CFLAGS := -Wall \
          # -Wextra \
          # -Wfatal-errors \
          # -Wpacked \
          # -Winline \
          # -Wfloat-equal \
          # -Wconversion \
          # -Wlogical-op \
          # -Wpointer-arith \
          # -Wdisabled-optimization \
          # -Wno-unused-parameter

# Build type modifiers
CFLAGS_DEBUG := -ggdb \
                -g3 \
                -Og
LDFLAGS_DEBUG := -Og
                 # --specs=rdimon.specs \
                 # -lrdimon
CFLAGS_RELEASE  := -Os
LDFLAGS_RELEASE := --specs=nosys.specs

CFLAGS  += $(CFLAGS_$(call toupper,$(BUILD_TYPE))) \
           $(TOOLCHAIN_COMMON_FLAGS) \
           $(TOOLCHAIN_CSTANDARD)

LDFLAGS += $(LDFLAGS_$(call toupper,$(BUILD_TYPE))) \
           $(TOOLCHAIN_COMMON_FLAGS)

# Build artifacts
TARGET_ELF   := $(BIN_DIR)/$(PROJECT_NAME).elf
TARGET_BIN   := $(BIN_DIR)/$(PROJECT_NAME).bin
TARGET_HEX   := $(BIN_DIR)/$(PROJECT_NAME).hex
