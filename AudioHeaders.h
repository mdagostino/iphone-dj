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
#define AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER // needed for AudioQueue
#import "AudioQueue.h"

// iDJ
#import "AudioRoutines.h"
#import "AudioStructures.h"
#import "DSPRoutines.h"
#import "AudioSourceProtocol.h"
#import "AudioChainProtocol.h"
#import "AudioQueueSink.h"
#import "AudioNoiseSource.h"
#import "AudioWhiteNoiseSource.h"
#import "AudioSineWaveSource.h"
#import "AudioCompositor.h"
#import "MasterAudioController.h"