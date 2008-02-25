//
//  AudioCompositor.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioCompositor.h"


@implementation AudioCompositor

- (id) initWithSourceA:(id <AudioSource>) a andSourceB:(id <AudioSource>) b
{
	if ( self = [super init] )
	{
		if ( !a || !b )
		{
			NSLog(@"a: %@ and b: %@ must be valid audiosources", a, b);
			return nil;
		}

		buffer = NULL;
		bufferSizeInMsec = 0;
		bufferSizeInBytes = 0;
		sourceA = a;
		sourceB = b;
		xFader = 0.5;
	}

	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	if ( buffer == NULL || bufferSizeInMsec != msec ) 
	{
		srandom(time(0));
		NSLog(@"allocating AudioSilenceSource buffer");
		if ( buffer != NULL )
			free (buffer);
		
		bufferSizeInBytes = framesToBytes(msecToFrames(msec));
		bufferSizeInMsec = msec;

		buffer = (AUDIO_SHORTS_PTR)calloc(1, bufferSizeInBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate AudioSilenceSource buffer");
			exit(1);
		}
	}
	
	AUDIO_SHORTS_PTR aAudio = [sourceA getAudio:msec];
	AUDIO_SHORTS_PTR bAudio = [sourceB getAudio:msec];
	
	// mix them, thx to http://www.vttoth.com/digimix.htm
	int numShorts = bufferSizeInBytes >> 1; // bytes to shorts

	// TODO: take into account xfader
	for ( int i = 0; i < numShorts; i++ )
	{
		int z1 = ((int)aAudio[i] * (int)bAudio[i] / 1 << 15);
		if ( aAudio[i] < 0 && bAudio[i] < 0 )
			buffer[i] = (short) z1;
		else
			buffer[i] = (short) ( 2 * ((int)aAudio[i] + (int)bAudio[i]) - z1 - (1 << 16));
	}
	
	return buffer;
}

// takes a value from 0-1, where 0.5 = half a and half b, 0 = 100% a, 1 = 100% b, otherwise using a sigmoid to ramp up
- (void) setXFader:(float) newXFader;
{
	if ( newXFader < 0 || newXFader > 1 )
	{
		NSLog(@"ERROR: AudioCompositors only take values between 0 and 1 for mixes, %f given", newXFader);
		return;
	}
	
	xFader = newXFader;
}

@end
