# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

# Check if all required tools are on the system.
REQUIRED = sdasz80 sed sdobjcopy grep
K := $(foreach exec,$(REQUIRED),\
    $(if $(shell which $(exec)),,$(error "$(exec) not found. Please install or add to path.")))

# Folders.
export ROOT = $(realpath .)
export BUILD_DIR = $(ROOT)/build
export BIN_DIR = $(ROOT)/bin
SRC_DIR = $(ROOT)/src

# Config file
export CFG_IN = $(SRC_DIR)/config_template.in
export CFG_OUT = $(SRC_DIR)/config.inc

# Tools.
MAKE = make

.PHONY:	all clean
all: create_dirs $(SRC_DIR)

create_dirs:
	@mkdir -p $(BIN_DIR) $(BUILD_DIR)

.PHONY: $(SRC_DIR)
$(SRC_DIR):
	$(MAKE) -C $@

clean:
	@rm -rf $(BIN_DIR) $(BUILD_DIR)