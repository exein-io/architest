# Kernel 5.15 failed to build with pahole 2.24, downgrading to 2.22

# This is a hack because I didn't find a way to override pahole with the old version:
# - added a host-paholeold package with pahole 2.22
# - we install host-pahole first, then host-paholeold, which overridedes host/usr/bin/pahole

# The _EXTRAXT_DEPENDENCIES is the hack within the hack to modify a package depdendencies
# from the outside.
# See https://lore.kernel.org/all/d459a460-312b-3daf-4b9f-a36974334b6b@mind.be/t/
HOST_PAHOLEOLD_EXTRACT_DEPENDENCIES=host-pahole
LINUX_EXTRACT_DEPENDENCIES=host-paholeold
