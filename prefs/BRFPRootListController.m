#include "BRFPRootListController.h"
#import "../UIImage+AverageColor.h"
#import <MobileGestalt/MobileGestalt.h>
#import <UIKit/UIImage+Private.h>

#define LOCALIZE(key, table, comment) NSLocalizedStringFromTableInBundle(key, table ?: @"Localizable", [NSBundle bundleForClass:self.class], comment)

@interface BRFPRootListController ()
@end

@implementation BRFPRootListController

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

+ (NSString *)hb_shareText {
	return @"#FacesPro by @benr9500 and @cpdigdarkroom lets me add images to my passcode buttons, hold to call, and much more! Available now on @BigBoss!";
}

+ (NSString *)hb_shareURL {
	return @"https://benrosen.me";
}

+ (UIColor *)hb_tintColor {
    UIImage *wallpaper = [UIImage imageWithContentsOfCPBitmapFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap" flags:kNilOptions];
	return [wallpaper facesPro_averageColor];
}

+ (BOOL)hb_invertedNavigationBar {
	return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *headerLogo = [UIImage imageNamed:@"facesHeaderLogo" inBundle:[NSBundle bundleForClass:self.class]];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:headerLogo] autorelease];
    self.navigationItem.titleView.alpha = 0.0;

    [self performSelector:@selector(animateIconAlpha) withObject:nil afterDelay:0.5];
}

- (void)animateIconAlpha {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationItem.titleView.alpha = 1;
    } completion:nil];
}

- (void)sendSupportEmail {
    MFMailComposeViewController *emailCP = [[MFMailComposeViewController alloc] init];
    [emailCP setSubject:@"Faces FacesPro Support"];
    [emailCP setToRecipients:[NSArray arrayWithObjects:@"Quantum Tweak <support@quantumtweaks.com>", nil]];

    NSString *product = nil, *version = nil, *build = nil;


        product = (NSString *)MGCopyAnswer(kMGProductType);
        version = (NSString *)MGCopyAnswer(kMGProductVersion);
        build = (NSString *)MGCopyAnswer(kMGBuildVersion);

    [emailCP setMessageBody:[NSString stringWithFormat:@"\n\nCurrent Device: %@, iOS %@ (%@)", product, version, build] isHTML:NO];

    [emailCP addAttachmentData:[NSData dataWithContentsOfFile:@"/var/mobile//Library/Preferences/me.benrosen.facespro.plist"] mimeType:@"application/xml" fileName:@"FacesProPrefs.plist"];
    system("/usr/bin/dpkg -l >/tmp/dpkgl.log");
    [emailCP addAttachmentData:[NSData dataWithContentsOfFile:@"/tmp/dpkgl.log"] mimeType:@"text/plain" fileName:@"dpkgl.txt"];
    [self.navigationController presentViewController:emailCP animated:YES completion:nil];
    emailCP.mailComposeDelegate = self;
    [emailCP release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end
