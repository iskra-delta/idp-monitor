# Folders.
SRC_DIR = $(realpath .)

# Single file!
TARGET = head

# Assembler files.
SRC_FILES = $(SRC_DIR)/$(TARGET).s
REL_FILES = $(BUILD_DIR)/$(TARGET).rel

.PHONY:	all clean
all: $(BUILD_DIR)/$(TARGET).bin
	
$(BUILD_DIR)/$(TARGET).bin : $(BUILD_DIR)/$(TARGET).ihx
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(BUILD_DIR)/$(TARGET).ihx \
		$(BUILD_DIR)/$(TARGET).bin
	
$(BUILD_DIR)/$(TARGET).ihx: $(REL_FILES)
	$(LD) $(LD_FLAGS) -o $@ $(REL_FILES)

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	$(AS) $(AS_FLAGS) -o $@ $<

clean: