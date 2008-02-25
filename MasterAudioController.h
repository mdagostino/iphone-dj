/*
 *  MasterAudioController.h
 *  iphonedj
 *
 *  Created by Aaron Zinman on 10/21/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#import "AudioHeaders.h"

void setupAudioChain();
void startAudio();
void pauseAudio();
void stopAudio();

// FOR SPLITTING/TOGGLING CUE
void setCueEnabledMode();
void setCueIndependentMix();
void setCueMainsMix();
void setMainsOnlyMode();

// VOLUME RANGE IS 0-1
void setMainsVolume(float volume);

// VOLUME RANGE IS 0-1
void setTotalCueVolume(float volume);
