ASM = nasm

SRC_DIR = src
BUILD_DIR = build

#Builds the image needed for the bootloader
$(BUILD_DIR)/main.img: $(BUILD_DIR)/main.bin 
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.img 
	truncate -s 1440k $(BUILD_DIR)/main.img
#trunacte make sure to fill the rest of the "floppy" which has 1440k bytes

# Bootloader
# Creates a bin file from boot.asm and places it in build directory
bootloader: $(BUILD_DIR)/bootloader.bin
$(BUILD_DIR)/bootloader.bin:
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o ${BUILD_DIR}/bootloader.bin

# Kernel
# Creates a bin file from main.asm and places it in build directory
kernel: $(BUILD_DIR)/kernel.bin
$(BUILD_DIR)/kernel.bin:
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o ${BUILD_DIR}/kernel.bin