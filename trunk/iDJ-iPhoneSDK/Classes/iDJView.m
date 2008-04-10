//
//  MyView.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iDJView.h"

static float FRAMES_PER_SECOND = 20.0;

@implementation iDJView

/** initWithFrame: init the UIView. */
- (id) initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame])) {
		// Cross Fader
		_crossFader = [[[FaderControl alloc] initWithFrame: CGRectMake(-40, (frame.size.height - 55)/2, 150, 55)] autorelease];
		[_crossFader setCurrentValue: 0.8];
		// Rotate fader on screen
		[_crossFader.layer setValue:[NSNumber numberWithFloat: degreesToRadians(90)] forKeyPath:@"transform.rotation"];
		[self addSubview: _crossFader];

		// Turntables
		_turntable1 = [[[TurntableControl alloc] initWithFrame: CGRectMake((frame.size.width - 200)/2, frame.size.height/4*1 - 100, 200, 200)] autorelease];
		[self addSubview: _turntable1];
		_turntable2 = [[[TurntableControl alloc] initWithFrame: CGRectMake((frame.size.width - 200)/2, frame.size.height/4*3 - 100, 200, 200)] autorelease];
		[self addSubview: _turntable2];

		// Timer for screen redraw
		/*id timer = */[NSTimer scheduledTimerWithTimeInterval: 1.0/FRAMES_PER_SECOND target: self selector: @selector(onTimerEvent:) userInfo: nil repeats: YES];
	}
	
	return self;
}

/** onTimerEvent: called every 1/FRAMES_PER_SECOND second. */
-(void) onTimerEvent:(NSTimer *)timer;
{
	// Redraw screen
	//NSLog(@"onTimerEvent: redraw");
	[_turntable1 onTimerEvent:timer];
	[_turntable2 onTimerEvent:timer];
	[self setNeedsDisplay];
}

@end



