//
//  AudioSineWaveSource.h
//  iDJ
//
//  Created by Aaron Zinman on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioHeaders.h"

@interface AudioSineWaveSource : NSObject <AudioSource>
{
	AUDIO_SHORTS_PTR buffer;
	float bufferSizeInMsec;
	unsigned int bufferSizeInBytes;
	double frequency;
	double omega, b, y1, y2;
}

- (id) initWithFrequency:(double) freq;
- (AUDIO_SHORTS_PTR) getAudio:(float) msec;

@end



