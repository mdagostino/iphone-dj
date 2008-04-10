//
//  TurntableControl.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/13/08.
//  Copyright 2008 "Team iDJ". All rights reserved.
//

#import "TurntableControl.h"


@implementation TurntableControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// Set up the disc
		_rotation = 0;
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
	//NSLog(@"is multithreaded: %d", [NSThread isMultiThreaded]);
	
	// Redraw screen
	_rotation += 10.0;
	NSLog(@"angle is: %g (%g)", _rotation, degreesToRadians(_rotation));
	if (_rotation > 180.0)
		_rotation -= 360.0;
	//[_discLayer setValue:[NSNumber numberWithFloat: degreesToRadians(_rotation)] forKeyPath:@"transform.rotation"];
	
	CGAffineTransform tr;
	float r = degreesToRadians(_rotation);
	tr.a = cos(r);
	tr.b = -sin(r);
	tr.c = -tr.b;
	tr.d = tr.a;
	tr.tx = tr.ty = 0;
	
	[_discLayer setAffineTransform: tr];
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
