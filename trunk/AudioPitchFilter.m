//
//  AudioPitchFilter.m
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioPitchFilter.h"


@implementation AudioPitchFilter

- (id) init
{
	if ( self = [super init] )
	{
		buffer = NULL;
		bufferSizeInMsec = 0.0;
		bufferSizeInBytes = 0;
		speed = 1.0;
		source = [[AudioSilenceSource alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	if ( buffer != NULL )
		free(buffer);
	if ( source )
		[source release];
	[super dealloc];
}


// WARNING: THIS IS A POTENTIALLY MULTI-THREADED DISASTER!
// USE AFTER INIT FOR NOW, UNTIL WE FIGURE OUT A PERFORMANCE-LOCKING SCHEME
- (void) setSource:(id<AudioSource>) newSource;
{
	if ( source )
	{
		[source release];
	}
	source = [newSource retain];
}


- (AUDIO_SHORTS_PTR) getAudio:(float) msec
{
	if ( buffer == NULL || bufferSizeInMsec < msec ) 
	{
		NSLog(@"allocating AudioPitchFilter buffer");
		
		bufferSizeInBytes = framesToBytes(msecToFrames(fabs(msec)));
		buffer = (AUDIO_SHORTS_PTR)realloc(buffer, bufferSizeInBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate AudioPitchFilter buffer");
			exit(1);
		}
		bufferSizeInMsec = msec;
	}
	
	if ( speed == 1.0 )
		return [source getAudio:msec];
	
	// now we pitch, calculate values
	float targetMsec = (msec * speed);
	int numTargetShorts = framesToShorts(msecToFrames(fabs(targetMsec)));
	int numBufferShorts = (bufferSizeInMsec == msec ? bufferSizeInBytes >> 1 : framesToShorts(msecToFrames(msec)) ); 

	// get our unpitched audio
	AUDIO_SHORTS_PTR srcAudio = [source getAudio:targetMsec];
	
	// pitch it!
	pitchShift(srcAudio, numTargetShorts, buffer, numBufferShorts);
	
	// and return it
	return buffer;
}


- (void) setSpeedRelativeToOne:(float) newSpeed
{
	speed = newSpeed;
}


@end
