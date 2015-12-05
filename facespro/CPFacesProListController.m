#import "CPFacesProListController.h"
#import "CPFacesProPreferences.h"
#import "UIImage+DominantColor.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "PlsNoPiracy.h"

static BOOL isEnabled = YES;
static BOOL showAd = YES;
static BOOL hasDeterminedState = NO;

@interface CPFacesProListController ()

@property (strong, nonatomic) GADBannerView *bannerView;

@end

@implementation CPFacesProListController

UIImage *userLockscreenWallpaper() {
    NSData *lockscreenWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
    if(lockscreenWallpaperData) {
        CFDataRef lockscreenWallpaperDataRef = CFDataCreate(NULL, lockscreenWallpaperData.bytes, lockscreenWallpaperData.length);
        CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);
        CFArrayRef wallpaperArray = CPBitmapCreateImagesFromData(lockscreenWallpaperDataRef, NULL, 1, NULL);
        CFRelease(lockscreenWallpaperDataRef);
        if(CFArrayGetCount(wallpaperArray) > 0) {
            CGImageRef lockscreenWallpaperRef = (CGImageRef)CFArrayGetValueAtIndex(wallpaperArray, 0);
            return [UIImage imageWithCGImage:lockscreenWallpaperRef];
        }
        CFRelease(wallpaperArray);
    }
    return [UIImage new];
}

- (id)specifiersForPlistName:(NSString *)plistName {
    NSArray *specs = [[self loadSpecifiersFromPlistName:plistName target:self] retain];
    return [[CPFacesProLocalizer sharedLocalizer] localizedSpecifiersForSpecifiers:specs];
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *tweakSettings = [NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    if (!tweakSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return tweakSettings[specifier.properties[@"key"]];
}
 
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    CFStringRef tweakPost = (CFStringRef)specifier.properties[@"PostNotification"];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), tweakPost, NULL, NULL, YES);

    NSDictionary *properties = specifier.properties;
    NSString *key = properties[@"key"];

    if ([key isEqualToString:@"isEnabled"]) {
        [UIView animateWithDuration:1.0 animations:^{
            isEnabled = [value boolValue];
            UITableViewCell *cell = [[self table] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell.textLabel.enabled = isEnabled;
            cell.userInteractionEnabled = isEnabled;
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UITableViewCell *cell = [[self table] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.textLabel.enabled = isEnabled;
    cell.userInteractionEnabled = isEnabled;
}

- (void)displayAd {
    if (showAd) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        _bannerView.adUnitID = @"ca-app-pub-9132257322960522/5759805530";
        _bannerView.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        _bannerView.frame = CGRectMake(0, self.table.frame.size.height-50, self.table.frame.size.width, 50);
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_bannerView];
        GADRequest *request = [GADRequest request];
        [_bannerView loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (hasDeterminedState) {
        [self displayAd];
    } else {
        hasDeterminedState = YES;

        noPlzPrivacy(^(CPPurchaseState state) {
            showAd = state != CPPurchaseStatePaid;
            [self displayAd];
        });
    }

    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    isEnabled = defaults[@"isEnabled"] ? [defaults[@"isEnabled"] boolValue] : YES;

    UIImage *userWallpaperImage = userLockscreenWallpaper();
    if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
        self.navigationController.navigationController.navigationBar.barTintColor = [userWallpaperImage dominantColor];
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
        self.navigationController.navigationBar.barTintColor = [userWallpaperImage dominantColor];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tweetSupport:)];

    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [userWallpaperImage dominantColor];
    [UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = MAIN_TINTCOLOR;

    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.barTintColor = nil;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
    } else {
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.barTintColor = nil;
        self.navigationController.navigationBar.titleTextAttributes = nil;
    }

    [[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];

    [_bannerView removeFromSuperview];
    _bannerView = nil;
}

- (PSTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    ((UILabel *)cell.titleLabel).textColor = [UIColor blackColor];
    return cell;
}

-  (void)tweetSupport:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

        [composeController setInitialText:@"#FacesPro by @benr9500 and @cpdigdarkroom lets me add images to my passcode buttons, hold to call, and much more! Available now on @BigBoss!"];
        
        [self presentViewController:composeController animated:YES completion:nil];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [composeController dismissViewControllerAnimated:YES completion:nil];
        };
        composeController.completionHandler = myBlock;
    }
}

@end