//
//  FaderControl.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright 2008 "Team iDJ". All rights reserved.
//

#import "FaderControl.h"

CALayer *_backgroundLayer;
CALayer *_buttonLayer;

@implementation FaderControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// Set up the background
		_backgroundLayer = [CALayer layer];
		_backgroundLayer.doubleSided = NO;
		_backgroundLayer.bounds = frame;
		UIImage *backgroundImage = [UIImage imageNamed:@"fader_background.png"];
		_backgroundLayer.contents = (id)backgroundImage.CGImage;
		_backgroundLayer.anchorPoint = CGPointMake(0, 0); // set anchor point to top-left
		[self.layer addSublayer:_backgroundLayer];

		// Set up the button
		_buttonLayer = [CALayer layer];
		_buttonLayer.doubleSided = NO;
		_buttonLayer.bounds = CGRectMake(0, 0, 22, 42);
		_buttonLayer.position = CGPointMake(frame.size.width/2 - 2, frame.size.height/2);
		UIImage *buttonImage = [UIImage imageNamed:@"fader_button.png"];
		_buttonLayer.contents = (id)buttonImage.CGImage;
		[self.layer addSublayer:_buttonLayer];
    }
    return self;
}

/** touchesChangedWithEvent: multi-touch handling. */
- (void)touchesChangedWithEvent:(UIEvent*)event
{
	// Copied from http://developer.apple.com/iphone/library/codinghowtos/UserExperience/index.html#MULTI_TOUCH-HANDLE_TOUCH_EVENTS_SUCH_AS_TRACKING_THE_USER_S_FINGER_OR_DETECTING_A_MULTI_TOUCH_EVENT
    NSSet *touches = [event allTouches];
    for (UITouch *myTouch in touches)
    {
		// Get location, and move button
        CGPoint touchLocation = [myTouch locationInView];
		//NSLog(@"touchesChangedWithEvent: %.0f;%.0f", touchLocation.x, touchLocation.y);
		int newX = touchLocation.x;
		if (newX < _buttonLayer.bounds.size.width/2)
			newX = _buttonLayer.bounds.size.width/2;
		if (newX > _backgroundLayer.bounds.size.width - _buttonLayer.bounds.size.width/2)
			newX = _backgroundLayer.bounds.size.width - _buttonLayer.bounds.size.width/2;
		_buttonLayer.position = CGPointMake(newX, _buttonLayer.position.y);
    }
}

/** drawRect: paint the FaderControl on the screen. */
/*
- (void)drawRect:(CGRect)rect {
	CGContextRef		context = UIGraphicsGetCurrentContext();
	CGRect				bounds = [self bounds];

    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
	CGContextFillRect(context, bounds);
}
*/

- (void)dealloc
{
	[super dealloc];
}

@end