//
//  TurntableAudio.h
//  iphonedj
//
//  Created by Aaron Zinman on 10/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#DEFINE NYQUIST = 2;

// audio_queue thread
#DEFINE AUDIO_QUEUE_KERNEL_THREAD_OUTPUT_MSEC_RATE = 10; // output 10msec worth of frames at a time

// turntable_thread
#DEFINE TURNTABLE_THREAD_PROCESS_MSEC_RATE = NYQUIST * AUDIO_QUEUE_KERNEL_THREAD_OUTPUT_MSEC_RATE; // PROCESS 20msec worth of frames at a time

// file reader thread
#DEFINE MAX_READ_AHEAD_SECONDS = 10;

// audio constants
#DEFINE SAMPLE_RATE = 44100.0;
#DEFINE MP3_SAMPLES_PER_FRAME = 1152;
#DEFINE MP3_FRAME_SIZE_SEC = MP3_SAMPLES_PER_FRAME / SAMPLE_RATE;
#DEFINE MP3_FRAMES_PER_SECOND = 1 / MP3_FRAME_SIZE_SEC;
#DEFINE NUM_CHANNELS = 2;
#DEFINE WAVE_BYTES_PER_SAMPLE = 2; // 16bit,  8 bits per byte -> 2 bytes
#DEFINE WAVE_BYTES_PER_SECOND_PER_CHANNEL = SAMPLE_RATE * WAVE_BYTES_PER_SAMPLE;
#DEFINE STEREO_WAVE_BYTES_PER_SECOND = WAVE_BYTES_PER_SECOND_PER_CHANNEL * NUM_CHANNELS;

// turntables
#DEFINE MAX_TURNTABLES = 2;

// data structures
typedef AUDIO_BYTES_PTR void*;

typedef struct BufferRingType
{
	AUDIO_BYTES_PTR buffer;
	int sizeOfBuffer;
	AUDIO_BYTES_PTR currentReadPointer;
	int sizeAvailableInBuffer;
} BufferRingStruct;


typedef struct TurntableStructType
{
	BufferRingStruct mp3DecodeBuffer;
	BufferRingStruct outBuffer;
} TurntableAudioStruct;



