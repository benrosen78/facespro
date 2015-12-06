#import <Cephei/HBPreferences.h>

static NSString *const kBRFPEnabledKey = @"Enabled";

@interface BRFPPreferencesManager : NSObject

@property (readonly) BOOL enabled;

+ (instancetype)sharedInstance;

- (void)listenForPreferenceChangeWithCallback:(HBPreferencesValueChangeCallback)callback forKey:(NSString *)key;

@end
