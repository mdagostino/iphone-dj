//
//  AudioSineWaveSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioSineWaveSource.h"
#import <math.h>

@implementation AudioSineWaveSource

- (id) initWithFrequency:(double) freq
{
	if ( self = [super init] )
	{
		buffer = NULL;
		bufferSizeInMsec = 0.0;
		bufferSizeInBytes = 0;
		frequency = freq;
		omega = (2 * 3.14159 * frequency) / (double)SAMPLE_RATE;
		b = 2 * cos(omega);
		y1 = 0;
		y2 = sin(-omega);
	}
	
	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(float) msec
{
	if ( msec < 0 )
	{
		msec *= -1;
		NSLog(@"AudioSineWaveSource only goes in 1 direction");
	}

	if ( buffer == NULL || bufferSizeInMsec < msec ) 
	{
		NSLog(@"allocating AudioSineWaveSource buffer");
		
		bufferSizeInBytes = framesToBytes(msecToFrames(msec));
		bufferSizeInMsec = msec;
		buffer = (AUDIO_SHORTS_PTR)realloc(buffer, bufferSizeInBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate AudioSineWaveSource buffer");
			exit(1);
		}
	}
	
	for ( int i = 0; i < (bufferSizeInBytes/WAVE_BYTES_PER_SAMPLE); i+=2)
	{
		// L and R channels are same
		double nextVal = ((b * y1) - y2);
		static int volRange = (1 << 16 - 1);
		buffer[i] = buffer[i+1] = (short) (nextVal * volRange);
		y2 = y1;
		y1 = nextVal;
	}

	return buffer;
}

@end
