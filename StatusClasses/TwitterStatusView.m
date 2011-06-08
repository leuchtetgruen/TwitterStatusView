//
//  TwitterStatusView.m
//  TwitterStatus
//
//  Created by Hannes Walz on 06.06.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#import "TwitterStatusView.h"


@implementation TwitterStatusView

@synthesize imgBird, lblTime, lblText, statusUpdate, messageToReturnFirstTime;

- (id) init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 100)];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];		
		self.layer.borderColor = [UIColor blackColor].CGColor;
		self.layer.borderWidth = 1;
		
		
		lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 60)];
		[lblText setTextColor:[UIColor whiteColor]];
		[lblText setOpaque:NO];
		[lblText setBackgroundColor:[UIColor clearColor]];
		[lblText setNumberOfLines:3];
		[self addSubview:lblText];
		
		lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 20)];
		[lblTime setFont:[UIFont fontWithName:@"Helvetica" size:10]];
		[lblTime setTextColor:[UIColor lightGrayColor]];
		[lblTime setOpaque:NO];
		[lblTime setBackgroundColor:[UIColor clearColor]];
		[self addSubview:lblTime];
    }
	

    [self resetAnimationState];
	
    return self;
}

- (void) resetAnimationState {
    CGRect f = self.frame;
	f.origin.y = -50;
	self.frame = f;
    self.layer.anchorPoint = CGPointMake(0.5, 0);
    self.layer.anchorPointZ = 0;
    self.layer.transform = CATransform3DMakeRotation(M_PI / 2, 1, 0, 0);   
    self.alpha = 0;
    
    CATransform3D aTransform = CATransform3DIdentity;
    float zDistance = 1000;
    aTransform.m34 = 1.0 / -zDistance;	
    [self layer].sublayerTransform = aTransform;
}

- (void) updateForUsername:(NSString *) username {
	statusUpdate = [[TwitterStatusUpdate alloc] init];
	statusUpdate.delegate = self;
    if (messageToReturnFirstTime != nil) statusUpdate.messageToReturnFirstTime = messageToReturnFirstTime;
	[statusUpdate updateForUsername:username];
}

- (void) show {
	[UIView beginAnimations:@"swing1" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
    self.alpha = 1;
    self.layer.transform = CATransform3DMakeRotation((M_PI / 2), 0, 0, 0);        
    
	[UIView commitAnimations];
}



- (void) hide {

	[UIView beginAnimations:@"slideDown" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];

    self.alpha = 0;
    self.layer.transform = CATransform3DMakeRotation(-(M_PI / 2), 1, 0, 0);   
	[UIView commitAnimations];
}



- (void) receivedNewTweets:(NSArray *) tweets {
	Tweet *lastTweet = [tweets objectAtIndex:0];
	[lblText setText:lastTweet.content];
	
    if (![lastTweet.content isEqualToString:messageToReturnFirstTime]) {
        // Dont show a date when showind the first time message
        NSDate *dt = [self dateFromTwitter:lastTweet.createdAt];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        [dateFormatter setLocale:[NSLocale currentLocale]];
        lblTime.text = [dateFormatter stringFromDate:dt];
        [dateFormatter release];
    }


	[self show];	
	[self performSelector:@selector(hide) withObject:nil afterDelay:kDelayUntilHidingTweetWindow];
}

- (void)dealloc {
	[imgBird release];
	[lblText release];
	[lblTime release];
	[statusUpdate release];
    [messageToReturnFirstTime release];
    [super dealloc];
}

#pragma mark -
#pragma mark Date

-(NSDate*)dateFromTwitter:(NSString*)str {
	static NSDateFormatter* sTwitter = nil;
	
	if (str == nil) {
		NSDate * today = [[[NSDate alloc] init] autorelease];
		return today;
	}
	
	if (!sTwitter) {
		sTwitter = [[NSDateFormatter alloc] init];
		NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
		[sTwitter setLocale:usLocale];
		[usLocale release];
		[sTwitter setTimeStyle:NSDateFormatterFullStyle];
		[sTwitter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[sTwitter setDateFormat:@"EEE LLL dd HH:mm:ss Z yyyy"];
	}
	return [sTwitter dateFromString:str];
}




@end
