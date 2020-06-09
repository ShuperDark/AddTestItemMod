THEOS_PACKAGE_DIR_NAME = debs

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AddTestItemMod

AddTestItemMod_FILES = Tweak.xm
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk/
AddTestItemMod_FRAMEWORKS = UIKit MessageUI Social QuartzCore CoreGraphics Foundation AVFoundation Accelerate GLKit SystemConfiguration
AddTestItemMod_CFLAGS = -fobjc-arc
AddTestItemMod_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG

ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/aggregate.mk

after-install::
	install.exec "killall -9 '-'"