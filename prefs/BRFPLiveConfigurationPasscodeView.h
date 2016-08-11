#import <SpringBoardUIServices/SBUIPasscodeLockViewSimpleFixedDigitKeypad.h>
#import <ContactsUI/CNContactPickerViewController.h>

@interface BRFPLiveConfigurationPasscodeView : SBUIPasscodeLockViewSimpleFixedDigitKeypad <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CNContactPickerDelegate>

- (instancetype)initWithLightStyle:(BOOL)lightStyle;

- (void)setAlphaValue:(CGFloat)alpha;

- (CGFloat)currentAlphaValue;

@end
