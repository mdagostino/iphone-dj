//
//  TurntableControl.h
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/13/08.
//  Copyright 2008 "Team iDJ". All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "iDJUtility.h"

@interface TurntableControl : UIView {
	CALayer *_discLayer;
	CALayer *_pickupLayer;
	float _rotation;
}

-(void) onTimerEvent:(NSTimer *)timer;

@end
