/*
 *  MasterAudioController.h
 *  iphonedj
 *
 *  Created by Aaron Zinman on 10/21/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#import "TurntableAudio.h"
#import "AudioQueue.h"

#include <string.h>
#include <stdio.h>
#include <pthread.h>
#include <sys/select.h>

#include "mad.h"
#include "audio.h"

#import <UIKit/UIKit.h>
#import <Foundation/NSLock.h>

/* Audio Resources */
#define AUDIO_BUFFERS 3
#define MP3_FRAME_SIZE 1152
#define MP3_FRAME_SIZE_BYTES (1152 * 4)
#define CYCLES_PER_MP3_READ 20
#define WAVE_BUFFER_SIZE (MP3_FRAME_SIZE_BYTES * 2 * CYCLES_PER_MP3_READ * 2) 

typedef struct AQCallbackStruct {
    AudioQueueRef queue;
    UInt32 frameCount;
    AudioQueueBufferRef mBuffers[AUDIO_BUFFERS];
    AudioStreamBasicDescription mDataFormat;
} AQCallbackStruct;


void initAudioController();
void finishAudioController();

