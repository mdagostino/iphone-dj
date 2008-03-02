//
//  AudioWaveSource.h
//  iDJ
//
//  Created by Aaron Zinman on 2/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//



#import "AudioHeaders.h"


@interface AudioWaveSource : NSObject <AudioSource, AudioSeekable>
{
	char *mm;
	int fileSizeInBytes;
	AUDIO_SHORTS_PTR buffer;
	AUDIO_SHORTS_PTR bufferStart;
	AUDIO_SHORTS_PTR bufferEnd;
	float bufferSizeInMsec;
	unsigned int bufferSizeInBytes;
	int fileHandler;
}

- (id) initWithFilePath:(char *)filePath;
- (AUDIO_SHORTS_PTR) getAudio:(float) msec;
- (void) seekRelative:(float) relativeMsec;
- (void) seekAbsolute:(float) absMsec;

@end
