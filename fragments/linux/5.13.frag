BR2_LINUX_KERNEL_CUSTOM_VERSION=y
BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="5.13.10"
BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_5_15=n
BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_5_13=y

# Kernel 5.15 failed to build with pahole 2.24, downgrading to 2.22
BR2_PACKAGE_HOST_PAHOLEOLD=y
# This is a hack because I didn't find a way to override pahole with the old version:
# - I've added a host-paholeold package with pahole 2.22
# - I make sure to build it after host-pahole, so that it overridedes host/usr/bin/pahole
LINUX_DEPENDENCIES+=host-paholeold
HOST_PAHOLEOLD_DEPENDENCIES+=host-pahole
