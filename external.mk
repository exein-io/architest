
# Pick the smaller of <kernel-version> and 5.17. If <kernel-version> is older than 5.17, downgrade pahole to 1.22
ifeq ($(shell printf '%s\n' "$(BR2_LINUX_KERNEL_VERSION)" 5.17 | sort -V | head -n1),$(BR2_LINUX_KERNEL_VERSION))
  include $(BR2_EXTERNAL_architest_PATH)/package/override/pahole-122.mk))
endif

# Uncomment this line if you want to include others packages
#include $(sort $(wildcard $(BR2_EXTERNAL_architest_PATH)/package/<package-name>/<package-name>.mk))
