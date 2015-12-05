#import "CPFacesProDeveloperTableCell.h"
#import "CPFacesProPreferences.h"

@implementation CPFacesProDeveloperTableCell
@synthesize devImageView,devNameLabel,realNameLabel,jobLabel;

-(id)initWithDevName:(NSString *)devName realName:(NSString *)realName jobSubtitle:(NSString *)job devImage:(UIImage *)devImage {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPFacesProDeveloperTableCell"];

    if (self) {

        self.devImageView = [[UIImageView alloc] initWithImage:devImage];
        self.devImageView.frame = CGRectMake(10,15,70,70);
        self.devImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.devImageView.layer.shadowOffset = CGSizeMake(0, 1);
        self.devImageView.layer.shadowOpacity = 0.2;
        self.devImageView.layer.shadowRadius = 1.0;
        self.devImageView.clipsToBounds = NO;
        [self addSubview:self.devImageView];

        self.devNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.devNameLabel setText:devName];
        [self.devNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.devNameLabel setTextColor:[UIColor darkGrayColor]];
        [self.devNameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:iPad ? 30 : 20]];
        [self.devNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.devNameLabel];
        [self.devNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.devNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.devImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.devNameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20]];

        self.realNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.realNameLabel setText:realName];
        [self.realNameLabel setTextColor:[UIColor grayColor]];
        [self.realNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.realNameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];
        [self.realNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.realNameLabel];
        [self.realNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.realNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.devImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.realNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.devNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

        self.jobLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.jobLabel setText:job];
        [self.jobLabel setTextColor:[UIColor grayColor]];
        [self.jobLabel setBackgroundColor:[UIColor clearColor]];
        [self.jobLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:12]];
        [self.jobLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.jobLabel];
        [self.jobLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.jobLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.devImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.jobLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.realNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    }

    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)spec {
    NSBundle *settingsBundle = [CPFacesProLocalizer sharedLocalizer].localizationBundle;
    UIImage *developerImage = [[UIImage alloc] initWithContentsOfFile:[settingsBundle pathForResource:[spec propertyForKey:@"devImage"] ofType:@"png"]];
    self = [self initWithDevName:[spec propertyForKey:@"devName"] realName:[spec propertyForKey:@"realName"] jobSubtitle:[spec propertyForKey:@"job"] devImage:developerImage];
    return self;
}

@end