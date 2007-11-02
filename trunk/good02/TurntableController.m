//
//  TurntableController.m
//  iphonedj
//
//  Created by Aaron Zinman on 10/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TurntableController.h"


@implementation TurntableController

- (id) init 
{
	if ( self = [super init] )
	{
		NSLog(@"doing view");
		view = [[TurntableView alloc] init];
		NSLog(@"doing audio");
		audio = [[TurntableAudio alloc] init];
		
		NSLog(@"initing vars");
		playingForwards = YES;
		rate = 1.0;
		position = 0;
		viewRotationInDegrees = 0;
		rotationRatePerSecondInDegrees = 33.333 / 60.0 * 2 * 3.141592;
		NSLog(@"controller init done");

	}
	
	return self;
}

- (TurntableView *) view
{
	return view;
}

- (TurntableAudio *) audio
{
	return audio;
}


- (void) playBackwards
{}

- (void) playForwards
{}

- (void) goToPosition:(unsigned int) pos
{
	
}
- (void) updatePosition:(unsigned int) pos
{
	position = pos;
}

- (void) setRate:(float) rate
{}

- (void) englishSpin:(float) rate
{}

- (float) rate
{
	return rate;
}

- (int) position
{
	return position;
}

- (void) updateRotation: (float) deltaMsec
{
	viewRotationInDegrees += deltaMsec * rotationRatePerSecondInDegrees / 1000.0;
	[view setRotationBy: viewRotationInDegrees];
	[view setNeedsDisplay];
}

@end