#import <SpringBoardUIServices/SBUIPasscodeLockViewSimpleFixedDigitKeypad.h>

@interface BRFPLiveConfigurationPasscodeView : SBUIPasscodeLockViewSimpleFixedDigitKeypad <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)setAlphaValue:(CGFloat)alpha;

- (CGFloat)currentAlphaValue;

@end
