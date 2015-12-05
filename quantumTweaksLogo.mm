#import <MobileGestalt/MobileGestalt.h>

int main(int argc, char **argv, char **envp) {
	NSString *device = (NSString *)MGCopyAnswer(CFSTR("ProductType"));

	NSString *ecid;
	if ([device isEqualToString:@"iPhone3,1"] || [device isEqualToString:@"iPhone3,2"]){
		ecid = (NSString *)MGCopyAnswer(CFSTR("InternationalMobileEquipmentIdentity"));
	} else {
		ecid = (NSString *)MGCopyAnswer(CFSTR("UniqueChipID"));
	}
	NSString *serialNumber = (NSString *)MGCopyAnswer(CFSTR("SerialNumber"));
	NSString *wifiMac = (NSString *)MGCopyAnswer(CFSTR("WifiAddress"));
	NSString *btMac = (NSString *)MGCopyAnswer(CFSTR("BluetoothAddress"));
	NSString *hashStr = [NSString stringWithFormat:@"%@%@%@%@", serialNumber, ecid, wifiMac, btMac];

	NSString *urlString = [NSString stringWithFormat:@"https://quantumtweaks.com/auth/rosen/BRQuantumCheck.php?hashstr=%@&package=%@&version=%@", hashStr, @"com.cpdigitaldarkroom.benrosen.facespro", @"1.0.1"];
	NSError *sendError = nil;
	NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:nil error:&sendError];
	
	if (sendError) {
		return 1;
	}
	NSError *jsonError = nil;
	NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonError];
	if (jsonError) {
		return 1;
	}
	BOOL paid = [responseDict[@"paid"] boolValue];
	if (!paid) 
	{
		NSLog(@"Piracy makes me sad :( consider buying?");
	}
	return 0;
}