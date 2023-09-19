# Tools.
export AS = sdasz80
export AS_FLAGS = -l
export LD = sdldz80
export LD_FLAGS = -iy
export OBJCOPY = sdobjcopy
export OBJCOPY_FLAGS = -I ihex -O binary 
export COPY = cp

# Folders
SUBDIRS = monitor head
BIN_FILES = $(BUILD_DIR)/head.bin $(BUILD_DIR)/monitor.bin 

# Target 
TARGET = monitor.rom

# Rules.
.PHONY: all clean
all:	$(SUBDIRS) glue

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@
	
glue:
	@cat $(BIN_FILES) > $(BIN_DIR)/$(TARGET)
	truncate --size=16k $(BIN_DIR)/$(TARGET) 
	fuse	--rom-48 $(BIN_DIR)/$(TARGET) \
			--machine 48 \
			--graphics-filter 2x \
			--no-sound \
			--writable-roms \
			--debugger-command "t 0x0000"

clean: