include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FacesPro
FacesPro_FILES = $(wildcard *.m) $(wildcard *.x)
FacesPro_INSTALL_PATH = /Library/PreferenceBundles
FacesPro_FRAMEWORKS = UIKit
FacesPro_PRIVATE_FRAMEWORKS = Preferences AppSupport SpringBoardUIServices
FacesPro_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
FacesPro_LIBRARIES = MobileGestalt colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FacesPro.plist$(ECHO_END)
