//
//  TwitterStatusUpdate.h
//  TwitterStatus
//
//  Created by Hannes Walz on 06.06.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#define kDefaultsNameForLastKnownTweet @"LAST_KNOWN_TWEET_ID"
#define kSendLastTweetWhenFirstUsing YES
#define kDelayUntilHidingTweetWindow 5


#import <Foundation/Foundation.h>
#import "Tweet.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"

@protocol TwitterStatusUpdateDelegate <NSObject>
- (void) receivedNewTweets:(NSArray *) tweets;

@end

@interface TwitterStatusUpdate : NSObject {
	id<TwitterStatusUpdateDelegate> delegate;
}

@property (assign) id<TwitterStatusUpdateDelegate> delegate;

- (NSNumber *) lastKnownTweetId;
- (void) updateForUsername:(NSString *) username;

@end
