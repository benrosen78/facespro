#import <Preferences/Preferences.h>
@interface CPFacesProImageConfigurationView : UIView
@property (nonatomic, assign) UIImageView *blurredBackground;
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,assign) UILabel *randomLabel;
@property (nonatomic,readonly) NSArray *randomTexts;
@end