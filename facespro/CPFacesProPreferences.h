#import <Preferences/Preferences.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "CPFacesProListController.h"
#import "CPFacesProLocalizer.h"
#import "CPFacesProSliderCell.h"
#import <UIKit/UIKit.h>
#import <substrate.h>

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1_2
#define kCFCoreFoundationVersionNumber_iOS_7_1_2 847.27
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_1_1
#define kCFCoreFoundationVersionNumber_iOS_8_1_1 1145.15
#endif

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CURRENT_INTERFACE_ORIENTATION iPad ? [[UIApplication sharedApplication] statusBarOrientation] : [[UIApplication sharedApplication] activeInterfaceOrientation]

#define iOS8 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_8_1_1

#define iOS7 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_7_1_2

#define kScreenHeight 				[[UIScreen mainScreen] bounds].size.height
#define kScreenWidth 				[[UIScreen mainScreen] bounds].size.width

@interface UIView (Constraint)
-(NSLayoutConstraint *)_constraintForIdentifier:(id)arg1 ;
@end

#define BACKGROUND_IMAGE_PATH               @"/var/mobile/Library/Faces/background.png"
#define MAIN_ICON_PATH               @"/Library/PreferenceBundles/FacesPro.bundle/FacesPro.png"
#define HEADER_ICON               @"/Library/PreferenceBundles/FacesPro.bundle/headerLogo.png"
#define FACES_BUNDLE	@"/Library/PreferenceBundles/FacesPro.bundle"
#define tweakSettingsPath @"/User/Library/Preferences/com.cpdigitaldarkroom.benrosen.facespro.plist"


#define MAIN_TINTCOLOR [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]
#define SWITCH_TINTCOLOR [UIColor colorWithRed:65/255.0f green:169/255.0f blue:214/255.0f alpha:1.0f]
#define LABEL_TINTCOLOR [UIColor colorWithRed:22/255.0f green:36/255.0f blue:51/255.0f alpha:1.0f]
#define NAVBACKGROUND_TINTCOLOR [UIColor colorWithRed:65/255.0f green:169/255.0f blue:214/255.0f alpha:1.0f]
#define FACES_BUTTON_TAG 19828
#define FACES_COLOR_TAG 19829

static NSString *const kFacesPreferencesDomain = @"com.cpdigitaldarkroom.benrosen.facespro";

#define floatPreference(key, var) do { NSNumber *obj = (NSNumber *)[[NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath] objectForKey:(key)]; \
        (var) = obj ? [obj floatValue] : 0.5; } while (0)

static NSString *const kFacesPreferencesImageOpacity = @"imageOpacity";


@interface SBWallpaperView : UIImageView
+ (id)_desktopImage; // iOS 3
- (id)initWithOrientation:(UIImageOrientation)orientation; // iOS 4
- (id)initWithOrientation:(UIImageOrientation)orientation variant:(NSInteger)variant; // iOS 5-6
@end

@interface SBFWallpaperView
@property (nonatomic, readonly) UIImage *wallpaperImage;
@end

@interface SBFStaticWallpaperView : SBFWallpaperView
- (UIImage *)_displayedImage;
@end

@interface SBWallpaperController
+ (id)sharedInstance;
@end

@interface SBUIPasscodeLockNumberPad 
@property (nonatomic,readonly) NSArray * buttons; 
@end

@interface SBUIPasscodeLockViewSimple4DigitKeypad : UIView
@property (nonatomic) float backgroundAlpha;
- (id)initWithLightStyle:(BOOL)arg1;
-(SBUIPasscodeLockNumberPad *)_numberPad;
- (void)passcodeLockNumberPad:(id)arg1 keyUp:(id)arg2;
@end

@interface SBLockScreenViewController : UIViewController
@end

@interface SBUIFourDigitPasscodeEntryField : UIView
@property (nonatomic) float backgroundAlpha;
-(id)initWithDefaultSizeAndLightStyle:(BOOL)arg1;
@end

@interface TPRevealingRingView : UIView
@property(retain, nonatomic) UIColor *colorOutsideRing;
@property(retain, nonatomic) UIColor *colorInsideRing;
@property (nonatomic, readonly) CGSize ringSize;
@end

@interface SBPasscodeNumberPadButton : UIView
@property(readonly, nonatomic) TPRevealingRingView *revealingRingView;
@property(retain, nonatomic) UIColor *color;
- (NSString *)stringCharacter;
- (int)character;
@end

@interface TPNumberPadButton : UIControl
@end

@interface TPPathView : UIView
- (void)setFillColor:(id)arg1;
@end