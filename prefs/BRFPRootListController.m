#include "BRFPRootListController.h"
#import "UIImage+AverageColor.h"
#import <UIKit/UIImage+Private.h>

@implementation BRFPRootListController

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
    UIImage *wallpaper = [UIImage imageWithContentsOfCPBitmapFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap" flags:kNilOptions];
	return [wallpaper facesPro_averageColor];
}

+ (BOOL)hb_invertedNavigationBar {
	return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *headerLogo = [UIImage imageNamed:@"facesHeaderLogo" inBundle:[NSBundle bundleForClass:self.class]];
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
