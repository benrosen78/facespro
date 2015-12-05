@interface FacesProSettingsManager : NSObject

@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;

@property (nonatomic, readonly) CGFloat alpha;

+ (instancetype)sharedManager;

- (void)updateSettings;

- (NSString *)phoneNumberForButtonString:(NSString *)stringCharacter;

- (UIColor *)tintBackgroundColorForButtonString:(NSString *)stringCharacter;

@end