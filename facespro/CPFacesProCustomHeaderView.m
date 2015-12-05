#import "CPFacesProCustomHeaderView.h"
#import "CPFacesProPreferences.h"

@implementation CPFacesProCustomHeaderView
@synthesize headerLabel,subHeaderLabel,randomLabel;

- (id)init {

	   self = [super initWithFrame:CGRectZero];
	   
       if (self) {
 
            self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.headerLabel setNumberOfLines:1];
            [self.headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:45]];
            [self.headerLabel setText:@"Faces Pro"];
            [self.headerLabel setBackgroundColor:[UIColor clearColor]];
            [self.headerLabel setTextColor:[UIColor blackColor]];
            [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.headerLabel];
            [self.headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.15 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
            self.subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.subHeaderLabel setNumberOfLines:1];
            [self.subHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
            [self.subHeaderLabel setText:@"Ben Rosen and CP Digital Darkroom"];
            [self.subHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [self.subHeaderLabel setTextColor:[UIColor darkGrayColor]];
            [self.subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.subHeaderLabel];
            [self.subHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }

    return self;
}

@end