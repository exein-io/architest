BR2_mips64=y
BR2_MIPS_NABI64=y
BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/mips64-malta/linux.config"
BR2_LINUX_KERNEL_VMLINUX=y

# Set architecture for post-image-qemu.sh
BR2_ROOTFS_POST_SCRIPT_ARGS="mips"
