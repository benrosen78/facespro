#include "BRFPRootListController.h"
#import "UIImage+AverageColor.h"
#import <UIKit/UIImage+Private.h>

@implementation BRFPRootListController

UIImage *userLockscreenWallpaper() {
    NSData *lockscreenWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
    if (lockscreenWallpaperData) {
        CFDataRef lockscreenWallpaperDataRef = CFDataCreate(NULL, lockscreenWallpaperData.bytes, lockscreenWallpaperData.length);
        CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);
        CFArrayRef wallpaperArray = CPBitmapCreateImagesFromData(lockscreenWallpaperDataRef, NULL, 1, NULL);
        CFRelease(lockscreenWallpaperDataRef);
        if(CFArrayGetCount(wallpaperArray) > 0) {
            CGImageRef lockscreenWallpaperRef = (CGImageRef)CFArrayGetValueAtIndex(wallpaperArray, 0);
            return [UIImage imageWithCGImage:lockscreenWallpaperRef];
        }
        CFRelease(wallpaperArray);
    }
    return [UIImage new];
}

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

+ (NSString *)hb_shareText {
	return @"#FacesPro by @benr9500 and @cpdigdarkroom lets me add images to my passcode buttons, hold to call, and much more! Available now on @BigBoss!";
}

+ (NSString *)hb_shareURL {
	return @"https://benrosen.me";
}

+ (UIColor *)hb_tintColor {
	return [userLockscreenWallpaper() averageColor];
}

+ (BOOL)hb_invertedNavigationBar {
	return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *headerLogo = [UIImage imageNamed:@"icon" inBundle:[NSBundle bundleForClass:self.class]];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:headerLogo] autorelease];
    self.navigationItem.titleView.alpha = 0.0;

    [self performSelector:@selector(animateIconAlpha) withObject:nil afterDelay:0.5];
}

- (void)animateIconAlpha {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationItem.titleView.alpha = 1;
    } completion:nil];
}

@end
