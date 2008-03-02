//
//  AudioEOFProtectingSource.h
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioHeaders.h"

@interface AudioEOFProtectingSource : NSObject <AudioSource>
{
	id<AudioSource> unprotectedSource;
	id<AudioSource> silenceSource;
}

- (id) initWithUnprotectedSource:(id<AudioSource>) unprotectedSource;
- (AUDIO_SHORTS_PTR) getAudio:(float) msec;

@end
