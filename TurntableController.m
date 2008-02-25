//
//  TurntableController.m
//  iphonedj
//
//  Created by Aaron Zinman on 10/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TurntableController.h"


@implementation TurntableController

//- (id) initWithAudioStruct:(TurntableAudioStruct *) audioStruct
- (id) init
{
	if ( self = [super init] )
	{
//		audioStructPtr = audioStruct;
		
		NSLog(@"doing view");
		view = [[TurntableGLView alloc] initWithController:self];
		
		NSLog(@"initing vars");
		playingForwards = YES;
		rate = 1.0;
		position = 0;
		viewRotationInDegrees = 0;
		ticking = YES;
		rotationRatePerSecondInDegrees = 33.333 / 60.0 * 360.0;// 2 * 3.141592;
		NSLog(@"controller init done");
		
		
		watch = [[Stopwatch alloc] initWithName:@"turntableControllerUpdateFreq"];
		[watch startFPS];
	}
	
	return self;
}

- (TurntableGLView *) view
{
	return view;
}

//- (TurntableAudioStruct *) audio
//{
//	return audioStructPtr;
//}


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
	[watch tick];
	viewRotationInDegrees = deltaMsec * rotationRatePerSecondInDegrees / 1000.0;
//	if ( viewRotationInDegrees > 360

	// on for normal views
//	[view setRotationBy: viewRotationInDegrees];

//	[Renderer markDirty:view];
}

- (float) rotationInDegrees
{
	return viewRotationInDegrees;
}

- (void)tick
{
	float msecPassed = [watch tick];

	if ( ! ticking )
		return;

	[self updateRotation: msecPassed];
}

- (void) pauseTicking { ticking = NO; NSLog(@"pauseTicking"); }
- (void) resumeTicking  { ticking = YES; NSLog(@"resumeTicking"); }


@end
