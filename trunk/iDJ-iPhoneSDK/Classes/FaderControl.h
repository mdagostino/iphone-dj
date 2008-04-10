//
//  FaderControl.h
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright 2008 "Team iDJ". All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FaderControl : UIControl {
}

- (float)getCurrentValue;
- (void)setCurrentValue:(float)value;

@end
