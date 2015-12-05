#import "CPFacesProImageConfigurationView.h"
#import "CPFacesProPreferences.h"
#include <notify.h>

@implementation CPFacesProImageConfigurationView
@synthesize blurredBackground,headerLabel,subHeaderLabel,randomLabel;

- (id)init {

	   self = [super initWithFrame:CGRectZero];
	   
       if (self) {
            float kOpacity;
            NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.cpdigitaldarkroom.benrosen.facespro.plist"];
            if(prefs)
            {
                  kOpacity = ([prefs objectForKey:@"imageOpacity"] ? [[prefs objectForKey:@"imageOpacity"] floatValue] : 0.5);
            }

            UIImage *icon = [[UIImage alloc] initWithContentsOfFile:BACKGROUND_IMAGE_PATH];
       		self.blurredBackground = [[UIImageView alloc] initWithImage:icon];
            self.blurredBackground.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, kScreenHeight-60);
            [self addSubview:self.blurredBackground];

            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                  [blurEffectView setFrame:self.blurredBackground.bounds];
            [self addSubview:blurEffectView];

            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
            UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
            [vibrancyEffectView setFrame:self.blurredBackground.bounds];

            self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.headerLabel setNumberOfLines:1];
            [self.headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:iPad ? 52 : 44]];
            [self.headerLabel setText:@"Faces"];
            [self.headerLabel setBackgroundColor:[UIColor clearColor]];
            [self.headerLabel setTextColor:[UIColor grayColor]];
            [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
            [[vibrancyEffectView contentView] addSubview:self.headerLabel];
            [self.headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.04 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            self.subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.subHeaderLabel setNumberOfLines:1];
            [self.subHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:iPad ? 34 : 28]];
            [self.subHeaderLabel setText:@"Scroll Down For More Options"];
            [self.subHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [self.subHeaderLabel setTextColor:[UIColor grayColor]];
            [self.subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [[vibrancyEffectView contentView] addSubview:self.subHeaderLabel];
            [self.subHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.8 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            UIImage *revealingRingViewNormal = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/FacesPro.bundle"] pathForResource:@"revealingRingView" ofType:@"png"]];
            UIImage *revealingRingViewMosaic = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/FacesPro.bundle"] pathForResource:@"revealingRingViewMosaic" ofType:@"png"]];
            UIImage *revealingRingViewPressed = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/FacesPro.bundle"] pathForResource:@"revealingRingViewPressed" ofType:@"png"]];

            UIButton *numberButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton1.tag =1;
            numberButton1.layer.zPosition = 100;
            numberButton1.alpha = 1.0;
            numberButton1.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/3)-revealingRingViewNormal.size.width, 90, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton1 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton1 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton1 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton1.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton1];

            UIButton *numberButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton2.tag =2;
            numberButton2.layer.zPosition = 100;
            numberButton2.alpha = 1.0;
            numberButton2.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-revealingRingViewNormal.size.width/2, 90, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton2 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton2 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton2 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton2.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton2];

            UIButton *numberButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton3.tag =3;
            numberButton3.layer.zPosition = 100;
            numberButton3.alpha = 1.0;
            numberButton3.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width*0.66), 90, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton3 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton3 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton3 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton3.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton3];

            UIButton *numberButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton4.tag =4;
            numberButton4.layer.zPosition = 100;
            numberButton4.alpha = 1.0;
            numberButton4.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/3)-revealingRingViewNormal.size.width, 190, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton4 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton4 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton4 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton4.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton4];

            UIButton *numberButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton5.tag =5;
            numberButton5.layer.zPosition = 100;
            numberButton5.alpha = 1.0;
            numberButton5.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-revealingRingViewNormal.size.width/2, 190, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton5 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton5 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton5 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton5.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton5];

            UIButton *numberButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton6.tag =6;
            numberButton6.layer.zPosition = 100;
            numberButton6.alpha = 1.0;
            numberButton6.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width*0.66), 190, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton6 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton6 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton6 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton6.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton6];

            UIButton *numberButton7 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton7.tag =7;
            numberButton7.layer.zPosition = 100;
            numberButton7.alpha = 1.0;
            numberButton7.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/3)-revealingRingViewNormal.size.width, 290, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton7 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton7 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton7 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton7.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton7];

            UIButton *numberButton8 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton8.tag =8;
            numberButton8.layer.zPosition = 100;
            numberButton8.alpha = 1.0;
            numberButton8.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-revealingRingViewNormal.size.width/2, 290, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton8 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton8 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton8 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton8.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton8];

            UIButton *numberButton9 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton9.tag =9;
            numberButton9.layer.zPosition = 100;
            numberButton9.alpha = 1.0;
            numberButton9.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width*0.66), 290, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton9 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton9 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton9 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton9.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton9];

            UIButton *numberButton10 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton10.tag =10;
            numberButton10.layer.zPosition = 100;
            numberButton10.alpha = 1.0;
            numberButton10.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/3)-revealingRingViewNormal.size.width, 390, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton10 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton10 setImage:revealingRingViewMosaic forState:UIControlStateNormal];
            [numberButton10 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton10.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton10];

            UIButton *numberButton11 = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton11.tag = 11;
            numberButton11.layer.zPosition = 100;
            numberButton11.alpha = 1.0;
            numberButton11.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-revealingRingViewNormal.size.width/2, 390, revealingRingViewNormal.size.width, revealingRingViewNormal.size.height);
            [numberButton11 addTarget:self action:@selector(numberPadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [numberButton11 setImage:revealingRingViewNormal forState:UIControlStateNormal];
            [numberButton11 setImage:revealingRingViewPressed forState:(UIControlStateHighlighted | UIControlStateSelected)];
            numberButton11.contentMode = UIViewContentModeScaleToFill;
            [[vibrancyEffectView contentView] addSubview:numberButton11];

            [[blurEffectView contentView] addSubview:vibrancyEffectView];

            UIImageView *button1ImageView = [[UIImageView alloc] init];
            button1ImageView.alpha = kOpacity;
            button1ImageView.frame = CGRectMake(numberButton1.frame.origin.x, numberButton1.frame.origin.y, 80, 80);
            UIImage *imageToSet = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture1.png"]];
            [button1ImageView setImage:imageToSet];
            button1ImageView.layer.cornerRadius = button1ImageView.frame.size.height / 2;
            button1ImageView.layer.masksToBounds = YES;
            button1ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button1ImageView];

            UIImageView *button2ImageView = [[UIImageView alloc] init];
            button2ImageView.alpha = kOpacity;
            button2ImageView.frame = CGRectMake(numberButton2.frame.origin.x, numberButton2.frame.origin.y, 80, 80);
            UIImage *imageToSet2 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture2.png"]];
            [button2ImageView setImage:imageToSet2];
            button2ImageView.layer.cornerRadius = button2ImageView.frame.size.height / 2;
            button2ImageView.layer.masksToBounds = YES;
            button2ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button2ImageView];

            UIImageView *button3ImageView = [[UIImageView alloc] init];
            button3ImageView.alpha = kOpacity;
            button3ImageView.frame = CGRectMake(numberButton3.frame.origin.x, numberButton3.frame.origin.y, 80, 80);
            UIImage *imageToSet3 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture3.png"]];
            [button3ImageView setImage:imageToSet3];
            button3ImageView.layer.cornerRadius = button3ImageView.frame.size.height / 2;
            button3ImageView.layer.masksToBounds = YES;
            button3ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button3ImageView];

            UIImageView *button4ImageView = [[UIImageView alloc] init];
            button4ImageView.alpha = kOpacity;
            button4ImageView.frame = CGRectMake(numberButton4.frame.origin.x, numberButton4.frame.origin.y, 80, 80);
            UIImage *imageToSet4 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture4.png"]];
            [button4ImageView setImage:imageToSet4];
            button4ImageView.layer.cornerRadius = button4ImageView.frame.size.height / 2;
            button4ImageView.layer.masksToBounds = YES;
            button4ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button4ImageView];

            UIImageView *button5ImageView = [[UIImageView alloc] init];
            button5ImageView.alpha = kOpacity;
            button5ImageView.frame = CGRectMake(numberButton5.frame.origin.x, numberButton5.frame.origin.y, 80, 80);
            UIImage *imageToSet5 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture5.png"]];
            [button5ImageView setImage:imageToSet5];
            button5ImageView.layer.cornerRadius = button5ImageView.frame.size.height / 2;
            button5ImageView.layer.masksToBounds = YES;
            button5ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button5ImageView];

            UIImageView *button6ImageView = [[UIImageView alloc] init];
            button6ImageView.alpha = kOpacity;
            button6ImageView.frame = CGRectMake(numberButton6.frame.origin.x, numberButton6.frame.origin.y, 80, 80);
            UIImage *imageToSet6 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture6.png"]];
            [button6ImageView setImage:imageToSet6];
            button6ImageView.layer.cornerRadius = button6ImageView.frame.size.height / 2;
            button6ImageView.layer.masksToBounds = YES;
            button6ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button6ImageView];

            UIImageView *button7ImageView = [[UIImageView alloc] init];
            button7ImageView.alpha = kOpacity;
            button7ImageView.frame = CGRectMake(numberButton7.frame.origin.x, numberButton7.frame.origin.y, 80, 80);
            UIImage *imageToSet7 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture7.png"]];
            [button7ImageView setImage:imageToSet7];
            button7ImageView.layer.cornerRadius = button7ImageView.frame.size.height / 2;
            button7ImageView.layer.masksToBounds = YES;
            button7ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button7ImageView];

            UIImageView *button8ImageView = [[UIImageView alloc] init];
            button8ImageView.alpha = kOpacity;
            button8ImageView.frame = CGRectMake(numberButton8.frame.origin.x, numberButton8.frame.origin.y, 80, 80);
            UIImage *imageToSet8 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture8.png"]];
            [button8ImageView setImage:imageToSet8];
            button8ImageView.layer.cornerRadius = button8ImageView.frame.size.height / 2;
            button8ImageView.layer.masksToBounds = YES;
            button8ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button8ImageView];

            UIImageView *button9ImageView = [[UIImageView alloc] init];
            button9ImageView.alpha = kOpacity;
            button9ImageView.frame = CGRectMake(numberButton9.frame.origin.x, numberButton9.frame.origin.y, 80, 80);
            UIImage *imageToSet9 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture9.png"]];
            [button9ImageView setImage:imageToSet9];
            button9ImageView.layer.cornerRadius = button9ImageView.frame.size.height / 2;
            button9ImageView.layer.masksToBounds = YES;
            button9ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button9ImageView];

            UIImageView *button11ImageView = [[UIImageView alloc] init];
            button11ImageView.alpha = kOpacity;
            button11ImageView.frame = CGRectMake(numberButton11.frame.origin.x, numberButton11.frame.origin.y, 80, 80);
            UIImage *imageToSet10 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture11.png"]];
            [button11ImageView setImage:imageToSet10];
            button11ImageView.layer.cornerRadius = button11ImageView.frame.size.height / 2;
            button11ImageView.layer.masksToBounds = YES;
            button11ImageView.layer.borderWidth = 0;
            [blurEffectView addSubview:button11ImageView];
 

    }

    return self;
}

- (void)numberPadButtonTapped:(id)sender
{
      NSInteger switchID = ((UIControl *) sender).tag;
      NSString *integerAsString = [@(switchID) stringValue];
      NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
      [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath]];
      [defaults setObject:integerAsString forKey:@"lastSelectedImage"];
      [defaults writeToFile:tweakSettingsPath atomically:YES];
      notify_post("com.cpdigitaldarkroom.benrosen.facespro/imagechanged");
}

@end