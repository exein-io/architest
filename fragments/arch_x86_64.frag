BR2_x86_64=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/x86_64/linux.config"

# Enable the upstream buildroot qemu post-build script
# TODO: is this actually needed?
# BR2_ROOTFS_POST_BUILD_SCRIPT="board/qemu/x86_64/post-build.sh"
# BR2_ROOTFS_POST_SCRIPT_ARGS="$(BR2_DEFCONFIG)"
