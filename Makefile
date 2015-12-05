THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
export ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = quantumTweaksLogo.png
quantumTweaksLogo.png_FILES = quantumTweaksLogo.mm
quantumTweaksLogo.png_LIBRARIES = MobileGestalt
quantumTweaksLogo.png_INSTALL_PATH = /Library/PreferenceBundles/FacesPro.bundle/

TWEAK_NAME = AFacesPro
AFacesPro_FILES = FacesPro.xm FacesProSettingsManager.m UIImage+DominantColor.m
AFacesPro_FRAMEWORKS = UIKit CoreGraphics AddressBook AddressBookUI
AFacesPro_PRIVATE_FRAMEWORKS = SpringBoardUI
AFacesPro_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tool.mk
include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += facespro
include $(THEOS_MAKE_PATH)/aggregate.mk
