//
//  AudioThreadedForwardBuffer.h
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AudioThreadedForwardBuffer : NSObject <AudioSource>
{
	id<AudioSource> source;
}

- (id) initWithSource:(id<AudioSource>) source;
- (AUDIO_SHORTS_PTR) getAudio:(int) msec;

@end
