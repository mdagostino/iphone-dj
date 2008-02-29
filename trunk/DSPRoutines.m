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

#define MODE_BOXFILTER 1
#define MODE_BILINEARINTERP 2

int interpMode=MODE_BOXFILTER;

// interleaved L R L R data 
// numShorts* will always be even
void pitchShift(AUDIO_SHORTS_PTR src, int numShortsIn, AUDIO_SHORTS_PTR dst, int numShortsOut)
{
  int srcIdx;
  float srcIdx_f,mantissa;

  // e.g.  ratio = 1.5 = 150%.  generate 1000 samples from 1500 samples
  float ratio = (float) numShortsIn / (float) numShortsOut;

  for ( int i = 0; i < numShortsOut; i+=2)
  {

    // MODE_BOXFILTER uses less CPU, but sound quality is crappier
    // MODE_BILINEARINTERP uses more CPU and sound quality is better
    switch(interpMode)
    {


    case MODE_BOXFILTER:

      srcIdx  = i>>1;
      srcIdx  = srcIdx*ratio;
      *( dst + i     ) = *(src+srcIdx*2  );   // left channel
      *( dst + i + 1 ) = *(src+srcIdx*2+1);   // right channel

      break;



      // l0 r0 l1 r1 l2 r2 l3 r3
      //  0  1  2  3  4  5  6  7
      //  e.g. ratio = 1.23 = 123%
    case MODE_BILINEAR_INTERP:        //  e.g. 212

      srcIdx    = i>>1;               //       106
      srcIdx    = srcIdx*ratio;       //       130
      srcIdx_f  = srcIdx*ratio;       //       130.38
      mantissa  = srcIdx_f - srcIdx;  //          .38

      *( dst + i     ) =  (1-mantissa) * (src+srcIdx*2    ) + (mantissa) * (src+srcIdx*2 + 2)  ;   // left channel
      *( dst + i + 1 ) =  (1-mantissa) * (src+srcIdx*2 + 1) + (mantissa) * (src+srcIdx*2 + 3)  ;   // right channel

      break;

  }
}

// Takes a set of EQ bands + srcStream, perform EQ
void performEQ(Eq_t eq, AUDIO_SHORTS_PTR srcStream, AUDIO_SHORTS_PTR dstStream, int numShorts)
{
  for ( int i = 0; i < numShorts; i++)
  {
    
    // *(dstStream + i) = *(srcStream + i);


  }
}
