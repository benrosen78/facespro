#import <Cephei/HBPreferences.h>
#import <Contacts/Contacts.h>

@interface BRFPPreferencesManager : NSObject

@property (nonatomic, readonly) BOOL enabled;

@property (nonatomic, readonly) BOOL hidePasscodeNumbersAndLetters;

@property (nonatomic, readonly) CGFloat alpha;

+ (instancetype)sharedInstance;

- (UIColor *)colorForPasscodeButtonString:(NSString *)string;

- (NSString *)phoneNumberForPasscodeButtonString:(NSString *)string;

@end
