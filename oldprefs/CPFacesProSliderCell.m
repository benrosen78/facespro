#import "CPFacesProSliderCell.h"
#import "CPFacesProPreferences.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSRootController.h>

@implementation CPFacesProSliderCell
-(id) initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arg2 specifier:specifier];
  if (self) {
    UISlider *slider = (UISlider *)[self control];
    [slider addTarget:specifier.target action:@selector(sliderMoved:) forControlEvents:UIControlEventAllTouchEvents];
    [slider setMinimumTrackTintColor:SWITCH_TINTCOLOR]; //change the slider color
    [slider setMaximumTrackTintColor:LABEL_TINTCOLOR];
    CGRect frame = [self frame];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(frame.size.width-50,0,50,frame.size.height);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentPopup) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
  }
  return self;
}

-(void) presentPopup {
    NSString * name = self.specifier.name;
  maximumValue = [[self.specifier propertyForKey:@"max"] floatValue];
  minimumValue = [[self.specifier propertyForKey:@"min"] floatValue];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name
                                                  message:[NSString stringWithFormat:@"Please enter a value between %i and %i.", (int)minimumValue, (int)maximumValue]
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Enter"
                        , nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  alert.tag = 342879;
  [alert show];
  [[alert textFieldAtIndex:0] setDelegate:self];
  [[alert textFieldAtIndex:0] resignFirstResponder];
  [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
  [[alert textFieldAtIndex:0] becomeFirstResponder];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 342879 && buttonIndex == 1) {
    CGFloat value = [[alertView textFieldAtIndex:0].text floatValue];
    if(value <= maximumValue && value >= minimumValue) {
     /* [PSRootController setPreferenceValue:[NSNumber numberWithInt:value] specifier:self.specifier];
      [[NSUserDefaults standardUserDefaults] synchronize];
      UITableView * table = [self _tableView];
      PSListController* currentController = (PSListController*)table.delegate;
      [currentController reloadSpecifier:self.specifier];*/
    }
    else {

      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"Ensure you entered a valid value."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil
                            , nil];
      alert.tag = 85230234;
      [alert show];
    }
  }
  else if(alertView.tag == 85230234)
    [self presentPopup];
}

@end
