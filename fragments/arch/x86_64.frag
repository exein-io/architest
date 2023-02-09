BR2_x86_64=y
BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/x86_64/linux.config"

# Set architecture for post-image-qemu.sh
BR2_ROOTFS_POST_SCRIPT_ARGS="x86_64"
