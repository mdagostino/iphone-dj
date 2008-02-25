//
//  AudioNoiseSource.h
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioHeaders.h"

@interface AudioNoiseSource : NSObject <AudioSource>
{
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec;

@end
