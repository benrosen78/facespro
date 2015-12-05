include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AFacesPro
AFacesPro_FILES = FacesPro.xm FacesProSettingsManager.m UIImage+DominantColor.m
AFacesPro_FRAMEWORKS = UIKit CoreGraphics AddressBook AddressBookUI
AFacesPro_PRIVATE_FRAMEWORKS = SpringBoardUI
AFacesPro_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
ifeq ($(RESPRING),0)
	install.exec "killall Preferences"
else
	install.exec spring
endif

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
