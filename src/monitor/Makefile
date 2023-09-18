# Folders.
SRC_DIR = $(realpath .)

# Assembler files.
HEAD = $(SRC_DIR)/monitor.s
SRC_FILES = $(filter-out $(SRC_DIR)/monitor.s, \
			$(wildcard $(SRC_DIR)/*.s))
REL_FILES = $(BUILD_DIR)/monitor.rel \
			$(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.rel,$(SRC_FILES))

TARGET = monitor

GETSIZE=0x`grep s__MEMTOP $(BUILD_DIR)/monitor.map | rev | cut -b12-15 | rev`

.PHONY:	all clean
all: $(BUILD_DIR)/$(TARGET).bin
	
$(BUILD_DIR)/$(TARGET).bin : $(BUILD_DIR)/$(TARGET).ihx
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(BUILD_DIR)/$(TARGET).ihx \
		$(BUILD_DIR)/$(TARGET).bin
	
$(BUILD_DIR)/$(TARGET).ihx: $(REL_FILES)
	$(LD) $(LD_FLAGS) -o $@ $(REL_FILES)
	sed -e "s#CFG_MONITOR_SIZE#$(GETSIZE)#" $(CFG_IN) > $(CFG_OUT)
	$(LD) $(LD_FLAGS) -b _CODE=$(GETSIZE) -o $@ $(REL_FILES)

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	$(AS) $(AS_FLAGS) -o $@ $<

clean: