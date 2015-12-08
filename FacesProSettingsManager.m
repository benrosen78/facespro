#import "FacesProSettingsManager.h"
#import "FacesPro.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <libcolorpicker.h>
#import <Contacts/Contacts.h>

@interface FacesProSettingsManager ()

@property (nonatomic, copy) NSDictionary *settings;

@end

@implementation FacesProSettingsManager

+ (instancetype)sharedManager {
    static dispatch_once_t p = 0;
    __strong static id _sharedSelf = nil;
    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
    });
    return _sharedSelf;
}

void settingsChanged(CFNotificationCenterRef center,
                     void * observer,
                     CFStringRef name,
                     const void * object,
                     CFDictionaryRef userInfo) {
    [[FacesProSettingsManager sharedManager] updateSettings];
}

- (id)init {
    if (self = [super init]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR("com.cpdigitaldarkroom.benrosen.facespro/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        [self updateSettings];
    }

    return self;
}

- (void)updateSettings {
    self.settings = [NSDictionary dictionaryWithContentsOfFile:TWEAK_SETTINGS_PATH];
}

- (BOOL)isEnabled {
    return self.settings[@"isEnabled"] ? [self.settings[@"isEnabled"] boolValue] : YES;
}

- (CGFloat)alpha {
    return self.settings[@"alpha"] ? [self.settings[@"alpha"] floatValue] : 0.5;
}

- (UIColor *)tintBackgroundColorForButtonString:(NSString *)stringCharacter {
    if (self.settings[stringCharacter][@"tint"]) {
        return LCPParseColorString(self.settings[stringCharacter][@"tint"], @"#000000");
    }
    return self.settings[@"tint"] ? LCPParseColorString(self.settings[@"tint"], @"#000000") : [UIColor clearColor];
}

- (NSString *)phoneNumberForSetContactOnButtonString:(NSString *)string {

}

@end
