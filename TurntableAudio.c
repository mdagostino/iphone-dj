//
//  TurntableAudio.m
//  iphonedj
//
//  Created by Aaron Zinman on 10/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TurntableAudio.h"


float timeReadAheadRateInSeconds = 5.0;
time_t audioQueueKernelLastTick;
TurntableAudioStruct turntables[MAX_TURNTABLES];
int numTurntables = 0;


TurntableAudioStruct getNewTurntable()
{
	TurntableAudioStruct turntable;
	
	turntable.mp3DecodeBuffer.buffer = calloc(NYQUIST, MAX_READ_AHEAD_SECONDS * STEREO_WAVE_BYTES_PER_SECOND);
	if ( turntable.mp3DecodeBuffer.buffer == NULL )
	{
		printf("barf! couldn't allocate basic read ahead memory");
		exit(1);
	}
	turntable.mp3DecodeBuffer.sizeOfBuffer = NYQUIST * MAX_READ_AHEAD_SECONDS * STEREO_WAVE_BYTES_PER_SECOND;
	turntable.mp3DecodeBuffer.currentReadPointer = turntable.mp3DecodeBuffer.buffer;
	turntable.mp3DecodeBuffer.sizeAvailableInBuffer = 0;
	
	turntable.outBuffer.buffer = calloc(NYQUIST, TURNTABLE_THREAD_PROCESS_MSEC_RATE * STEREO_WAVE_BYTES_PER_SECOND / 1000);
	{
		printf("barf! couldn't allocate outBuffer memory");
		exit(1);
	}
	turntable.outBuffer.sizeOfBuffer = NYQUIST * TURNTABLE_THREAD_PROCESS_MSEC_RATE * STEREO_WAVE_BYTES_PER_SECOND / 1000;
	turntable.outBuffer.currentReadPointer = turntable.outBuffer.buffer;
	turntable.outBuffer.sizeAvailableInBuffer = 0;
	
	return turntable;
}

void initTurntables()
{
	turntables[0] = getNewTurntable();
	turntables[1] = getNewTurntable();
	numTurntables = 2;
}
