include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AFacesPro
AFacesPro_FILES = Tweak.xm BRFPPreferencesManager.m UIImage+AverageColor.m
AFacesPro_FRAMEWORKS = CoreGraphics Contacts AddressBookUI Cephei
AFacesPro_EXTRA_FRAMEWORKS = Cephei
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
