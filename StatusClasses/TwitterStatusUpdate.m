//
//  TwitterStatusUpdate.m
//  TwitterStatus
//
//  Created by Hannes Walz on 06.06.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#import "TwitterStatusUpdate.h"



@implementation TwitterStatusUpdate


@synthesize delegate, messageToReturnFirstTime;


- (double) lastKnownTweetId {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kDefaultsNameForLastKnownTweet];
}

- (void) updateForUsername:(NSString *) username {
	
	NSString *sinceId = [NSString stringWithFormat:@"%.0f", [self lastKnownTweetId]];
    NSLog(@"%f", [self lastKnownTweetId]);
    NSLog(@"Starting update... %@ - %@", username, sinceId);
	NSString *url;
	if ([sinceId intValue]==0) url = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@", username];
	else url = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@&since_id=%@", username, sinceId];
	
	
	ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL	URLWithString:url]];
	[req setDelegate:self];
	[req startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	
	SBJsonParser *parse = [[SBJsonParser alloc] init];
	NSMutableArray *aTweets = [parse objectWithString:responseString];
    

	
	NSMutableArray *newTweets = [[NSMutableArray alloc] init];
    double maxTweetId = 0;

	for (NSDictionary *dict in aTweets) {
		if ([dict isKindOfClass:[NSString class]]) {
			// not a valid response - possibly no new tweets
			NSLog(@"Error %@", aTweets);
			return;
		}
		
		Tweet *t = [[Tweet alloc] init];
		[t fillWithDict:dict];
		
        double tD = [t.tweetId doubleValue];
        NSLog(@"max %0.f - t %0.f", maxTweetId, tD);
        
        if (tD > maxTweetId) maxTweetId = tD;

		
		[newTweets addObject:t];
		[t release];		
	}

	BOOL isFirstRequest = ([self lastKnownTweetId]==0);	
    
    if (isFirstRequest && (messageToReturnFirstTime != nil)) {
        Tweet *t = [[Tweet alloc] init];
        t.content = messageToReturnFirstTime;
        
        if ([delegate respondsToSelector:@selector(receivedNewTweets:)]) [delegate receivedNewTweets:[NSArray arrayWithObject:t]];
        [t release];
        
        NSLog(@"Writing %f as maxTweetId", maxTweetId);
        [[NSUserDefaults standardUserDefaults] setDouble:maxTweetId forKey:kDefaultsNameForLastKnownTweet];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    
	// Nothing new - let's go back
	if ([newTweets count]==0) return;
	

    NSLog(@"Writing %f as maxTweetId", maxTweetId);	
    [[NSUserDefaults standardUserDefaults] setDouble:maxTweetId forKey:kDefaultsNameForLastKnownTweet];
	[[NSUserDefaults standardUserDefaults] synchronize];

	
	NSArray *ret;
	if (isFirstRequest) {
		if (!kSendLastTweetWhenFirstUsing) {
			[newTweets release];
			return;
		}
		
		ret = [NSArray arrayWithObject:[newTweets objectAtIndex:0]];
	}
	else ret = [NSArray arrayWithArray:newTweets];
	[newTweets release];
	
	
	
	if ([delegate respondsToSelector:@selector(receivedNewTweets:)]) {
		[delegate receivedNewTweets:ret];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"Faiiil");
}

- (void) dealloc {
    [messageToReturnFirstTime release];
    [super dealloc];
}

@end
