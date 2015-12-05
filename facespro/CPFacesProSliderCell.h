#import <Preferences/Preferences.h>
#import <Preferences/PSSliderTableCell.h>
@interface CPFacesProSliderCell : PSSliderTableCell <UIAlertViewDelegate, UITextFieldDelegate> {
  CGFloat minimumValue;
  CGFloat maximumValue;
}
-(void)presentPopup;
@end