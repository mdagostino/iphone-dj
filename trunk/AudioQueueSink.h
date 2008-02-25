//
//  AudioQueueSink.h
//  iDJ
//
//  Created by Aaron Zinman on 2/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioHeaders.h"

#define AUDIO_BUFFERS 3

typedef struct AQCallbackStruct {
    AudioQueueRef queue;
    UInt32 frameCount;
    AudioQueueBufferRef mBuffers[AUDIO_BUFFERS];
    AudioStreamBasicDescription mDataFormat;
} AQCallbackStruct;


@interface AudioQueueSink : NSObject <AudioChain> {
//	id<AudioSource> source;
	AQCallbackStruct in;
}

-(void) setSource:(id<AudioSource>) newSource;
-(void) start;
-(void) pause;
-(void) stop;

@end
