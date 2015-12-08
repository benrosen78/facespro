#import "BRFPLiveConfigurationPasscodeView.h"
#import <SpringBoardUIServices/SBUIPasscodeLockNumberPad.h>
#import <SpringBoardUIServices/SBPasscodeNumberPadButton.h>
#import <Cephei/HBPreferences.h>
#import <libcolorpicker.h>
#import <Preferences/PreferencesAppController.h>
#import <PreferencesUI/PSUIPrefsRootController.h>
#include <notify.h>
#import "UIImage+AverageColor.h"

#define FACES_BUTTON_TAG 19828
#define FACES_COLOR_TAG 19829

@implementation BRFPLiveConfigurationPasscodeView {
	SBPasscodeNumberPadButton *_selectedButton;
	HBPreferences *_preferences;
}

#pragma mark - BRFPLiveConfigurationPasscodeView

- (instancetype)initWithLightStyle:(BOOL)lightStyle {
	if (self = [super initWithLightStyle:lightStyle]) {
		_preferences = [[HBPreferences alloc] initWithIdentifier:@"me.benrosen.facespro"];

		[self updateToShowHideButtonState];
	}
	return self;
}

- (void)passcodeLockNumberPad:(SBUIPasscodeLockNumberPad *)numberPad keyUp:(SBPasscodeNumberPadButton *)passcodeButton {
	_selectedButton = passcodeButton;
	NSString *buttonKey = [@"Button-" stringByAppendingString:[_selectedButton stringCharacter]];

	UIAlertController *optionsAlert = [UIAlertController alertControllerWithTitle:@"Faces Pro" message:[NSString stringWithFormat:@"You selected button %@.%@ What would you like to do to this button?", passcodeButton.stringCharacter, [self stringForCurrentContactState]] preferredStyle:UIAlertControllerStyleActionSheet];
	optionsAlert.popoverPresentationController.sourceView = passcodeButton;

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Set an individual background tint color" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[optionsAlert dismissViewControllerAnimated:YES completion:nil];
		[self setIndividualButtonTint];
	}]];

	if (_preferences[buttonKey][@"Tint"]) {
		[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Remove individual background tint color" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[optionsAlert dismissViewControllerAnimated:YES completion:nil];
			[self removeIndividualButtonTint];
		}]];
	}

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Take a new Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self setNewImageWithNewPhoto:YES];
	}]];

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Choose an Existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self setNewImageWithNewPhoto:NO];
	}]];

	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [passcodeButton stringCharacter]]]) {
		[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Delete current photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self passcodeButtonShouldDeleteImage];
		}]];
	}

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
		[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Select a new contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self showContactPicker];
		}]];
	}

	if (_preferences[buttonKey][@"ContactProperty"]) {
		[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Remove contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self removeCurrentContact];
		}]];
	}

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

	[((PreferencesAppController *)[UIApplication sharedApplication]).rootController presentViewController:optionsAlert animated:YES completion:nil];
}

#pragma mark - ellipsis

- (void)ellipsisPressed:(UIBarButtonItem *)item {
	NSString *tint = _preferences[@"Tint"];
	UIAlertController *optionsAlert = [UIAlertController alertControllerWithTitle:@"Faces Pro" message:@"What you like to do to all of the buttons?" preferredStyle:UIAlertControllerStyleActionSheet];

	[optionsAlert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ passcode numbers and letters", [_preferences[@"HidePasscodeButtons"] boolValue] ? @"Show" : @"Hide"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		_preferences[@"HidePasscodeButtons"] = @(![_preferences[@"HidePasscodeButtons"] boolValue]);
		notify_post("me.benrosen.facespro/ReloadPrefs");
		[self updateToShowHideButtonState];
	}]];

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Set a background tint color images" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		UIColor *startColor = LCPParseColorString(tint, @"#000000");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^(UIColor *pickedColor){
			[optionsAlert release];
			NSString *hexString = [UIColor hexFromColor:pickedColor];
			_preferences[@"Tint"] = hexString;

			[self setAllButtonsBackgroundColorToColor:pickedColor];
			notify_post("me.benrosen.facespro/ReloadPrefs");
		}];
	}]];

	if (tint) {
		[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Remove background tint color for images" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[_preferences removeObjectForKey:@"Tint"];
			[UIView animateWithDuration:2 animations:^{
				[self setAllButtonsBackgroundColorToColor:[UIColor clearColor]];
				notify_post("me.benrosen.facespro/ReloadPrefs");
			}];
		}]];
	}

	[optionsAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

	[((PreferencesAppController *)[UIApplication sharedApplication]).rootController presentViewController:optionsAlert animated:YES completion:nil];
}

#pragma mark - alpha getters/setters

- (void)setAlphaValue:(CGFloat)alpha {
	for (SBPasscodeNumberPadButton *button in self._numberPad.buttons) {
		if ([button isKindOfClass:%c(SBPasscodeNumberPadButton)]) {
			UIImageView *imageView = (UIImageView *)[button.revealingRingView viewWithTag:FACES_BUTTON_TAG];
			imageView.alpha = alpha;
		}
	}
	_preferences[@"Alpha"] = @(alpha);
	notify_post("me.benrosen.facespro/ReloadPrefs");
}

- (CGFloat)currentAlphaValue {
	return [_preferences[@"Alpha"] floatValue];
}

#pragma mark - hide/show button numbers and letters

- (void)updateToShowHideButtonState {
	for (SBPasscodeNumberPadButton *button in self._numberPad.buttons) {
		if ([button isKindOfClass:%c(SBPasscodeNumberPadButton)]) {
			button.glyphLayer.contents = [(__bridge id)[SBPasscodeNumberPadButton imageForCharacter:button.character highlighted:NO whiteVersion:YES].CGImage retain];
			button.highlightedGlyphLayer.contents = [(__bridge id)[SBPasscodeNumberPadButton imageForCharacter:button.character highlighted:YES whiteVersion:YES].CGImage retain];
		}
	}
}

#pragma mark - color modification

- (void)setIndividualButtonTint {
	NSString *buttonKey = [@"Button-" stringByAppendingString:[_selectedButton stringCharacter]];
	NSString *tint = _preferences[buttonKey][@"Tint"];
	UIColor *startColor = LCPParseColorString(tint, @"#000000");
	PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
	[alert displayWithCompletion:^(UIColor *pickedColor){
		NSString *hexString = [UIColor hexFromColor:pickedColor];
		NSMutableDictionary *selectedNumberCopy = [_preferences[buttonKey] mutableCopy] ?: [NSMutableDictionary dictionary];
		selectedNumberCopy[@"Tint"] = hexString;
		_preferences[buttonKey] = selectedNumberCopy;
		[selectedNumberCopy release];
		notify_post("me.benrosen.facespro/ReloadPrefs");
		[UIView animateWithDuration:2 animations:^{
			[self setButton:_selectedButton toIndividualColor:pickedColor];
		}];
	}];
}

- (void)removeIndividualButtonTint {
	NSString *buttonKey = [@"Button-" stringByAppendingString:[_selectedButton stringCharacter]];
	NSMutableDictionary *selectedNumberCopy = [_preferences[buttonKey] mutableCopy];
	[selectedNumberCopy removeObjectForKey:@"Tint"];
	_preferences[buttonKey] = selectedNumberCopy;
	[selectedNumberCopy release];

	[UIView animateWithDuration:2 animations:^{
		if (_preferences[@"Tint"]) {
			NSString *tint = _preferences[@"Tint"];
			UIColor *startColor = LCPParseColorString(tint, @"#000000");
			[self setButton:_selectedButton toIndividualColor:startColor];
			return;
		}
		[self setButton:_selectedButton toIndividualColor:[UIColor clearColor]];
	}];
	notify_post("me.benrosen.facespro/ReloadPrefs");
}

- (void)setAllButtonsBackgroundColorToColor:(UIColor *)color {
	[UIView animateWithDuration:2 animations:^{
		for (SBPasscodeNumberPadButton *button in self._numberPad.buttons) {
			NSString *buttonKey = [@"Button-" stringByAppendingString:[button stringCharacter]];
			if ([button isKindOfClass:%c(SBPasscodeNumberPadButton)] && !_preferences[buttonKey][@"Tint"]) {
				[self setButton:button toIndividualColor:color];
			}
		}
	}];
}

- (void)setButton:(SBPasscodeNumberPadButton *)button toIndividualColor:(UIColor *)color {
	UIView *colorView = [button viewWithTag:FACES_COLOR_TAG];
	colorView.backgroundColor = color;
}

#pragma mark - image modification

- (void)setNewImageWithNewPhoto:(BOOL)newPhoto {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = newPhoto ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.allowsEditing = YES;
	imagePicker.delegate = self;

	[((PreferencesAppController *)[UIApplication sharedApplication]).rootController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)passcodeButtonShouldDeleteImage {
	[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [_selectedButton stringCharacter]] error:nil];
	[self putImageOnSelectedButton:[[UIImage alloc] init]];
}

- (void)putImageOnSelectedButton:(UIImage *)image {
	TPRevealingRingView *ringView = _selectedButton.revealingRingView;
	UIImageView *pictureImageView = (UIImageView *)[ringView viewWithTag:FACES_BUTTON_TAG];
	CGFloat imageAlpha = pictureImageView.alpha;
	UIColor *averageColor = [image facesPro_averageColor];

	[UIView animateWithDuration:2 animations:^{
		pictureImageView.alpha = 0.0;
		pictureImageView.image = image;
		pictureImageView.alpha = imageAlpha;
		pictureImageView.layer.borderColor = averageColor.CGColor ? : [UIColor clearColor].CGColor;
	}];
}

#pragma mark - image picker controller delegate

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

#pragma mark - contact selecting

- (NSString *)stringForCurrentContactState {
	NSString *buttonKey = [@"Button-" stringByAppendingString:[_selectedButton stringCharacter]];
	if (!_preferences[buttonKey][@"ContactProperty"]) {
		return @"";

	}
	CNContactProperty *property = [NSKeyedUnarchiver unarchiveObjectWithData:_preferences[buttonKey][@"ContactProperty"]];
	if (!property) {
		return @"";
	}
	NSString *phoneNumber = ((CNPhoneNumber *)property.value).stringValue;
	if (!phoneNumber) {
		return @"";
	}
	NSString *name = property.contact.givenName;
	if (!name) {
		return @"";
	}
	return [NSString stringWithFormat:@" The contact is currently set to %@, and the current phone number is %@.", name, phoneNumber];
}

- (void)showContactPicker {
	CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
	contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
	contactPicker.delegate = self;
	contactPicker.predicateForSelectionOfContact = [NSPredicate predicateWithValue:NO];
	contactPicker.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:YES];

	[((PreferencesAppController *)[UIApplication sharedApplication]).rootController presentViewController:contactPicker animated:YES completion:nil];
}

- (void)removeCurrentContact {
	NSString *buttonKey = [@"Button-" stringByAppendingString:[_selectedButton stringCharacter]];
	NSMutableDictionary *selectedNumberCopy = [_preferences[buttonKey] mutableCopy];
	[selectedNumberCopy removeObjectForKey:@"ContactProperty"];
	_preferences[buttonKey] = selectedNumberCopy;
	[selectedNumberCopy release];
	notify_post("me.benrosen.facespro/ReloadPrefs");
}

#pragma mark - contact picker controller delegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
	[picker dismissViewControllerAnimated:YES completion:nil];

	NSString *buttonKey = [@"Button-" stringByAppendingString:[_selectedButton stringCharacter]];
	NSMutableDictionary *selectedNumberCopy = [_preferences[buttonKey] mutableCopy] ?: [NSMutableDictionary dictionary];
	selectedNumberCopy[@"ContactProperty"] = [NSKeyedArchiver archivedDataWithRootObject:contactProperty];
	_preferences[buttonKey] = selectedNumberCopy;
	[selectedNumberCopy release];
}

#pragma mark - memory management

- (void)dealloc {
	[super dealloc];

	[_selectedButton release];
}

@end
