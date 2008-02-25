/*
 *  DSPRoutines.c
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/23/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "DSPRoutines.h"

/*
	Takes in audio and compresses/expands in time to the desired number of bytes
	-> example pitchShift(srcStream, WAVE_BYTES_PER_MSEC / 2 * 50, dstStream, WAVE_BYTES_PER_MSEC / 2 * 20);
			read in 50msec of audio from srcStream, and interpolate it down to 20msec, which you write to dstStream
			reads 50 * WAVE_BYTES_PER_MSEC = 8820 bytes, which is 4410 bytes per channel
			writes 20 * WAVE_BYTES_PER_MSEC = 3528 bytes, which is 1764 bytes per channel
*/
 
void pitchShift(AUDIO_SHORTS_PTR src, int numShortsIn, AUDIO_SHORTS_PTR dst, int numShortsOut)
{
	// dummy code
	for ( int i = 0; i < numShortsOut; i++)
		*(dst + i) = *(src + i % numShortsIn);
}

// Takes a set of EQ bands + srcStream, does FFT, adjusts bands, deFFTS and write out to dstStream
void performEQ(Eq_t eq, AUDIO_SHORTS_PTR srcStream, AUDIO_SHORTS_PTR dstStream, int numShorts)
{
	for ( int i = 0; i < numShorts; i++)
		*(dstStream + i) = *(srcStream + i);
}
