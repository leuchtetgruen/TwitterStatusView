//
//  Tweet.m
//  TouchesTest
//
//  Created by Hannes Walz on 26.05.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

@synthesize username, content, createdAt, tweetId;


- (void) fillWithDict:(NSDictionary *) dict {

	self.username = [[dict objectForKey:@"user"] objectForKey:@"name"];
	self.content = [dict objectForKey:@"text"];
	self.tweetId = [dict objectForKey:@"id"];
	self.createdAt = [dict objectForKey:@"created_at"];
}

- (void) dealloc {
	[username release];
	[content release];
	[tweetId release];
	[createdAt release];
	[super dealloc];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"Tweet by %@ \n \"%@\" \n Id : %@ (%@)", self.username, self.content, self.tweetId, self.createdAt];
}

- (NSComparisonResult)compare:(id)otherObject { 
	Tweet *otherTweet = (Tweet *) otherObject;
    return [self.tweetId compare:otherTweet.tweetId]; 
} 

@end
