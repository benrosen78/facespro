#import "BRFPLiveConfigurationPasscodeView.h"
#import <SpringBoardUIServices/SBUIPasscodeLockNumberPad.h>
#import <SpringBoardUIServices/SBPasscodeNumberPadButton.h>

#define FACES_BUTTON_TAG 19828
#define FACES_COLOR_TAG 19829

@implementation BRFPLiveConfigurationPasscodeView {
	SBPasscodeNumberPadButton *_selectedButton;
}

#pragma mark BRFPLiveConfigurationPasscodeView

- (void)passcodeLockNumberPad:(SBUIPasscodeLockNumberPad *)numberPad keyUp:(SBPasscodeNumberPadButton *)passcodeButton {
	_selectedButton = passcodeButton;

	UIAlertController *optionsAlert = [UIAlertController alertControllerWithTitle:@"Faces Pro" message:[NSString stringWithFormat:@"You selected button %@. What would you like to do to this button?", passcodeButton.stringCharacter] preferredStyle:UIAlertControllerStyleActionSheet];
	optionsAlert.popoverPresentationController.sourceView = passcodeButton;

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Take a new Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self setNewImageWithNewPhoto:YES];
	}]];

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Choose an Existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self setNewImageWithNewPhoto:NO];
	}]];

	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [passcodeButton stringCharacter]]]) {
		[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Delete current photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			//[self passcodeButtonShouldDeleteImage:arg2];
		}]];
	}

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

	[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:optionsAlert animated:YES completion:nil];

	[optionsAlert release];
}

#pragma mark image modification

- (void)setNewImageWithNewPhoto:(BOOL)newPhoto {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = newPhoto ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.allowsEditing = YES;
	imagePicker.delegate = self;

	[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)putImageOnSelectedButton:(UIImage *)image {
    TPRevealingRingView *ringView = _selectedButton.revealingRingView;
    UIImageView *pictureImageView = (UIImageView *)[ringView viewWithTag:FACES_BUTTON_TAG];
    CGFloat imageAlpha = pictureImageView.alpha;
    //UIColor *averageColor = [image dominantColor];

    [UIView animateWithDuration:2 animations:^{
        pictureImageView.alpha = 0.0;
        pictureImageView.image = image;
        pictureImageView.alpha = imageAlpha;
       // pictureImageView.layer.borderColor = averageColor.CGColor ? : [UIColor clearColor].CGColor;
    }];
}

#pragma mark image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [_selectedButton stringCharacter]];
    NSData *imageData = UIImagePNGRepresentation(picture);
    [imageData writeToFile:path atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
    	[self putImageOnSelectedButton:picture];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
