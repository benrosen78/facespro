#import <Preferences/Preferences.h>

UIImage *userLockscreenWallpaper();

@interface CPFacesProListController : PSListController {
	UIStatusBarStyle prevStatusStyle;
}

- (id)specifiersForPlistName:(NSString *)plistName;

@end