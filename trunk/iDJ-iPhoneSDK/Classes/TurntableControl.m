//
//  TurntableControl.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/13/08.
//  Copyright 2008 "Team iDJ". All rights reserved.
//

#import "TurntableControl.h"

CALayer *_discLayer;
CALayer *_pickupLayer;
float _rotation = 0;

@implementation TurntableControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// Set up the disc
		_discLayer = [CALayer layer];
		_discLayer.doubleSided = NO;
		_discLayer.bounds = frame;
		UIImage *discImage = [UIImage imageNamed:@"turntable_disc.png"];
		_discLayer.contents = (id)discImage.CGImage;
		_discLayer.position = CGPointMake(100, 100); // move to center
		[self.layer addSublayer:_discLayer];
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

/** onTimerEvent: called every 1/FRAMES_PER_SECOND second. */
-(void) onTimerEvent:(NSTimer *)timer;
{
	// Redraw screen
	_rotation += 3.0;
	///_rotation = _rotation % 360.0;
	if (_rotation > 360)
		_rotation = 0;
	//NSLog(@"turntable.rotate: value %.0f", _rotation);
	[_discLayer setValue:[NSNumber numberWithFloat: degreesToRadians(_rotation)] forKeyPath:@"transform.rotation"];
}

/*
- (void)drawRect:(CGRect)rect {
	// Paint rectangle
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect bounds = [self bounds];
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
	CGContextFillRect(context, bounds);
}
*/

@end
