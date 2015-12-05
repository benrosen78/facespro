//
//  FacesPro.xm
//  Faces Pro
//  Add images to the passcode buttons.
//
//  Created by CP Digital Darkroom & Ben Rosen April 22nd 2015
//  Copyright (c) 2015, CP Digital Darkroom. All rights reserved.
//

#include <notify.h>
#include <spawn.h>
#include <unistd.h>
#import "FacesPro.h"
#import "FacesProSettingsManager.h"
#import <objc/runtime.h>
#import "UIImage+DominantColor.h"

%hook TPNumberPad

- (id)initWithButtons:(NSArray *)arg1 {
	%log;
	if (self == %orig && [[FacesProSettingsManager sharedManager] isEnabled]) {
		for (int i = 0; i < [arg1 count]; i++) {
			SBPasscodeNumberPadButton *numberButton = arg1[i];
			if (numberButton && [numberButton isKindOfClass:[objc_getClass("SBPasscodeNumberPadButton") class]] && [[numberButton class] instancesRespondToSelector:@selector(revealingRingView)]) {
				TPRevealingRingView *ringView = numberButton.revealingRingView;
				CGRect frameForButtons = CGRectMake(ringView.paddingOutsideRing.left, ringView.paddingOutsideRing.top, ringView.ringSize.width, ringView.ringSize.height);
				UIImage *imageForButton = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [numberButton stringCharacter]]];
				UIColor *averageColor = [imageForButton dominantColor];

				UIView *colorView = [[UIView alloc] init];
				colorView.frame = frameForButtons;
				colorView.tag = FACES_COLOR_TAG;
				colorView.alpha = 0.5;
				colorView.layer.cornerRadius = colorView.frame.size.height / 2;
				colorView.layer.masksToBounds = YES;
				colorView.backgroundColor = [[FacesProSettingsManager sharedManager] tintBackgroundColorForButtonString:[numberButton stringCharacter]];
				[ringView addSubview:colorView];
				[colorView release];

				UIImageView *imageView = [[UIImageView alloc] init];
				imageView.frame = frameForButtons;
				imageView.layer.cornerRadius = imageView.frame.size.height / 2;
				imageView.layer.borderWidth = 1.5;
				imageView.layer.borderColor = averageColor.CGColor ? : [UIColor clearColor].CGColor;
				imageView.alpha = [[FacesProSettingsManager sharedManager] alpha];
				imageView.tag = FACES_BUTTON_TAG;
				imageView.image = imageForButton;
				imageView.layer.masksToBounds = YES;
				[ringView addSubview:imageView];
				[imageView release];

				if (!i) {
					UILongPressGestureRecognizer *recognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(facesPro_longPressHeld:)] autorelease];
					[self addGestureRecognizer:recognizer];
				}
			}
		}
	}
	return self;
}

%new

- (void)facesPro_longPressHeld:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		for (UIView *subview in self.subviews) {
			if ([subview isKindOfClass:objc_getClass("SBPasscodeNumberPadButton")] && CGRectContainsPoint(subview.frame, [gestureRecognizer locationInView:self])) {
				NSString *phoneNumber = [[FacesProSettingsManager sharedManager] phoneNumberForButtonString:((SBPasscodeNumberPadButton *)subview).stringCharacter];
				if (phoneNumber && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]]];
				}
				[phoneNumber release];
			}
		}
	}
}

%end

// epicentre

%hook EPCDraggableRotaryNumberView

- (void)layoutSubviews {
	%orig;
	if (![self viewWithTag:FACES_COLOR_TAG] && ![self viewWithTag:FACES_BUTTON_TAG]) {
		UIImage *imageForButton = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", self.character]];
		UIColor *averageColor = [imageForButton dominantColor];

		UIView *colorView = [[UIView alloc] init];
		colorView.frame = self.bounds;
		colorView.tag = FACES_COLOR_TAG;
		colorView.alpha = 0.5;
		colorView.layer.cornerRadius = colorView.frame.size.height / 2;
		colorView.layer.masksToBounds = YES;
		colorView.backgroundColor = [[FacesProSettingsManager sharedManager] tintBackgroundColorForButtonString:self.character];
		[self addSubview:colorView];
		[colorView release];

		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.frame = self.bounds;
		imageView.layer.cornerRadius = imageView.frame.size.height / 2;
		imageView.layer.borderWidth = 1.5;
		imageView.layer.borderColor = averageColor.CGColor ? : [UIColor clearColor].CGColor;
		imageView.alpha = [[FacesProSettingsManager sharedManager] alpha];
		imageView.tag = FACES_BUTTON_TAG;
		imageView.image = imageForButton;
		imageView.layer.masksToBounds = YES;
		[self addSubview:imageView];
		[imageView release];

		UILongPressGestureRecognizer *recognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(facesPro_longPressHeld:)] autorelease];
		[self addGestureRecognizer:recognizer];

	}
}

%new

- (void)facesPro_longPressHeld:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		EPCDraggableRotaryNumberView *numberView = (EPCDraggableRotaryNumberView *)gestureRecognizer.view;
		NSString *phoneNumber = [[FacesProSettingsManager sharedManager] phoneNumberForButtonString:numberView.character];
		if (phoneNumber && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]]];
		}
		[phoneNumber release];
	}
}

%end

%ctor {
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Epicentre.dylib"]) {
		dlopen("/Library/MobileSubstrate/DynamicLibraries/Epicentre.dylib", RTLD_LAZY);
	}

	NSString *folderName = @"/var/mobile/Library/Faces/";
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderName]) {
    	[[NSFileManager defaultManager] createDirectoryAtPath:folderName withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
