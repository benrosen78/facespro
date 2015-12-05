#import "CPFacesProMakersListController.h"
#import "CPFacesProPreferences.h"

@implementation CPFacesProMakersListController

-(id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [super specifiersForPlistName:@"FacesProMakers"];
    }
    [self setTitle:[[CPFacesProLocalizer sharedLocalizer] localizedStringForKey:@"MAKERS"]];
    return _specifiers;
}

@end