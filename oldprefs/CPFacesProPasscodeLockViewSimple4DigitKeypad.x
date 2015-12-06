#import "CPFacesProPreferences.h"
#import "CPFacesProPasscodeLockViewSimple4DigitKeypad.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <libcolorpicker.h>
#include <notify.h>
#import "UIImage+DominantColor.h"

#define CPFacesProLog(fmt, ...) HBLogDebug((@"[DEBUG] %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface CPFacesProPasscodeLockViewSimple4DigitKeypad () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) SBPasscodeNumberPadButton *selectedNumberPadButton;

@end

@implementation CPFacesProPasscodeLockViewSimple4DigitKeypad

- (void)passcodeLockNumberPad:(id)arg1 keyUp:(id)arg2 {
    [super passcodeLockNumberPad:arg1 keyUp:arg2];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];

    UIAlertController *optionsAlert = [UIAlertController alertControllerWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"FACES_PRO"] message:[NSString stringWithFormat:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"ALERT_CONTROLLER_TITLE"], ((SBPasscodeNumberPadButton *)arg2).stringCharacter] preferredStyle:UIAlertControllerStyleActionSheet];
    optionsAlert.popoverPresentationController.sourceView = arg2;

    [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"SET_BACKGROUND_TINT_INDIVIDUAL"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [optionsAlert dismissViewControllerAnimated:YES completion:nil];
        [self passcodeButtonShouldAddIndividualBackgroundTintColor:arg2];
    }]];

    if (defaults[[arg2 stringCharacter]][@"tint"]) {
        [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"REMOVE_INDIVIDUAL_BACKGROUND_TINT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self removeIndividualBackgroundColor:arg2];
        }]];
    }

    [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"SET_BACKGROUND_TINT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [optionsAlert dismissViewControllerAnimated:YES completion:nil];
        [self passcodeButtonShouldAddBackgroundTintColor:arg2];
    }]];

    if (defaults[@"tint"]) {
        [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"REMOVE_BACKGROUND_TINT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self removeAllButtonBackgroundColors:arg2];
        }]];
    }

    [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"TAKE_NEW_PHOTO"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self passcodeButtonShouldGetNewImage:arg2 takePhoto:YES];
    }]];

    [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"CHOOSE_PHOTO"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self passcodeButtonShouldGetNewImage:arg2 takePhoto:NO];
    }]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [arg2 stringCharacter]]]) {
        [optionsAlert addAction:[UIAlertAction actionWithTitle:@"Delete current photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self passcodeButtonShouldDeleteImage:arg2];
        }]];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {

        [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"SELECT_NEW_CONTACT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self passcodeButtonShouldAddContact:arg2];
        }]];

        if (defaults[[arg2 stringCharacter]][@"identifier"] && defaults[[arg2 stringCharacter]][@"record_id"] && defaults[[arg2 stringCharacter]][@"property_id"]) {

            NSString *recordIdentifier = defaults[[arg2 stringCharacter]][@"record_id"];
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(ABAddressBookCreate(), [recordIdentifier intValue]);

            ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSArray *phoneNumbers = (NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
            CFRelease(phoneNumberProperty);
            NSInteger phoneNumberIndex = [defaults[[arg2 stringCharacter]][@"identifier"] intValue];
            if (phoneNumbers.count >= phoneNumberIndex) {
                NSString *phoneNumber = phoneNumbers[phoneNumberIndex];
                if (phoneNumber) {
                    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

                    NSString *contactData;
                    if (firstName && lastName) {
                        contactData = [NSString stringWithFormat:@"%@ %@ — %@", firstName, lastName, phoneNumber];
                    } else if (firstName) {
                        contactData = [NSString stringWithFormat:@"%@ — %@", firstName, phoneNumber];
                    } else if (lastName) {
                        contactData = [NSString stringWithFormat:@"%@ — %@", lastName, phoneNumber];
                    } else {
                        contactData = phoneNumber;
                    }

                    [optionsAlert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Current contact: %@", contactData] style:UIAlertActionStyleDefault handler:nil]];

                    [firstName release];
                    [lastName release];
                    [phoneNumber release];

                    [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"REMOVE_CONTACT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self passcodeButtonShouldDeleteContact:arg2];
                    }]];
                }
                [phoneNumbers release];
            }
        }
    }

    [optionsAlert addAction:[UIAlertAction actionWithTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"CANCEL"] style:UIAlertActionStyleCancel handler:nil]];

    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:optionsAlert animated:YES completion:nil];
}

- (void)passcodeButtonShouldAddBackgroundTintColor:(SBPasscodeNumberPadButton *)button {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    UIColor *startColor = LCPParseColorString(defaults[@"tint"], @"#000000");
    PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
    [alert displayWithCompletion:^(UIColor *pickedColor){
        NSString *hexString = [UIColor hexFromColor:pickedColor];
        defaults[@"tint"] = hexString;
        [defaults writeToFile:tweakSettingsPath atomically:YES];
        notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");
        [UIView animateWithDuration:2 animations:^{
            [self setAllButtonsBackgroundColorToColor:pickedColor];
        }];
    }];
}

- (void)passcodeButtonShouldAddIndividualBackgroundTintColor:(SBPasscodeNumberPadButton *)button {
    _selectedNumberPadButton = button;
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    UIColor *startColor = LCPParseColorString(defaults[[button stringCharacter]][@"tint"], @"#000000");
    PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
    [alert displayWithCompletion:^(UIColor *pickedColor){
        NSString *hexString = [UIColor hexFromColor:pickedColor];
        if (!defaults[[button stringCharacter]]) {
            defaults[[button stringCharacter]] = [NSMutableDictionary dictionary];
        }
        defaults[[button stringCharacter]][@"tint"] = hexString;
        [defaults writeToFile:tweakSettingsPath atomically:YES];
        notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");
        [UIView animateWithDuration:2 animations:^{
            [self setButtonToBackgroundColor:pickedColor];
        }];
    }];
}

- (void)removeAllButtonBackgroundColors:(SBPasscodeNumberPadButton *)button {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    [defaults removeObjectForKey:@"tint"];
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    [UIView animateWithDuration:2 animations:^{
        [self setAllButtonsBackgroundColorToColor:[UIColor clearColor]];
    }];
    notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");
}

- (void)removeIndividualBackgroundColor:(SBPasscodeNumberPadButton *)button {
    _selectedNumberPadButton = button;
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    [defaults[[button stringCharacter]] removeObjectForKey:@"tint"];
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    [UIView animateWithDuration:2 animations:^{
        [self setButtonToBackgroundColor:[UIColor clearColor]];
    }];
    notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");
}

- (void)passcodeButtonShouldDeleteImage {
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [button stringCharacter]] error:nil];
    [UIView animateWithDuration:1.5 animations:^ {
        [self putImageOnSelectedButton:nil];
    }];
}

- (void)passcodeButtonShouldDeleteImage {
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [button stringCharacter]] error:nil];
    [UIView animateWithDuration:1.5 animations:^ {
        [self putImageOnSelectedButton:nil];
    }];
}

- (void)passcodeButtonShouldGetNewImage:(SBPasscodeNumberPadButton *)button takePhoto:(BOOL)takeNewPhoto {
    _selectedNumberPadButton = button;

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = takeNewPhoto ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;

    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)putImageOnSelectedButton:(UIImage *)image {
    TPRevealingRingView *ringView = _selectedNumberPadButton.revealingRingView;
    UIImageView *pictureImageView = (UIImageView *)[ringView viewWithTag:FACES_BUTTON_TAG];
    CGFloat imageAlpha = pictureImageView.alpha;
    UIColor *averageColor = [image dominantColor];

    [UIView animateWithDuration:2 animations:^{
        pictureImageView.alpha = 0.0;
        pictureImageView.image = image;
        pictureImageView.alpha = imageAlpha;
        pictureImageView.layer.borderColor = averageColor.CGColor ? : [UIColor clearColor].CGColor;
    }];
}

- (void)passcodeButtonShouldAddContact:(SBPasscodeNumberPadButton *)button {
    _selectedNumberPadButton = button;

    ABPeoplePickerNavigationController *contactPicker = [[ABPeoplePickerNavigationController alloc] init];
    contactPicker.displayedProperties = @[@(kABPersonPhoneProperty)];
    contactPicker.peoplePickerDelegate = self;

    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:contactPicker animated:YES completion:nil];
}

- (void)passcodeButtonShouldDeleteContact:(SBPasscodeNumberPadButton *)button {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    [defaults removeObjectForKey:[button stringCharacter]];
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");
}

- (void)setAllButtonsToAlpha:(UISlider *)slider {
    for (SBPasscodeNumberPadButton *button in self._numberPad.buttons) {
        if ([button isKindOfClass:objc_getClass("SBPasscodeNumberPadButton")]) {
            UIImageView *imageView = (UIImageView *)[button.revealingRingView viewWithTag:FACES_BUTTON_TAG];
            imageView.alpha = slider.value;
        }
    }
}

- (void)setAllButtonsBackgroundColorToColor:(UIColor *)color {
    for (SBPasscodeNumberPadButton *button in self._numberPad.buttons) {
        if ([button isKindOfClass:objc_getClass("SBPasscodeNumberPadButton")]) {
            UIView *colorView = [button.revealingRingView viewWithTag:FACES_COLOR_TAG];
            colorView.backgroundColor = color;
        }
    }
}

- (void)setButtonToBackgroundColor:(UIColor *)color {
    UIView *colorView = [_selectedNumberPadButton.revealingRingView viewWithTag:FACES_COLOR_TAG];
    colorView.backgroundColor = color;
}

#pragma mark image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%@.png", [_selectedNumberPadButton stringCharacter]];
    NSData *imageData = UIImagePNGRepresentation(picture);
    [imageData writeToFile:path atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self putImageOnSelectedButton:picture];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark contact picker delegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    NSDictionary *contactInformation = @{@"record_id": @(ABRecordGetRecordID(person)), @"property_id": @(property), @"identifier": @(identifier)};
    defaults[[_selectedNumberPadButton stringCharacter]] = contactInformation;
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    notify_post("com.cpdigitaldarkroom.benrosen.facespro/settingschanged");

    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
