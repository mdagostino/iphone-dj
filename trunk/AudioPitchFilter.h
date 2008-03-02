//
//  AudioPitchFilter.h
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioHeaders.h"


@interface AudioPitchFilter : NSObject <AudioChain, AudioSource>
{
	AUDIO_SHORTS_PTR buffer;
	float bufferSizeInMsec;
	unsigned int bufferSizeInBytes;
	float speed;
	id<AudioSource> source;
}

// WARNING: THIS IS A POTENTIALLY MULTI-THREADED DISASTER!
// USE AFTER INIT FOR NOW, UNTIL WE FIGURE OUT A PERFORMANCE-LOCKING SCHEME
- (void) setSource:(id<AudioSource>) newSource;

- (AUDIO_SHORTS_PTR) getAudio:(float) msec;

- (void) setSpeedRelativeToOne:(float) speed;
@end
