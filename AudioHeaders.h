/*
 *  AudioHeaders.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/24/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

// OS
#import <UIKit/UIKit.h> //gives us NSObject, etc
#include <stdlib.h> //malloc, random
#include <strings.h> //bzero
#include <math.h>
#define AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER // needed for AudioQueue
#import "AudioQueue.h"

// iDJ
#import "EOFException.h"
#import "AudioStructures.h"
#import "AudioRoutines.h"
#import "DSPRoutines.h"

#import "AudioSourceProtocol.h"
#import "AudioChainProtocol.h"
#import "AudioSeekProtocol.h"
#import "AudioQueueSink.h"

#import "AudioSilenceSource.h"
#import "AudioEOFProtectingSource.h"
#import "AudioNoiseSource.h"
#import "AudioWhiteNoiseSource.h"
#import "AudioSineWaveSource.h"
#import "AudioWaveSource.h"

#import "AudioPitchFilter.h"
#import "AudioCompositor.h"

#import "MasterAudioController.h"
