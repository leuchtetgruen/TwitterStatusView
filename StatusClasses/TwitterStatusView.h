//
//  TwitterStatusView.h
//  TwitterStatus
//
//  Created by Hannes Walz on 06.06.11.
//  Copyright 2011 Nerd Communications GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterStatusUpdate.h"
#import "Tweet.h"
#import <QuartzCore/QuartzCore.h>

@interface TwitterStatusView : UIView<TwitterStatusUpdateDelegate> {
	
	UILabel *lblText;
	UILabel *lblTime;
	
	TwitterStatusUpdate *statusUpdate;
}

@property (assign) UIImageView *imgBird;
@property (assign) UILabel *lblText;
@property (assign) UILabel *lblTime;
@property (assign) TwitterStatusUpdate *statusUpdate;

- (void) updateForUsername:(NSString *) username;
- (void) show;
- (void) hide;
- (NSDate*)dateFromTwitter:(NSString*)str;

@end
