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
BIN_FILES = $(patsubst %,$(BUILD_DIR)/%.bin,$(SUBDIRS))

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

clean: