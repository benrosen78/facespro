#import "BRFPPreferencesManager.h"
#import <Cephei/HBPreferences.h>
#import <libcolorpicker.h>

static NSString *const kBRFPEnabledKey = @"Enabled";
static NSString *const kBRFPTintAllKey = @"Tint";
static NSString *const kBRFPAlphaKey = @"Alpha";

@implementation BRFPPreferencesManager {
	HBPreferences *_preferences;
	NSString *_hexForAllButtons;
}

+ (instancetype)sharedInstance {
	static BRFPPreferencesManager *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});

	return sharedInstance;
}

- (instancetype)init {
	if (self = [super init]) {
		_preferences = [[HBPreferences alloc] initWithIdentifier:@"me.benrosen.facespro"];

		[_preferences registerBool:&_enabled default:YES forKey:kBRFPEnabledKey];
		[_preferences registerObject:&_hexForAllButtons default:nil forKey:kBRFPTintAllKey];
		[_preferences registerFloat:&_alpha default:0.5f forKey:kBRFPAlphaKey];
	}
	return self;
}

- (UIColor *)colorForPasscodeButtonString:(NSString *)string {
	NSString *potentialIndividualTint = _preferences[string][@"Tint"];
	if (potentialIndividualTint) {
		return LCPParseColorString(potentialIndividualTint, @"#000000");
	}
	return _hexForAllButtons ? LCPParseColorString(_hexForAllButtons, @"#000000") : [UIColor clearColor];
}

#pragma mark - Memory management

- (void)dealloc {
	[_preferences release];

	[super dealloc];
}

@end
