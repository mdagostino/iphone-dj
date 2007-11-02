/*
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 
 version 0.9
 works with debugging-like prebuffering, lots of NSLog's, and not-so-smart dual-threaded mechanism
  
 Aaron Zinman - azinman@media.mit.edu
 Noah Vawter - nvawter@media.mit.edu
 
 Sept 2007

 
 */

#include <string.h>
#include <stdio.h>
#include <pthread.h>
#include <sys/select.h>
#include "mad.h"

#import <UIKit/UIKit.h>
#import <Foundation/NSLock.h>
#import "AudioQueue.h"

#include "audio.h"

static audio_pcmfunc_t *audio_pcm;

/* Audio Resources */
#define AUDIO_BUFFERS 3
#define MP3_FRAME_SIZE 1152
#define MP3_FRAME_SIZE_BYTES (1152 * 4)
#define CYCLES_PER_MP3_READ 20
#define WAVE_BUFFER_SIZE (MP3_FRAME_SIZE_BYTES * 2 * CYCLES_PER_MP3_READ * 2) 

static int cycles = 0;

typedef struct AQCallbackStruct {
    AudioQueueRef queue;
    UInt32 frameCount;
    AudioQueueBufferRef mBuffers[AUDIO_BUFFERS];
    AudioStreamBasicDescription mDataFormat;
} AQCallbackStruct;


extern float __audioVolume;

static AQCallbackStruct in;
//static int waveBuffer[WAVE_BUFFER_SIZE * WAVE_BUFFER_BANKS];
//static long waveBufferSize = WAVE_BUFFER_SIZE * WAVE_BUFFER_BANKS;
static long writeIdx,playIdx;
static int waveBuffer[WAVE_BUFFER_SIZE];

static int waveBufferWriteIdxEnd;

#define BUFF_AVAIL 1
#define BUFF_FLUSHED 0
static NSConditionLock *renderSyncLock;   // used to stop madplay from rendering sooooo much data

static int weHaveTheLock=FALSE;


// OS callback to get sound from app buffers/pre-rendered
static void AQBufferCallback( void *in, AudioQueueRef inQ, AudioQueueBufferRef outQB)
{
	if( weHaveTheLock==FALSE )
	{
		NSLog(@"pre AQBufCallback wanting lockWhenCond:BUFF_AVAIL");
		[renderSyncLock lockWhenCondition:BUFF_AVAIL];
		weHaveTheLock=TRUE;
		NSLog(@"post AQBufCallback got lockWhenCond:BUFF_AVAIL");
	}
	else 
	{
		NSLog(@"AQBufCallback we have lock already");
	}
	
    AQCallbackStruct * inData;
    short *coreAudioBuffer;
	
    float volume = 255.0;
    int i;
	
    static int Count=100;
    if((++Count)>=1){NSLog(@"AQBufferCallback");Count=0;}
    
    volume=1;  // debug override.  no volume yet
	
    inData = (AQCallbackStruct *)in;
    coreAudioBuffer = (short*) outQB->mAudioData;
	
    if (inData->frameCount > 0) {
		NSLog(@"AQBufferCallback wants %d frames", inData->frameCount);
        outQB->mAudioDataByteSize = 4*inData->frameCount;
		
		
		// each frame is 2 waveBuffer instances (LR LR LR LR LR, etc)
		for(i=0;i<inData->frameCount*2;i++) {
			
			// playidx check - is it at the end of the written buffer
			if(playIdx == waveBufferWriteIdxEnd)
			{ 
				NSLog(@"playidx == wavebufferwriteidxend @%d", waveBufferWriteIdxEnd);
				
				NSLog(@"pre AQBufCallback unlockWithCond:BUFF_FLUSHED");
				[ renderSyncLock unlockWithCondition:BUFF_FLUSHED ];
				weHaveTheLock=FALSE;
				NSLog(@"middle");
				[ renderSyncLock lockWhenCondition:BUFF_AVAIL ];
				NSLog(@"post AQBufCallback lockWhenCond:BUF_AVAIL, waveBufferWriteIdxEnd =%d", waveBufferWriteIdxEnd);
				weHaveTheLock=TRUE;
			}

			// dest = iphone AQ   //   writing signed shorts
			//coreAudioBuffer[i  ] = i*382;  // noisegen
			coreAudioBuffer[i  ] = (waveBuffer[playIdx++] );  // source  from iphone/EMU
			if (playIdx == WAVE_BUFFER_SIZE)               
			{
				playIdx = 0;
				NSLog(@"AQBufferCallback looping around waveBuffer");
			}
        }

		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
    }
	else
		NSLog(@"AQBufferCallback inData requested 0 frames");
}


static void AQ_PreQueueBuffer( void *in, AudioQueueRef inQ, AudioQueueBufferRef outQB)
{
    AQCallbackStruct * inData;
    short *coreAudioBuffer;
	NSLog(@"AQ_PreQueueBuffer start");
	
    inData = (AQCallbackStruct *)in;
    coreAudioBuffer = (short*) outQB->mAudioData;
	
    if (inData->frameCount > 0) {
		NSLog(@"prequeuebuffering %d frames", inData->frameCount);
        outQB->mAudioDataByteSize = 4*inData->frameCount;
		
		int i;
		for(i=0;i<inData->frameCount*2;i++)
		{
			// prequeue noise
			coreAudioBuffer[i  ] = i * 6;// (waveBuffer[playIdx++] );  
        }
		
		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
	}
	else
		NSLog(@"prequeuebuffer didnt have any frames");
}



static void initAQAudio()
{
	// need for our non-cocoa app using cocoa stuff
	[NSRunLoop currentRunLoop];
	
	/* Pre-buffer before we turn on audio */
	UInt32 err;
	err = AudioQueueNewOutput(&in.mDataFormat,
							  AQBufferCallback,
							  &in,
							  NULL,
							  kCFRunLoopCommonModes,
							  0,
							  &in.queue);
	if (err) NSLog(@"AudioQueueNewOutput err %d\n", err);
	
	NSLog(@"AudioQueueNewOutput success\n");
	
//	in.frameCount = WAVE_BUFFER_SIZE;
//	in.frameCount = MP3_FRAME_SIZE * 2;

	in.frameCount = MP3_FRAME_SIZE * CYCLES_PER_MP3_READ;


	UInt32 bufferBytes = in.frameCount * in.mDataFormat.mBytesPerFrame;
	
	int i;
	for (i=0; i<AUDIO_BUFFERS; i++) {
        err = AudioQueueAllocateBuffer(in.queue, bufferBytes, &in.mBuffers[i]);
        if (err) NSLog(@"AudioQueueAllocateBuffer[%d] err %d\n",i, err);
        /* "Prime" by calling the callback once per buffer */
		NSLog(@"pre aqbuffercallback %d\n",i);
		AQ_PreQueueBuffer (&in, in.queue, in.mBuffers[i]);
		NSLog(@"post aqbuffercallback %d\n",i);
	}
	
	
	NSLog(@" pre AudioQueueStart");
	err = AudioQueueStart(in.queue, NULL);
	if (err) NSLog(@"AudioQueueStart err %d\n", err);
}


/// once began audio_carbon.c


static int init(struct audio_init *init)
{
	
    double sampleRate = 44100.0;
	
    NSLog(@"init()");
    memset(&waveBuffer, 0, sizeof(waveBuffer));
	
	
    renderSyncLock = [[NSConditionLock alloc] initWithCondition:BUFF_FLUSHED];
    
	cycles = 0;
    waveBufferWriteIdxEnd = 0;
    writeIdx = 0;
    playIdx = 0;
	
    in.mDataFormat.mSampleRate = sampleRate;
    in.mDataFormat.mFormatID = kAudioFormatLinearPCM;
    in.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger
		| kAudioFormatFlagIsPacked;
    in.mDataFormat.mBytesPerPacket = 4;
    in.mDataFormat.mFramesPerPacket = 1;
    in.mDataFormat.mBytesPerFrame = 4;
    in.mDataFormat.mChannelsPerFrame = 2;
    in.mDataFormat.mBitsPerChannel = 16;
	
    
    NSLog(@"preAutorelease pool)");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"post autorelease pool");
	
    // init the audio
    initAQAudio();
    NSLog(@"returned from initAQAudio");
	
	return 0;
}

static int config(struct audio_config *config)
{
	
	NSLog(@"config");
	
	audio_pcm = audio_pcm_s16le;
	
	/* wtf?
		bitdepth = config->precision & ~7;
	if (bitdepth == 0 || bitdepth > 16)
		audio_pcm = audio_pcm_s16be;
    bitdepth = 16;
	
	
	switch (config->precision = bitdepth) {
		case 8:
			NSLog(@"audio_pcm_u8");
			break;
			
		case 16:
			NSLog(@"audio_pcm_s16be");
			break;
	}
	*/
	
	//config_channels  = config->channels;
	//config_speed     = config->speed;
	//config_precision = config->precision;
	
	return 0;
}


unsigned char data[MAX_NSAMPLES * 4 * 2];  // N samples * sizeof(int) * 2 ch. stereo



static
int play(struct audio_play *play)
{
  static int Count=100;
  short *dataS=(short*)data;  // short pointer to same data
  unsigned int i,lenInBytes;

  // wait here for 
  if ( cycles == 0 )
  {
    if((++Count)>=1){Count=0;NSLog(@"play");}
    
    NSLog(@"before play() looking for lock with condition BUFF_FLUSHED");
    [ renderSyncLock lockWhenCondition:BUFF_FLUSHED ];
    NSLog(@"after play() got lock: BUFF_FLUSHED");
  }
	
	
  // libmad function to xlate mad data (freshly decoded) into pcm format    
  // leave result in "data" 
  lenInBytes = audio_pcm(data, play->nsamples, play->samples[0], play->samples[1],
			 play->mode, play->stats);
  


  // copy data from libmad buffer into iphone/AQ OS buffer
  unsigned int lenInShorts = lenInBytes/2;
  for (i = 0; i < lenInShorts; i++)
  {
    waveBuffer[writeIdx++] =  dataS[i];  // write shorts to waveBufer 
    if (writeIdx == WAVE_BUFFER_SIZE)
    {
      NSLog(@"play looping while writing in ringbuffer");
      writeIdx = 0;
    }
  }
  
  waveBufferWriteIdxEnd=writeIdx;
  
  cycles++;
  if ( cycles == CYCLES_PER_MP3_READ )
  {
    cycles = 0;
    NSLog(@"done decoding mp3s out, writeIdx = %d", writeIdx);
    NSLog(@"pre play() unlockw/Cond");
    [ renderSyncLock unlockWithCondition:BUFF_AVAIL ];
    NSLog(@"post play() unlockw/Cond: BUFF_AVAIL");
  }

  //    [NSThread detachNewThreadSelector:@selector(MyThreadRoutine:) toTarget:[AQ_Thingy class] withObject:nil];
  return(0);
}





static
int stop(struct audio_stop *stop)
{
	int result=0;
	
	NSLog(@"called stop() from audio_iphone.c");
	
	return result;
}





static
int finish(struct audio_finish *finish)
{
	int result = 0;
	
	NSLog(@"AQ_Callback_CloseSound.AudioQueueDispose()");
	AudioQueueDispose(in.queue, true);
	NSLog(@"AQ_Callback_CloseSound.AudioQueueDispose() 2");
	
	return result;
}


// * * * *!* ! ! : :) :) :) 

int audio_iphone(union audio_control *control)
{
	audio_error = 0;
	
	switch (control->command) {
		case AUDIO_COMMAND_INIT:
			return init(&control->init);
			
		case AUDIO_COMMAND_CONFIG:
			return config(&control->config);
			
		case AUDIO_COMMAND_PLAY:
			return play(&control->play);
			
		case AUDIO_COMMAND_STOP:
			return stop(&control->stop);
			
		case AUDIO_COMMAND_FINISH:
			return finish(&control->finish);
	}
	
	return 0;
}
