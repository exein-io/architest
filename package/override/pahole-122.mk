# This overrides the standard host-pahole package:
override PAHOLE_VERSION        = v1.22
#PAHOLE_SITE           = https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot
override PAHOLE_SITE           = git://git.kernel.org/pub/scm/devel/pahole/pahole.git
override PAHOLE_SITE_METHOD = git
PAHOLE_GIT_SUBMODULES = YES
#HOST_PAHOLE_DEPENDENCIES = host-elfutils host-libbpf
override HOST_PAHOLE_CONF_OPTS = -D__LIB=lib -DLIBBPF_EMBEDDED=ON #pick pahole's lib/bpf/ and not host's libbpf
override PAHOLE_HASH      = file://package/override/pahole-122.hash

$(info >>> OVERRIDE FILE LOADED – PAHOLE_VERSION=$(PAHOLE_VERSION))
