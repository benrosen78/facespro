#import "BRFPConfigurationListController.h"
#import "BRFPLiveConfigurationPasscodeView.h"
#import <UIKit/UIImage+Private.h>
#include <dlfcn.h>

@implementation BRFPConfigurationListController {
	UIImageView *_backgroundImageView;
	UIVisualEffectView *_backgroundBlurView;
	BRFPLiveConfigurationPasscodeView *_lockScreenKeypad;
}

+ (NSString *)hb_specifierPlist {
	return @"Configuration";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.scrollEnabled = NO;

    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageWithContentsOfCPBitmapFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap" flags:kNilOptions];
    [self.table addSubview:_backgroundImageView];

    _backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.table addSubview:_backgroundBlurView];

    dlopen("/Library/MobileSubstrate/DynamicLibraries/FacesPro.dylib", RTLD_NOW);
    _lockScreenKeypad = [[%c(BRFPLiveConfigurationPasscodeView) alloc] initWithLightStyle:NO];
    _lockScreenKeypad.backgroundColor = [UIColor clearColor];
    _lockScreenKeypad.backgroundAlpha = 0.0;
    [self.table addSubview:_lockScreenKeypad];

    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = [_lockScreenKeypad currentAlphaValue];

    [slider addTarget:self action:@selector(setAlphaValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = slider;

    UIImage *ellipsisImage = [UIImage imageNamed:@"ell" inBundle:[NSBundle bundleForClass:self.class]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ellipsisImage style:UIBarButtonItemStylePlain target:_lockScreenKeypad action:@selector(ellipsisPressed:)];
}

- (void)setAlphaValue:(UISlider *)slider {
    [_lockScreenKeypad setAlphaValue:slider.value];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UIView *wrapperView = self.table.subviews[0];

    _backgroundImageView.frame = self.table.frame;
    _backgroundBlurView.frame = self.table.frame;
    _lockScreenKeypad.frame = CGRectMake(0, -43, self.table.frame.size.width, wrapperView.frame.size.height - 1);
}

@end
