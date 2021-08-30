################################################################################
#
# FLYCAST
#
################################################################################
# Version.: Release on May 29, 2021
FLYCAST_VERSION = v1.0
FLYCAST_SITE = https://github.com/flyinghead/flycast.git
FLYCAST_SITE_METHOD=git
FLYCAST_GIT_SUBMODULES=YES
FLYCAST_LICENSE = GPLv2
FLYCAST_DEPENDENCIES = sdl2 libpng libzip

	FLYCAST_DEPENDENCIES += udev

	FLYCAST_PLATFORM = rockchip
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
	FLYCAST_PLATFORM = armv7h neon
	FLYCAST_EXTRA_ARGS += USE_GLES=1
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
FLYCAST_EXTRA_ARGS += EXTRAFLAGS=-Wl,-lmali

define FLYCAST_UPDATE_INCLUDES
	sed -i "s+/opt/vc+$(STAGING_DIR)/usr+g" $(@D)/shell/linux/Makefile
	sed -i "s+sdl2-config+$(STAGING_DIR)/usr/bin/sdl2-config+g" $(@D)/shell/linux/Makefile
endef

define FLYCAST_HACK_X11
	sed -i "s+\`pkg-config --cflags x11\`++g" $(@D)/shell/linux/Makefile
	sed -i "s+\`pkg-config --libs x11\`+-lX11+g" $(@D)/shell/linux/Makefile
endef

FLYCAST_PRE_CONFIGURE_HOOKS += FLYCAST_UPDATE_INCLUDES
FLYCAST_PRE_CONFIGURE_HOOKS += FLYCAST_HACK_X11

define FLYCAST_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/shell/linux -f Makefile \
		platform="$(FLYCAST_PLATFORM)" $(FLYCAST_EXTRA_ARGS)
endef

define FLYCAST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/shell/linux/nosym-flycast.elf \
		$(TARGET_DIR)/usr/bin/flycast
endef

$(eval $(generic-package))

