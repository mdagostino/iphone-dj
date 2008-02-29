/*
 *  AudioRoutines.c
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/24/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "AudioRoutines.h"
#include <math.h>

inline int framesToMsec(int numFrames)
{
//	static float framesPerMSec = SAMPLE_RATE / 1000.0;
	static float msecPerFrame = 1.0 / (SAMPLE_RATE / 1000.0);//framesPerMSec;
	
	float mSec = msecPerFrame * numFrames;
	if ( mSec - floorf(mSec) > 0.001 )
	{
		NSLog(@"ERROR: got a non-integer amount of msec: %f for %d frames", mSec, numFrames);
		exit(-1);
	}
	
	return mSec;
}

inline int msecToFrames(int mSec)
{
	static float framesPerMSec = SAMPLE_RATE / 1000.0;
	
	float frames = framesPerMSec * mSec;
	if ( frames - floorf(frames) > 0 )
	{
		NSLog(@"ERROR: got a non-integer amount of frames: %f", frames);
		exit(-1);
	}
	
	return frames;
}

inline int framesToBytes(int numFrames)
{
	return numFrames * WAVE_BYTES_PER_SAMPLE * NUM_CHANNELS;
}