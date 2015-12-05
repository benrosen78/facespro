#import "CPFacesProListController.h"

#define localized(a, b) [[self bundle] localizedStringForKey:(a) value:(b) table:nil]

@interface CPFacesProConfigurationListController : CPFacesProListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end