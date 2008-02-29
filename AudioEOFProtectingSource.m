//
//  AudioEOFProtectingSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioEOFProtectingSource.h"


@implementation AudioEOFProtectingSource

- (id) initWithUnprotectedSource:(id<AudioSource>) _unprotectedSource;
{
	if ( self = [super init] )
	{
		unprotectedSource = [_unprotectedSource retain];
		silenceSource = [[AudioSilenceSource alloc] init];
	}

	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	@try
	{
		AUDIO_SHORTS_PTR audio = [unprotectedSource getAudio:msec];
		return audio;
	}
	@catch ( EOFException *e )
	{
		NSLog([e reason]);
		return [silenceSource getAudio:msec];
	}
}

- (void ) dealloc
{
	[silenceSource release];
	[unprotectedSource release];
	[super dealloc];
}


@end