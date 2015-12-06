#import <Cephei/HBPreferences.h>

@interface BRFPPreferencesManager : NSObject

@property (nonatomic, readonly) BOOL enabled;

@property (nonatomic, readonly) BOOL hidePasscodeNumbersAndLetters;

@property (nonatomic, readonly) CGFloat alpha;

+ (instancetype)sharedInstance;

- (UIColor *)colorForPasscodeButtonString:(NSString *)string;

@end
