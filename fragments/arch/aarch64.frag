BR2_aarch64=y
BR2_cortex_a53=y
BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/aarch64-virt/linux.config"

# Set architecture for post-image-qemu.sh
BR2_ROOTFS_POST_SCRIPT_ARGS="aarch64"

