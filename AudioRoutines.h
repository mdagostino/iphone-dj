/*
 *  AudioRoutines.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/24/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#import "AudioHeaders.h"

float framesToMsec(int numFrames);
int msecToFrames(float mSec);
int framesToBytes(int numFrames);
int framesToShorts(int numFrames);
