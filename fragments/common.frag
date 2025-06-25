# Add common overlay fs
BR2_ROOTFS_OVERLAY="$(BR2_EXTERNAL_architest_PATH)/board/exein/common/overlay/"

# Adds the start_qemu.sh script
BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_architest_PATH)/board/exein/common/post-image-qemu.sh"

# Customize busybox
BR2_PACKAGE_BUSYBOX_CONFIG="$(BR2_EXTERNAL_architest_PATH)/board/exein/common/busybox.config"

# Kernel version
BR2_LINUX_KERNEL=y
BR2_LINUX_KERNEL_CUSTOM_VERSION=y
BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="__KERNEL_VERSION__"

# Kernel headers
BR2_KERNEL_HEADERS_AS_KERNEL=n
BR2_KERNEL_HEADERS_5_15=y
BR2_KERNEL_HEADERS___HEADER_VERSION__=y

# Config to run Pulsar
BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="$(BR2_EXTERNAL_architest_PATH)/board/exein/common/__CONFIG_FILE__.config"

BR2_GLOBAL_PATCH_DIR="$(BR2_EXTERNAL_architest_PATH)/patches/"

# Add host pahole tool (needed to extract BPF info)
BR2_LINUX_KERNEL_NEEDS_HOST_PAHOLE=y

# Share downloaded packages between builds
BR2_DL_DIR="$(BR2_EXTERNAL_architest_PATH)/build/download/"

# qemu support
BR2_TARGET_ROOTFS_EXT2=y
BR2_PACKAGE_HOST_QEMU=y
BR2_PACKAGE_HOST_QEMU_SYSTEM_MODE=y

# Extra packages
BR2_PACKAGE_OPENSSH=y
BR2_PACKAGE_SQLITE=y
