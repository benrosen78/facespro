#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define FACES_BUTTON_TAG 19828
#define FACES_COLOR_TAG 19829

@interface SpringBoard : NSObject

+ (instancetype)sharedApplication;
- (void)_relaunchSpringBoardNow;

@end

@interface SBUIPasscodeLockNumberPad : UIView

+ (id)_buttonForCharacter:(int)checker;

@end

@interface UIImage (Private)

+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;

@end

@interface TPRevealingRingView : UIView

@property(retain, nonatomic) UIColor *colorOutsideRing;
@property(retain, nonatomic) UIColor *colorInsideRing;
@property (nonatomic, readonly) struct UIEdgeInsets paddingOutsideRing;
@property (nonatomic) float defaultRingStrokeWidth;
@property (nonatomic, readonly) CGSize ringSize;

@end

@interface SBPasscodeNumberPadButton : UIView
@property(readonly, nonatomic) TPRevealingRingView *revealingRingView;
@property(retain, nonatomic) UIColor *color;
- (NSString *)stringCharacter;
+ (CGSize)defaultSize;
- (int)character;
@end

@interface TPNumberPadButton : UIControl

@end

@interface TPPathView : UIView

- (void)setFillColor:(id)arg1;

@end

@interface SBWallpaperView : UIImageView
+ (id)_desktopImage; // iOS 3
- (id)initWithOrientation:(UIImageOrientation)orientation; // iOS 4
- (id)initWithOrientation:(UIImageOrientation)orientation variant:(NSInteger)variant; // iOS 5-6
@end

@interface SBFWallpaperView
@property (nonatomic, readonly) UIImage *wallpaperImage;
@end

@interface SBFStaticWallpaperView : SBFWallpaperView
- (UIImage *)wallpaperImage;
@end

@interface TPNumberPad : UIView
@end
 
@interface SBWallpaperController : NSObject
+ (id)sharedInstance;
- (SBFStaticWallpaperView *)_wallpaperViewForVariant:(NSInteger)variant;
@end
@interface EPCDraggableRotaryNumberView : UIView
@property (nonatomic, retain, readonly) NSString* character;
@end
@interface EPCRingView : NSObject
@end