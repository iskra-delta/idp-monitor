# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

# Check if all required tools are on the system.
REQUIRED = sdasz80 sed sdobjcopy
K := $(foreach exec,$(REQUIRED),\
    $(if $(shell which $(exec)),,$(error "$(exec) not found. Please install or add to path.")))

# Passed into makefile, default is top of shared RAM on partner
# minus 1 page for shared monitor stack
MONITOR_ADDRESS ?= 0xef00
MONITOR_STACK ?= 0xff00
MONITOR_SIZE ?= 0x1000

# Tools.
AS = sdasz80
AS_FLAGS = 
LD = sdldz80
LD_FLAGS = -iy
OBJCOPY = sdobjcopy

# Folders.
ROOT = $(realpath .)
BUILD_DIR = $(ROOT)/build
BIN_DIR = $(ROOT)/bin
SRC_DIR = $(ROOT)/src

# Define configuration template and ouput file.
CFG_TEMPLATE = $(ROOT)/config_template.in
CFG = $(SRC_DIR)/config.inc

# Assembler files.
SRC_FILES = $(wildcard $(SRC_DIR)/*.s)
BIN_FILES = $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.bin,$(SRC_FILES))

TARGET = monitor.rom

.PHONY:	all clean
all: create_dirs $(CFG) monitor

create_dirs:
	@mkdir -p $(BIN_DIR) $(BUILD_DIR)

$(CFG): $(CFG_TEMPLATE)
	sed -e 's/CFG_MONITOR_ADDRESS/$(MONITOR_ADDRESS)/' \
	-e 's/CFG_MONITOR_STACK/$(MONITOR_STACK)/' \
	-e 's/CFG_MONITOR_SIZE/$(MONITOR_SIZE)/' $(CFG_TEMPLATE) > $(CFG)

monitor: $(BIN_FILES)
	@cat $(BIN_FILES) > $(BIN_DIR)/$(TARGET)

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.ihx
	$(OBJCOPY) -I ihex -O binary $(basename $@).ihx $(basename $@).bin

$(BUILD_DIR)/%.ihx: $(BUILD_DIR)/%.rel
	$(LD) $(LD_FLAGS) -o $@ $<

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	$(AS) $(AS_FLAGS) -o $@ $<

clean:
	@rm -f $(CFG)
	@rm -rf $(BIN_DIR) $(BUILD_DIR)