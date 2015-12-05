typedef NS_ENUM(NSUInteger, CPPurchaseState) {
	CPPurchaseStateUnknown,
	CPPurchaseStatePirated,
	CPPurchaseStatePaid
};

typedef void (^CPPurchaseStateCompletion)(CPPurchaseState state);

extern void noPlzPrivacy(CPPurchaseStateCompletion completion);