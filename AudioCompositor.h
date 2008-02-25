//
//  AudioCompositor.h
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioHeaders.h"


@interface AudioCompositor : NSObject <AudioSource> 
{
	AUDIO_SHORTS_PTR buffer;
	int bufferSizeInMsec;
	int bufferSizeInBytes;

	id <AudioSource> sourceA;
	id <AudioSource> sourceB;
	float xFader;
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec;

// can only set the sources on creation for thread performance reasons
- (id) initWithSourceA:(id <AudioSource>) a andSourceB:(id <AudioSource>) b;

// takes a value from 0-1, where 0.5 = half a and half b, 0 = 100% a, 1 = 100% b, otherwise using a sigmoid to ramp up
- (void) setXFader:(float) newXFader;

@end
