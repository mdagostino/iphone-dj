//
//  AudioWaveSource.m
//  iDJ
//
//  Created by Aaron Zinman on 2/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

// standard stuff (why rewrite the wheel?), code taken from http://www.cs.usfca.edu/~cruse/cs686f05/pcmplay.cpp


#import "AudioWaveSource.h"
#include <stdio.h>	// for fprintf(), perror() 
#include <fcntl.h>	// for open() 
#include <math.h>	// for abs() 	
#include <stdlib.h>	// for exit() 
#include <unistd.h>	// for read(), write(), close() 
#include <string.h>	// for strncmp()
#include <sys/mman.h>	// for mmap()
#include <sys/ioctl.h>	// for ioctl()



typedef struct waveInfo
{
	int		fileSizeInBytes;
	char *	filePtr;
	char *	fmtPtr;
	char *	dataPtr;
	short	formatTag;
	short	nChannels;
	int		samplesPerSec;
	int		avBytesPerSec;
	short	blockAlignmnt;
	short	bitsPerSample;
	int		chunkSize;
} waveInfo_t;

BOOL mmapFile(int fileHandler, waveInfo_t* wave)
{
	wave->fileSizeInBytes = lseek( fileHandler, 0, SEEK_END );
	wave->filePtr = (char *) mmap( NULL, wave->fileSizeInBytes, PROT_READ, MAP_SHARED, fileHandler, 0 );
	if ( wave->filePtr == MAP_FAILED ) 
		return NO;

	return YES;
}

BOOL findDataPointer(waveInfo_t* wave)
{
	int	morebytes = wave->fileSizeInBytes - 12;
	wave->dataPtr = wave->fmtPtr + 8 + wave->chunkSize;
	wave->chunkSize = *(int*)(wave->dataPtr + 4 );
	while ( morebytes > 0 )
	{
		if ( strncmp( wave->dataPtr, "data", 4 ) == 0 ) break;
		wave->dataPtr += 8 + wave->chunkSize;
		morebytes -= 8 + wave->chunkSize;
	}
	
	wave->dataPtr += 8;	// point past the chunk-header to the chunk-data
	if ( morebytes < 8 ) 
		return NO; 
	else
		return YES;
}

BOOL readAndSetWaveInfo(waveInfo_t* wave)
{
	wave->fmtPtr = wave->filePtr + 12;
	int	chunkSize = *(int*)(wave->fmtPtr + 4);
	if ( strncmp( wave->fmtPtr, "fmt ", 4 ) ) 
	{
//		char *k = malloc(5 * sizeof ( char ));
//		strncpy(k,wave->fmtPtr, 4); 
//		NSLog(@"instead found %s", k);
		return NO;
	}
	
	wave->formatTag = *(short*)(wave->fmtPtr+8);
	wave->nChannels = *(short*)(wave->fmtPtr+10);
	wave->samplesPerSec = *(int*)(wave->fmtPtr+12);
	wave->avBytesPerSec = *(int*)(wave->fmtPtr+16);
	wave->blockAlignmnt = *(int*)(wave->fmtPtr+20);
	wave->bitsPerSample = *(int*)(wave->fmtPtr+22);
	wave->chunkSize = chunkSize;
	
	return YES;
}

@implementation AudioWaveSource


- (id) initWithFilePath:(char *)filePath
{
	if ( self = [super init] )
	{
		waveInfo_t waveInfo;
		fileHandler = open( filePath, O_RDONLY );
		if ( fileHandler < 0 ) 
		{ 
			perror( filePath ); 
			NSLog(@"Couldn't open file, byeybye");
			return nil;
		}

		if ( ! mmapFile(fileHandler, &waveInfo) )
		{
			NSLog(@"oh noes! mmap failed, barfing" ); 
			return nil;
		}
		else
			NSLog(@"mmaped in %d bytes at address %x", waveInfo.fileSizeInBytes, waveInfo.filePtr);
		
		mm = waveInfo.filePtr;
		fileSizeInBytes = waveInfo.fileSizeInBytes;

		// extract the audio playback parameters
		if ( ! readAndSetWaveInfo(&waveInfo) )
		{
			NSLog(@"format-chunk not found");
			return nil;
		}
		
		if ( waveInfo.formatTag != 1 || 
			waveInfo.chunkSize != WAVE_BITS || 
			waveInfo.nChannels != NUM_CHANNELS || 
			waveInfo.samplesPerSec != SAMPLE_RATE )
		{ 
			NSLog(@"unsupported format: formatTag:%d chunkSize:%d nChannels: %d samplesPerSec: %d", waveInfo.formatTag, waveInfo.chunkSize, waveInfo.nChannels, waveInfo.samplesPerSec); 
			return nil;
		}

		// locate the DATA chunk and its waveform data
		if ( ! findDataPointer(&waveInfo) )
		{
			NSLog(@"data-chunk not found\n" ); 
			return nil;
		}

		buffer = (AUDIO_SHORTS_PTR) waveInfo.dataPtr;
		bufferSizeInBytes = waveInfo.chunkSize;
		bufferSizeInMsec = bufferSizeInBytes * 1000.0 / waveInfo.avBytesPerSec;
		bufferStart = (AUDIO_SHORTS_PTR) waveInfo.dataPtr;
		bufferEnd = (AUDIO_SHORTS_PTR) (waveInfo.dataPtr + bufferSizeInBytes);
	}
	
	return self;
}

- (AUDIO_SHORTS_PTR) getAudio:(int) msec
{
	[self seekRelative:msec];
	return buffer;
}


- (void) seekRelative:(int) relativeMsec
{
	int bytesNeeded = framesToBytes(msecToFrames(abs(relativeMsec)));

	if ( relativeMsec < 0 )
	{
		AUDIO_SHORTS_PTR requested = (AUDIO_SHORTS_PTR) ((char *)buffer - bytesNeeded);
		if (  requested  < bufferStart )
		{
			buffer = bufferStart;
			@throw [EOFException hitStart];
		}
		else
			buffer = requested;
	}
	else
	{
		AUDIO_SHORTS_PTR requested = (AUDIO_SHORTS_PTR) ((char *)buffer + bytesNeeded);
		if ( requested > bufferEnd )
		{
			buffer = bufferEnd;
			@throw [EOFException hitEnd];
		}
		else
			buffer = requested;
	}
}

- (void) seekAbsolute:(unsigned int) absMsec
{
	if ( absMsec > bufferSizeInMsec )
	{
		buffer = bufferStart;
		NSException *e = [EOFException
			exceptionWithName: @"EOFException"
			reason: @"hitEnd"
			userInfo: nil];
		@throw e;
	}

	int byteOffset = framesToBytes(msecToFrames(absMsec));
	buffer = (AUDIO_SHORTS_PTR) ( (char *)buffer + byteOffset );
}

- (void ) dealloc
{
	if ( munmap(mm, fileSizeInBytes) < 0 )
		NSLog(@"Couldn't unmap mm of %d bytes at address 0x%x: %s", bufferSizeInBytes, mm, strerror(errno));

	[super dealloc];
}

@end

