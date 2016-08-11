#import "BRFPPreferencesManager.h"
#import "UIImage+AverageColor.h"
#import <SpringBoardUIServices/SBPasscodeNumberPadButton.h>
#import <TelephonyUI/TPRevealingRingView.h>
#import <TelephonyUI/TPNumberPad.h>

#define FACES_BUTTON_TAG 19828
#define FACES_COLOR_TAG 19829

@interface SBNumberPadWithDelegate : TPNumberPad
@end

%hook TPNumberPad

- (id)initWithButtons:(NSArray *)passcodeButtons {
	if ((self = %orig) && [BRFPPreferencesManager sharedInstance].enabled) {
		for (SBPasscodeNumberPadButton *numberButton in passcodeButtons) {
			if (numberButton && [numberButton isKindOfClass:%c(SBPasscodeNumberPadButton)]) {
				TPRevealingRingView *ringView = numberButton.revealingRingView;
				CGRect frameForButtons = CGRectMake(ringView.paddingOutsideRing.left, ringView.paddingOutsideRing.top, ringView.ringSize.width, ringView.ringSize.height);

				UIImage *imageForButton = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [numberButton stringCharacter]]];

				UIView *colorView = [[UIView alloc] init];
				colorView.frame = frameForButtons;
				colorView.tag = FACES_COLOR_TAG;
				colorView.alpha = 0.5;
				colorView.layer.cornerRadius = colorView.frame.size.height / 2;
				colorView.layer.masksToBounds = YES;
				colorView.backgroundColor = [[BRFPPreferencesManager sharedInstance] colorForPasscodeButtonString:[numberButton stringCharacter]];
				[ringView addSubview:colorView];
				[colorView release];

				UIImageView *imageView = [[UIImageView alloc] init];
				imageView.frame = frameForButtons;
				imageView.layer.cornerRadius = imageView.frame.size.height / 2;
				imageView.alpha = [BRFPPreferencesManager sharedInstance].alpha;

				UIColor *averageColor = [imageForButton facesPro_averageColor];
				imageView.layer.borderColor = averageColor.CGColor ? : [UIColor clearColor].CGColor;
				imageView.layer.borderWidth = 1.5f;
				imageView.tag = FACES_BUTTON_TAG;
				imageView.image = imageForButton;
				imageView.layer.masksToBounds = YES;
				[ringView addSubview:imageView];
				[imageView release];
			}
		}
	}
	return self;
}

%end

%hook SBNumberPadWithDelegate
- (id)initWithButtons:(NSArray *)button {

	if((self == %orig) && [BRFPPreferencesManager sharedInstance].enabled) {
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
			UILongPressGestureRecognizer *recognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] autorelease];
			[self addGestureRecognizer:recognizer];
		}
	}
	return self;
}

%new
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		for (UIView *subview in self.subviews) {
			if ([subview isKindOfClass:NSClassFromString(@"SBPasscodeNumberPadButton")] && CGRectContainsPoint(subview.frame, [gestureRecognizer locationInView:self])) {

				NSString *phoneNumber = [[BRFPPreferencesManager sharedInstance] phoneNumberForPasscodeButtonString:((SBPasscodeNumberPadButton *)subview).stringCharacter];
				HBLogInfo(@"Phone Number: %@", phoneNumber);
				if (phoneNumber) {
					HBLogInfo(@"Handle Calling");
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]]];
				}
			}
		}
	}
}
%end

%hook SBPasscodeNumberPadButton

+ (UIImage *)imageForCharacter:(unsigned)character highlighted:(BOOL)highlighted whiteVersion:(BOOL)whiteVersion {
	return [BRFPPreferencesManager sharedInstance].hidePasscodeNumbersAndLetters ? nil : %orig;
}

+ (UIImage *)imageForCharacter:(unsigned)character highlighted:(BOOL)highlighted {
    return [BRFPPreferencesManager sharedInstance].hidePasscodeNumbersAndLetters ? nil : %orig;
}

+ (UIImage *)imageForCharacter:(unsigned)character {
	return [BRFPPreferencesManager sharedInstance].hidePasscodeNumbersAndLetters ? nil : %orig;
}

%end

%ctor {
	NSString *folderName = @"/var/mobile/Library/Faces/";
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderName]) {
    	[[NSFileManager defaultManager] createDirectoryAtPath:folderName withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
