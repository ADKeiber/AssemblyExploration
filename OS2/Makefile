ASM = nasm

SRC_DIR = src
BUILD_DIR = build

#Builds the image needed for the bootloader
$(BUILD_DIR)/main.img: $(BUILD_DIR)/main.bin 
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.img 
	truncate -s 1440k $(BUILD_DIR)/main.img
#trunacte make sure to fill the rest of the "floppy" which has 1440k bytes

# Creates a bin file from main.asm and places it in build directory
$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.asm
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin