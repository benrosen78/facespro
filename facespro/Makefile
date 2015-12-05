TARGET = :clang

include theos/makefiles/common.mk

BUNDLE_NAME = FacesPro
FacesPro_LDFLAGS += -FResources
FacesPro_FILES = FacesPro.mm $(wildcard *.m) $(wildcard JVAlertController/*.m)
FacesPro_INSTALL_PATH = /Library/PreferenceBundles
FacesPro_FRAMEWORKS = UIKit MessageUI Social CoreGraphics Foundation QuartzCore GoogleMobileAds AddressBookUI AddressBook AdSupport AudioToolbox AVFoundation CoreGraphics CoreMedia CoreTelephony EventKit EventKitUI MessageUI StoreKit SystemConfiguration
FacesPro_PRIVATE_FRAMEWORKS = Preferences AppSupport SpringBoardUIServices
FacesPro_LIBRARIES = MobileGestalt substrate colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FacesPro.plist$(ECHO_END)
