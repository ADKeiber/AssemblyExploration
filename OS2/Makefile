ASM = nasm

SRC_DIR = src
BUILD_DIR = build

# Floppy disk image
# Builds the image needed for the bootloader
#trunacte make sure to fill the rest of the "floppy" which has 1440k bytes
floppy_image: $(BUILD_DIR)/main.img
$(BUILD_DIR)/main.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main.img bs=512 count=2880
	mkfs.fat -F 12 -n "JAZZOS" $(BUILD_DIR)/main.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
# Notes about above dd copies dev/zero into main.img. Note dev/zero outputs a bunch of zeros in blocks of 512, 2880 times
# NOTE (again) 512 is the size of a sector and 2880 is the amount of sectors on a 1.33mb floppy disk. 
# Effectively this initilizes 1.33 mb with null (zero) data
# at line 13 we are copying the bootloader bin into main.img and we set it to not truncate
# at line 14 we use mcopy to copy more data into main.img without overwriting any data. 
#	We are copying kernel.bin and we can access it via ::kernel.bin



# Bootloader
# Creates a bin file from boot.asm and places it in build directory
bootloader: $(BUILD_DIR)/bootloader.bin
$(BUILD_DIR)/bootloader.bin:
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

# Kernel
# Creates a bin file from main.asm and places it in build directory
kernel: $(BUILD_DIR)/kernel.bin
$(BUILD_DIR)/kernel.bin:
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin