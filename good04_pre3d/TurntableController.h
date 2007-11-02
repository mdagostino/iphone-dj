//
//  TurntableController.h
//  iphonedj
//
//  Created by Aaron Zinman on 10/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TurntableView.h";
#import	"TurntableAudio.h";
#import <GraphicsServices/GraphicsServices.h>


@interface TurntableController : NSObject
{
	TurntableView *view;
	TurntableAudio *audio;
	BOOL playingForwards;
	float rate;
	unsigned int position;
	float viewRotationInDegrees;
	float rotationRatePerSecondInDegrees;
	Stopwatch *watch;
	BOOL ticking;
}

- (TurntableView *) view;
- (TurntableAudio *) audio;
- (void) playBackwards;
- (void) playForwards;
- (void) goToPosition:(unsigned int) pos;
- (void) updatePosition:(unsigned int) pos;
- (void) setRate:(float) rate;
- (void) englishSpin:(float) rate;
- (float) rate;
- (int) position;
- (void) updateRotation: (float) deltaMsec;
- (float) rotationInDegrees;
- (void) tick;
- (void) pauseTicking;
- (void) resumeTicking;
@end
