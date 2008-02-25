/*
 *  DSPRoutines.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/23/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


#import "AudioHeaders.h"


typedef struct EqBand_struct
{
	int lowerFreqInHz;
	int higherFreqInHz;
} EqBand_t;
typedef struct Eq_struct
{
	EqBand_t* bands;
	int numBands;
} Eq_t;


/*
	Takes in audio and compresses/expands in time to the desired number of bytes
	-> example pitchShift(srcStream, WAVE_BYTES_PER_MSEC * 50, dstStream, WAVE_BYTES_PER_MSEC * 20);
			read in 50msec of audio from srcStream, and interpolate it down to 20msec, which you write to dstStream
			reads 50 * WAVE_BYTES_PER_MSEC = 8820 bytes, which is 4410 bytes per channel
			writes 20 * WAVE_BYTES_PER_MSEC = 3528 bytes, which is 1764 bytes per channel
*/
 
void pitchShift(AUDIO_SHORTS_PTR src, int numBytesIn, AUDIO_SHORTS_PTR dst, int numBytesOut);

// Takes a set of EQ bands + srcStream, does FFT, adjusts bands, deFFTS and write out to dstStream
void performEQ(Eq_t eq, AUDIO_SHORTS_PTR srcStream, AUDIO_SHORTS_PTR dstStream, int numBytes);
