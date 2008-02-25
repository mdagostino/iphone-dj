/*
 *  AudioStructures.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/23/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


#define NYQUIST 2

// audio_queue thread
//#define AUDIO_QUEUE_KERNEL_THREAD_OUTPUT_MSEC_RATE 10 // output 10msec worth of frames at a time
//
// turntable_thread
//#define TURNTABLE_THREAD_PROCESS_MSEC_RATE NYQUIST * AUDIO_QUEUE_KERNEL_THREAD_OUTPUT_MSEC_RATE // PROCESS 20msec worth of frames at a time

// file reader thread
#define MAX_READ_AHEAD_SECONDS 10

// audio constants
#define SAMPLE_RATE 44100
#define MP3_SAMPLES_PER_FRAME 1152
#define MP3_FRAME_SIZE_SEC MP3_SAMPLES_PER_FRAME / SAMPLE_RATE
#define MP3_FRAMES_PER_SECOND 1 / MP3_FRAME_SIZE_SEC
#define NUM_CHANNELS 2
#define WAVE_BYTES_PER_SAMPLE 2 // 16bit,  8 bits per byte -> 2 bytes
#define WAVE_SHORTS_PER_SAMPLE 1
#define WAVE_BYTES_PER_SECOND_PER_CHANNEL SAMPLE_RATE * WAVE_BYTES_PER_SAMPLE
#define WAVE_SHORTS_PER_SECOND_PER_CHANNEL SAMPLE_RATE * WAVE_SHORTS_PER_SAMPLE
#define STEREO_WAVE_BYTES_PER_SECOND WAVE_BYTES_PER_SECOND_PER_CHANNEL * NUM_CHANNELS
#define STEREO_WAVE_SHORTS_PER_SECOND WAVE_SHORTS_PER_SECOND_PER_CHANNEL * NUM_CHANNELS


#define SIGNED_SHORT_MAX_POS ((1 << 15) - 1)
#define SIGNED_SHORT_MAX_NEG (-(1 << 15))

// turntables
//#define MAX_TURNTABLES 2

// data structures
typedef short* AUDIO_SHORTS_PTR;

//typedef struct BufferRingType
//{
//	AUDIO_SHORTS_PTR buffer;
//	int sizeOfBuffer;
//	AUDIO_SHORTS_PTR currentReadPointer;
//	int sizeAvailableInBuffer;
//} BufferRingStruct;
//
//
//typedef struct TurntableStructType
//{
//	BufferRingStruct mp3DecodeBuffer;
//	BufferRingStruct outBuffer;
//	float mainsVolume;
//	float cueVolume;
//} TurntableAudioStruct;
