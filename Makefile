THEOS_DEVICE_IP=192.168.0.11
THEOS_DEVICE_PORT=22

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FacesPro
FacesPro_FILES = Tweak.xm BRFPPreferencesManager.m UIImage+AverageColor.m
FacesPro_FRAMEWORKS = CoreGraphics Contacts AddressBookUI Cephei
FacesPro_EXTRA_FRAMEWORKS = Cephei
FacesPro_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
ifeq ($(RESPRING),0)
	install.exec "killall Preferences"
else
	install.exec spring
endif

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
