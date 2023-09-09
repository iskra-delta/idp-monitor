# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

# Check if all required tools are on the system.
REQUIRED = sdasz80 sed
K := $(foreach exec,$(REQUIRED),\
    $(if $(shell which $(exec)),,$(error "$(exec) not found. Please install or add to path.")))

# Global settings: folders.
ROOT = $(realpath .)
BUILD_DIR			=	$(ROOT)/build
BIN_DIR				=	$(ROOT)/bin
SRC_DIR				=	$(ROOT)

# Tools.
AS 					=	sdasz80
AS_FLAGS			=	

# Define configuration template and ouput file.
CFG_TEMPLATE 		=	config_template.in
CFG 				=	config.inc

# Passed into makefile, default is top of shared RAM on partner
# minus 1 page for shared monitor stack
MONITOR_ADDRESS		?=	0xef00
MONITOR_STACK		?=	0xff00
MONITOR_SIZE		?=	0x1000

# Assembler files.
SRC_FILES			=	$(wildcard $(SRC_DIR)/*.s)
OUT_FILES			=	$(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.rel,$(SRC_FILES))

.PHONY:	all clean
all: create_dirs $(CFG) $(OUT_FILES)

clean:
	@rm -f $(CFG)
	@rm -rf $(BIN_DIR) $(BUILD_DIR)

$(CFG): $(CFG_TEMPLATE)
	sed -e 's/CFG_MONITOR_ADDRESS/$(MONITOR_ADDRESS)/' \
	-e 's/CFG_MONITOR_STACK/$(MONITOR_STACK)/' \
	-e 's/CFG_MONITOR_SIZE/$(MONITOR_SIZE)/' $(CFG_TEMPLATE) > $(CFG)

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	$(AS) $(AS_FLAGS) -o $@ $<

create_dirs:
	@mkdir -p $(BIN_DIR) $(BUILD_DIR)