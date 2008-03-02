//
//  AudioSilenceSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioSilenceSource.h"
#import <math.h>

@implementation AudioSilenceSource

- (id) init
{
	if ( self = [super init] )
	{
		buffer = NULL;
		bufferSizeInMsec = 0.0;
	}

	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(float) msec
{
	if ( buffer == NULL || bufferSizeInMsec < fabs(msec) ) 
	{
		NSLog(@"allocating AudioSilenceSource buffer");
		if ( buffer != NULL )
			free (buffer);
		
		int numBytes = framesToBytes(msecToFrames(fabs(msec)));
		buffer = (AUDIO_SHORTS_PTR)realloc(buffer, numBytes);
		if ( buffer == NULL )
		{
			NSLog(@"Couldn't allocate AudioSilenceSource buffer");
			exit(1);
		}
		
		bufferSizeInMsec = msec;
		bzero((void *)buffer, numBytes);
	}
	
	return buffer;
}

@end
