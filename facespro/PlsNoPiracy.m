#import <MobileGestalt/MobileGestalt.h>

typedef NS_ENUM(NSUInteger, CPPurchaseState) {
	CPPurchaseStateUnknown,
	CPPurchaseStatePirated,
	CPPurchaseStatePaid
};

typedef void (^CPPurchaseStateCompletion)(CPPurchaseState state);

void noPlzPrivacy(CPPurchaseStateCompletion completion) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		CFStringRef deviceID = MGCopyAnswer(CFSTR("UniqueDeviceID"));

		NSString *urlString = [NSString stringWithFormat:@"https://quantumtweaks.com/auth/rosen/BRDRMOnlyCheck.php?udid=%@&package=%@&version=%@", deviceID, @"com.cpdigitaldarkroom.benrosen.facespro", @"1.0.1"];

		CFRelease(deviceID);

		NSError *sendError = nil;
		NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:nil error:&sendError];

		if (sendError) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(CPPurchaseStateUnknown);
			});

			return;
		}

		NSError *jsonError = nil;
		NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&jsonError];

		if (jsonError) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(CPPurchaseStateUnknown);
			});
			
			return;
		}

		BOOL paid = ((NSNumber *)responseDict[@"paid"]).boolValue;

		dispatch_async(dispatch_get_main_queue(), ^{
			completion(paid ? CPPurchaseStatePaid : CPPurchaseStatePirated);
		});
	});
}