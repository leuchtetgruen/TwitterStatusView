//
//  Tweet.h
//  TouchesTest
//
//  Created by Hannes Walz on 26.05.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Tweet : NSObject {
	NSString *username;
	NSString *content;
	NSString *createdAt;
	
	NSNumber *tweetId;
}

@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSNumber *tweetId;
@property (nonatomic,retain) NSString *createdAt;

- (void) fillWithDict:(NSDictionary *) dict;
- (NSComparisonResult)compare:(id)otherObject;
@end
