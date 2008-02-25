//
//  AudioNoiseSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioNoiseSource.h"

static AUDIO_SHORTS_PTR buffer = NULL;
static int bufferSizeInMsec = 0;

@implementation AudioNoiseSource

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	if ( buffer == NULL || bufferSizeInMsec != msec ) 
	{
		srandom(time(0));
		NSLog(@"allocating noiseSource buffer");
		if ( buffer != NULL )
			free (buffer);
		
		int numBytes = framesToBytes(msecToFrames(msec));
		buffer = (AUDIO_SHORTS_PTR)calloc(1, numBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate noisegen buffer");
			exit(1);
		}
		bufferSizeInMsec = msec;
		
		for ( int i = 0; i < (numBytes/WAVE_BYTES_PER_SAMPLE); i++ )
			buffer[i] = (short)(random() & 0xFFFF);
	}
	
	return buffer;
}

@end
