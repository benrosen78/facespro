@interface FacesProSettingsManager : NSObject

@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;

@property (nonatomic, readonly) CGFloat alpha;

+ (instancetype)sharedManager;

- (void)updateSettings;

- (NSString *)phoneNumberForButtonString:(NSString *)string;

- (NSString *)phoneNumberForSetContactOnButtonString:(NSString *)string;

@end
