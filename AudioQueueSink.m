//
//  AudioQueueSink.m
//  iDJ
//
//  Created by Aaron Zinman on 2/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioQueueSink.h"

#include <math.h>
#include <strings.h>
#import <Foundation/NSThread.h>
static AudioQueueSink* _sinkInstance = nil;
static id<AudioSource> source = nil;

@implementation AudioQueueSink

// OS callback to get sound from app buffers/pre-rendered
static void AQBufferCallback( void *inCallbackStruct, AudioQueueRef audioQueue, AudioQueueBufferRef outBuffer)
{
    static int hasStarted=0;
    if(hasStarted == 0) {
		if ( [NSThread isMainThread] )
		{
			NSLog(@"AQBufferCallback starting in main thread %@", [NSThread currentThread] );hasStarted=1;
		}
		else
		{
			[[NSThread currentThread] setName:@"AudioQueueThread"];
			NSLog(@"AQBufferCallback starting in thread %@", [NSThread currentThread] );hasStarted=1;
		}
	}

    AQCallbackStruct infoStruct = * (AQCallbackStruct *)inCallbackStruct;
    if (infoStruct.frameCount == 0)
	{
		NSLog(@"AQBufferCallback inData requested 0 frames for some reason");
		return;
	}
//	NSLog(@"AQBufferCallback wants %d frames", infoStruct.frameCount);

		
	// get the data through the audio chain!!
	short *dstAudioBuffer = (short*) outBuffer->mAudioData;
	// each frame is 2 channels 16-bit shorts, 4 bytes (2 shorts) total
	outBuffer->mAudioDataByteSize = infoStruct.mDataFormat.mBytesPerFrame * infoStruct.frameCount;

	if ( source == nil )
	{
		NSLog(@"source was nil, writing 0's");
		bzero(dstAudioBuffer, outBuffer->mAudioDataByteSize);
	}
	else
	{
		AUDIO_SHORTS_PTR givenAudio = [source getAudio: framesToMsec(infoStruct.frameCount) ];
		if ( givenAudio != NULL )
			memcpy(dstAudioBuffer, givenAudio, outBuffer->mAudioDataByteSize);
		else
		{
			bzero(dstAudioBuffer, outBuffer->mAudioDataByteSize);
			NSLog(@"AudioQueueSink: got null audio ptr!!!");
		}
	}
	
	AudioQueueEnqueueBuffer(audioQueue, outBuffer, 0, NULL);
}

-(void) setSource:(id<AudioSource>) newSource
{
	if ( source != nil )
	{
		NSLog(@"can only set AudioQueueSink source once");
		return;
	}
	
	source = [newSource retain];
	NSLog(@"AudioQueueSink setSource: %@", newSource);
}


-(void) pause
{
	UInt32 err = AudioQueuePause(in.queue);
	if (err) NSLog(@"AudioQueuePause err %d\n", err);
}

-(void) stop
{
	NSLog(@"stopping AQ");
	UInt32 err = AudioQueueStop (in.queue, true);
	if (err) { NSLog(@"AudioQueueStop err %d\n", err); return; }
	err = AudioQueueDispose(in.queue, true);
	if (err) { NSLog(@"AudioQueueDispose err %d\n", err); return; }
	NSLog(@"done stopping aq, disposed of buffers");
}

-(void) start
{
	NSLog(@"start audioqueuesink called from thread %@", [NSThread currentThread]);
	if ( source == nil )
	{
		NSLog(@"ERROR: call to start audioqueuesink without a source");
		return;
	}
	
	// setup our playback info
	in.mDataFormat.mSampleRate = SAMPLE_RATE;
	in.mDataFormat.mFormatID = kAudioFormatLinearPCM;
	in.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	in.mDataFormat.mChannelsPerFrame = NUM_CHANNELS;
	in.mDataFormat.mBitsPerChannel = WAVE_BYTES_PER_SAMPLE * 8;
	in.mDataFormat.mFramesPerPacket = 1;
	in.mDataFormat.mBytesPerPacket = in.mDataFormat.mChannelsPerFrame * sizeof (SInt16);
	in.mDataFormat.mBytesPerFrame = in.mDataFormat.mBytesPerPacket;
	
	// setup the output queue
	UInt32 err = AudioQueueNewOutput(&in.mDataFormat,
							  AQBufferCallback,
							  &in,
							  NULL,
							  kCFRunLoopCommonModes,
							  0,
							  &in.queue);
	if (err) { NSLog(@"AudioQueueNewOutput err %d\n", err); exit(1); }
	

	// buffer == 20 msec
//	in.frameCount = msecToFrames(20);
	in.frameCount = msecToFrames(1000);
	
	UInt32 bufferBytes = in.frameCount * in.mDataFormat.mBytesPerFrame;
	for (int i=0; i<AUDIO_BUFFERS; i++) {
        err = AudioQueueAllocateBuffer(in.queue, bufferBytes, &in.mBuffers[i]);
        if (err) { NSLog(@"AudioQueueAllocateBuffer[%d] err %d\n",i, err); exit(1); }
//        /* "Prime" by calling the callback once per buffer */
		NSLog(@"loading buffer %d with zeros",i);
//		AQ_PreQueueBuffer (&in, in.queue, in.mBuffers[i]);

		if (in.frameCount > 0) {
			NSLog(@"prequeuebuffering %d frames", in.frameCount);
			in.mBuffers[i]->mAudioDataByteSize = bufferBytes;
			
			short *coreAudioBuffer = (short*) in.mBuffers[i]->mAudioData;
			for(int i=0; i < in.frameCount; i++)
			{
				// silence
				coreAudioBuffer[i] = 0;
			}
			
			AudioQueueEnqueueBuffer(in.queue, in.mBuffers[i], 0, NULL);
		}
		else
			NSLog(@"prequeuebuffer didnt have any frames");



	}
	
	
	NSLog(@" pre AudioQueueStart");
	err = AudioQueueStart(in.queue, NULL);
	if (err) { NSLog(@"AudioQueueStart err %d\n", err); exit(1); }
}

-(id) init
{
	if ( _sinkInstance != nil )
	{
		NSLog(@"cannot instantiate more than 1 audioqueuesink");
		return nil;
	}
	
	if ( self = [super init ] )
	{
		NSLog(@"Initing audioQueueSink");
		source = nil;
		_sinkInstance = self;
//		cycles = 0;
//		waveBufferWriteIdxEnd = 0;
//		writeIdx = 0;
//		playIdx = 0;
	}
	
	return self;
}




//static
//int play(struct audio_play *play)
//{
//  static int Count=100;
//  short *dataS=(short*)data;  // short pointer to same data
//  unsigned int i,lenInBytes;
//
//  // wait here for 
//  if ( cycles == 0 )
//  {
//    if((++Count)>=1){Count=0;NSLog(@"play");}
//    
//    NSLog(@"before play() looking for lock with condition BUFF_FLUSHED");
//    [ renderSyncLock lockWhenCondition:BUFF_FLUSHED ];
//    NSLog(@"after play() got lock: BUFF_FLUSHED");
//  }
//	
//	
//  // libmad function to xlate mad data (freshly decoded) into pcm format    
//  // leave result in "data" 
//  lenInBytes = audio_pcm(data, play->nsamples, play->samples[0], play->samples[1],
//			 play->mode, play->stats);
//  
//
//
//  // copy data from libmad buffer into iphone/AQ OS buffer
//  unsigned int lenInShorts = lenInBytes/2;
//  for (i = 0; i < lenInShorts; i++)
//  {
//    waveBuffer[writeIdx++] =  dataS[i];  // write shorts to waveBufer 
//    if (writeIdx == WAVE_BUFFER_SIZE)
//    {
//      NSLog(@"play looping while writing in ringbuffer");
//      writeIdx = 0;
//    }
//  }
//  
//  waveBufferWriteIdxEnd=writeIdx;
//  
//  cycles++;
//  if ( cycles == CYCLES_PER_MP3_READ )
//  {
//    cycles = 0;
//    NSLog(@"done decoding mp3s out, writeIdx = %d", writeIdx);
//    NSLog(@"pre play() unlockw/Cond");
//    [ renderSyncLock unlockWithCondition:BUFF_AVAIL ];
//    NSLog(@"post play() unlockw/Cond: BUFF_AVAIL");
//  }
//
//  //    [NSThread detachNewThreadSelector:@selector(MyThreadRoutine:) toTarget:[AQ_Thingy class] withObject:nil];
//  return(0);
//}

@end
