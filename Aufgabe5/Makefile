AS = nasm
CC = gcc
ASMFLAGS = -f elf64
CFLAGS = -Wall -Wextra -m64

SOURCE_DIR = source
BUILD_DIR = build
BINARY = $(BUILD_DIR)/a5

ASM_FILES := $(wildcard $(SOURCE_DIR)/*.asm)
C_FILES := $(wildcard $(SOURCE_DIR)/*.c)

OBJECT_FILES := $(patsubst $(SOURCE_DIR)/%.asm, $(BUILD_DIR)/%.o, $(ASM_FILES))
OBJECT_FILES += $(patsubst $(SOURCE_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_FILES))

$(BINARY): $(OBJECT_FILES)
	@echo -e "\n"
	$(CC) $(OBJECT_FILES) -o $(BINARY)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.asm $(BUILD_DIR)
	$(AS) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(BINARY)
	@echo -e "\033[0;32mCleaned Up Build Directory!"



