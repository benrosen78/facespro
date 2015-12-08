#import <SpringBoardUIServices/SBUIPasscodeLockViewSimpleFixedDigitKeypad.h>
#import <ContactsUI/CNContactPickerViewController.h>

@interface BRFPLiveConfigurationPasscodeView : SBUIPasscodeLockViewSimpleFixedDigitKeypad <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CNContactPickerDelegate>

- (void)setAlphaValue:(CGFloat)alpha;

- (CGFloat)currentAlphaValue;

@end
