#import <Foundation/NSDistributedNotificationCenter.h>
#import "CPFacesProConfigurationListController.h"
#import "CPFacesProImageConfigurationView.h"
#import "CPFacesProPreferences.h"
#import <objc/runtime.h>
#import <substrate.h>
#import "CPFacesProPasscodeLockViewSimple4DigitKeypad.h"
#import <UIKit/UITableView+Private.h>
#include <notify.h>

@interface CPFacesProConfigurationListController ()

@property (strong, nonatomic) CPFacesProPasscodeLockViewSimple4DigitKeypad *lockScreenKeypad;

@property (strong, nonatomic) UIVisualEffectView *backgroundBlurView;

@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

@implementation CPFacesProConfigurationListController

- (id)specifiers {
    [self setTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"CONFIGURATION"]];
    return _specifiers;
}

- (void)loadView {
    [super loadView];
    self.table.scrollEnabled = NO;

    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = [self currentAlphaValue];

    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventAllTouchEvents];
    self.navigationItem.titleView = slider;

    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = userLockscreenWallpaper();
    [self.table addSubview:_backgroundImageView];

    _backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.table addSubview:_backgroundBlurView];

    dlopen("/Library/MobileSubstrate/DynamicLibraries/AFacesPro.dylib", RTLD_NOW);
    _lockScreenKeypad = [[objc_getClass("CPFacesProPasscodeLockViewSimple4DigitKeypad") alloc] initWithLightStyle:NO];
    _lockScreenKeypad.backgroundColor = [UIColor clearColor];
    _lockScreenKeypad.backgroundAlpha = 0.0;
    [self.table addSubview:_lockScreenKeypad];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UIView *wrapperView = self.table.subviews[0];

    _backgroundImageView.frame = self.table.frame;
    _backgroundBlurView.frame = self.table.frame;
    _lockScreenKeypad.frame = CGRectMake(0, -43, self.table.frame.size.width, wrapperView.frame.size.height - 1);
}

- (void)sliderChanged:(UISlider *)slider {
    [_lockScreenKeypad setAllButtonsToAlpha:slider.value];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    defaults[@"alpha"] = @(slider.value);
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");
}

- (CGFloat)currentAlphaValue {
    NSDictionary *tweakSettings = [NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    return tweakSettings[@"alpha"] ? [tweakSettings[@"alpha"] floatValue] : 0.5;
}

@end