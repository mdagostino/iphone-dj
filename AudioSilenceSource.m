//
//  AudioSilenceSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioSilenceSource.h"


@implementation AudioSilenceSource

- (id) init
{
	if ( self = [super init] )
	{
		buffer = NULL;
		bufferSizeInMsec = 0;
	}

	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	if ( buffer == NULL || bufferSizeInMsec != msec ) 
	{
		NSLog(@"allocating AudioSilenceSource buffer");
		if ( buffer != NULL )
			free (buffer);
		
		int numBytes = framesToBytes(msecToFrames(msec));
		buffer = (AUDIO_SHORTS_PTR)calloc(1, numBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate AudioSilenceSource buffer");
			exit(1);
		}
		bufferSizeInMsec = msec;
		// no need to init, calloc sets bytes to 0
	}
	
	return buffer;
}

@end
