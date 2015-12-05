#import <Preferences/PSListController.h>

UIImage *userLockscreenWallpaper();

@interface CPFacesProListController : PSListController {
	UIStatusBarStyle prevStatusStyle;
}

- (id)specifiersForPlistName:(NSString *)plistName;

@end
