#import "BRFPPreferencesManager.h"
#import <Cephei/HBPreferences.h>

@implementation BRFPPreferencesManager {
	HBPreferences *_preferences;
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
	}
	return self;
}

- (void)listenForPreferenceChangeWithCallback:(HBPreferencesValueChangeCallback)callback forKey:(NSString *)key {
	[_preferences registerPreferenceChangeBlock:callback forKey:key];
}

#pragma mark - Memory management

- (void)dealloc {
	[_preferences release];

	[super dealloc];
}

@end
