# Add common overlay fs
BR2_ROOTFS_OVERLAY="$(BR2_EXTERNAL_testeroot_PATH)/board/exein/common/overlay/"

# Use headers for 5.15
BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_5_15=y

# Adds the start_qemu.sh script
BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_testeroot_PATH)/board/exein/common/post-image-qemu.sh"

# Customize busybox
BR2_PACKAGE_BUSYBOX_CONFIG="$(BR2_EXTERNAL_testeroot_PATH)/board/exein/common/busybox.config"


BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="$(BR2_EXTERNAL_testeroot_PATH)/board/exein/common/linux.config"


# Add host pahole tool (needed to extract BPF info)
BR2_LINUX_KERNEL_NEEDS_HOST_PAHOLE=y

BR2_LINUX_KERNEL=y
BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_5_15=y

# Needed?
# BR2_LINUX_KERNEL_NEEDS_HOST_LIBELF=y

# qemu support
BR2_TARGET_ROOTFS_EXT2=y
BR2_PACKAGE_HOST_QEMU=y
BR2_PACKAGE_HOST_QEMU_SYSTEM_MODE=y

# Extra packages
BR2_PACKAGE_OPENSSH=y
