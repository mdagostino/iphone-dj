//
//  AudioSilenceSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioSilenceSource.h"


static AUDIO_SHORTS_PTR buffer = NULL;
static int bufferSizeInMsec = 0;

@implementation AudioSilenceSource

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	if ( buffer == NULL || bufferSizeInMsec != msec ) 
	{
		srandom(time(0));
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
