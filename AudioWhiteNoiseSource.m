//
//  AudioWhiteNoiseSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioWhiteNoiseSource.h"


@implementation AudioWhiteNoiseSource

- (id) init
{
	if ( self = [super init] )
	{
		buffer = NULL;
		bufferSizeInMsec = 0.0;
		bufferSizeInBytes = 0;
	}
	
	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(float) msec
{
	if ( msec < 0 )
	{
		msec *= -1;
		NSLog(@"AudioWhiteNoiseSource only goes in 1 direction");
	}

	if ( buffer == NULL || bufferSizeInMsec < msec ) 
	{
		srandom(time(0));
		NSLog(@"allocating noiseSource buffer");
		if ( buffer != NULL )
			free (buffer);
		
		bufferSizeInBytes = framesToBytes(msecToFrames(msec));
		buffer = (AUDIO_SHORTS_PTR)realloc(buffer, bufferSizeInBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate noisegen buffer");
			exit(1);
		}
		bufferSizeInMsec = msec;
	}
	
	// need to keep generating random noise
	for ( int i = 0; i < (bufferSizeInBytes/WAVE_BYTES_PER_SAMPLE); i++ )
		buffer[i] = (short) random();

	return buffer;
}

@end
