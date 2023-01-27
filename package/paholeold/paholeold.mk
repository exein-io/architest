################################################################################
#
# pahole
#
################################################################################

PAHOLEOLD_VERSION = v1.22
PAHOLEOLD_SITE = git://git.kernel.org/pub/scm/devel/pahole/pahole.git
PAHOLEOLD_SITE_METHOD = git
HOST_PAHOLEOLD_DEPENDENCIES = host-elfutils 
PAHOLEOLD_LICENSE = GPL-2.0
PAHOLEOLD_LICENSE_FILES = COPYING
PAHOLEOLD_GIT_SUBMODULES = YES
HOST_PAHOLEOLD_CONF_OPTS = -D__LIB=lib


$(eval $(host-cmake-package))
