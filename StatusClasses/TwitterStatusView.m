//
//  TwitterStatusView.m
//  TwitterStatus
//
//  Created by Hannes Walz on 06.06.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#import "TwitterStatusView.h"


@implementation TwitterStatusView

@synthesize imgBird, lblTime, lblText, statusUpdate;

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
		[lblTime setText:@"Time"];
		[self addSubview:lblTime];
    }
	

	CGRect f = self.frame;
	f.origin.y = -100;
	self.frame = f;
	
    return self;
}

- (void) updateForUsername:(NSString *) username {
	statusUpdate = [[TwitterStatusUpdate alloc] init];
	statusUpdate.delegate = self;
	[statusUpdate updateForUsername:username];
}

- (void) show {
	
	CGRect frame = self.frame;
	[UIView beginAnimations:@"slideDown" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	frame.origin.y = 0;
	self.frame = frame;
	[UIView commitAnimations];
}

- (void) hide {
	CGRect frame = self.frame;
	[UIView beginAnimations:@"slideDown" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	frame.origin.y = -100;
	self.frame = frame;
	[UIView commitAnimations];
}

- (void) receivedNewTweets:(NSArray *) tweets {
	Tweet *lastTweet = [tweets lastObject];
	[lblText setText:lastTweet.content];
	
	NSDate *dt = [self dateFromTwitter:lastTweet.createdAt];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	[dateFormatter setLocale:[NSLocale currentLocale]];
	lblTime.text = [dateFormatter stringFromDate:dt];
	[dateFormatter release];

	[self show];	
	[self performSelector:@selector(hide) withObject:nil afterDelay:kDelayUntilHidingTweetWindow];
}

- (void)dealloc {
	[imgBird release];
	[lblText release];
	[lblTime release];
	[statusUpdate release];
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
