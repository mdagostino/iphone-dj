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
		sourceA = [a retain];
		sourceB = [b retain];
		xFader = 0.5;
	}

	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	if ( buffer == NULL || bufferSizeInMsec != abs(msec) ) 
	{
		NSLog(@"allocating AudioCompositor buffer");
		if ( buffer != NULL )
			free (buffer);
		
		bufferSizeInBytes = framesToBytes(msecToFrames(abs(msec)));
		bufferSizeInMsec = abs(msec);

		buffer = (AUDIO_SHORTS_PTR)calloc(1, bufferSizeInBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate AudioCompositor buffer");
			exit(1);
		}
	}
	
	AUDIO_SHORTS_PTR aAudio = [sourceA getAudio:msec];
	AUDIO_SHORTS_PTR bAudio = [sourceB getAudio:msec];
	
	// mix them preventing cliping
	int numShorts = bufferSizeInBytes >> 1; // bytes to shorts

	// TODO: take into account xfader using a sigmoidal function like tanh
	for ( int i = 0; i < numShorts; i++ )
	{
		int upsampled = (int) aAudio[i] + (int) bAudio[i];

		if ( upsampled > SIGNED_SHORT_MAX_POS )
			buffer[i] = SIGNED_SHORT_MAX_POS;
		else if ( upsampled < SIGNED_SHORT_MAX_NEG )
			buffer[i] = SIGNED_SHORT_MAX_NEG;
		else
			buffer[i] = upsampled;
	}
	
	return buffer;
}

// takes a value from 0-1, where 0.5 = half a and half b, 0 = 100% a, 1 = 100% b, otherwise using a sigmoid (tanh) to ramp up
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
