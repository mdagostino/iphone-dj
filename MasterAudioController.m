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
 
 */


#import "MasterAudioController.h"


// VOLUME/CUE RELATED VARIABLES
static BOOL outputOnlyMains = FALSE;
static BOOL cueIndependentVolume = FALSE;
static float totalMainsVolume = 1.0;
static float totalCueVolume = 1.0;

// VOLUME/CUE RELATED FUNCTIONS.  ANYTHING CAN CALL THESE TO MANIPULATE VOLUME LEVELS
// BECAUSE EVERYTHING IS DONE ON THE FLY, WE ONLY NEED TO MANIPULATE A VARIABLE FOR THE NEXT MIX TO GO OUT TO THE SOUND CARD
void setCueEnabledMode() { outputOnlyMains = FALSE; }
void setMainsOnlyMode() { outputOnlyMains = TRUE; }
void setCueIndependentMix() { cueIndependentVolume = TRUE; }
void setCueMainsMix() { cueIndependentVolume = FALSE; }

// VOLUME RANGE IS 0-1
void setMainsVolume(float volume) { totalMainsVolume = volume; }
void setTotalCueVolume(float volume) { totalCueVolume = volume; }



static AudioQueueSink* aqSink;

void setupAudioChain()
{
	aqSink = [[AudioQueueSink alloc] init];

	AudioNoiseSource *noiseGen = [[AudioNoiseSource alloc] init];
	AudioWhiteNoiseSource *wnoiseGen = [[AudioWhiteNoiseSource alloc] init];
	// combined produces DTMF 1
	AudioSineWaveSource *sinGen = [[AudioSineWaveSource alloc] initWithFrequency:1209];
	AudioSineWaveSource *sinGenB = [[AudioSineWaveSource alloc] initWithFrequency:697];


	AudioWaveSource *waveSource = [[AudioWaveSource alloc] initWithFilePath:"/file1.wav"];
	AudioWaveSource *waveSource2 = [[AudioWaveSource alloc] initWithFilePath:"/file2.wav"];
	AudioEOFProtectingSource *eofWave1 = [[AudioEOFProtectingSource alloc] initWithUnprotectedSource:waveSource];
	AudioEOFProtectingSource *eofWave2 = [[AudioEOFProtectingSource alloc] initWithUnprotectedSource:waveSource2];


//	AudioCompositor *composite = [[AudioCompositor alloc] initWithSourceA:sinGen andSourceB:sinGenB];
//	AudioCompositor *composite = [[AudioCompositor alloc] initWithSourceA:eofWave1 andSourceB:eofWave2];


	AudioPitchFilter *pitchFilter = [[AudioPitchFilter alloc] init];
	[pitchFilter setSource:eofWave1];
	[pitchFilter setSpeedRelativeToOne:0.5];


	AudioPitchFilter *pitchFilter2 = [[AudioPitchFilter alloc] init];
	[pitchFilter2 setSource:eofWave2];
	[pitchFilter2 setSpeedRelativeToOne:2.0];
	AudioCompositor *composite = [[AudioCompositor alloc] initWithSourceA:pitchFilter andSourceB:pitchFilter2];


//	[aqSink setSource:noiseGen];
//	[aqSink setSource:wnoiseGen];
//	[aqSink setSource:sinGenB];
//	[aqSink setSource:composite];
//	[aqSink setSource:eofWave];
	[aqSink setSource:pitchFilter];

	[noiseGen release];
	[wnoiseGen release];
	[sinGen release];
	[sinGenB release];
	[waveSource release];
	[eofWave1 release];
	[eofWave2 release];
	[pitchFilter release];
	[pitchFilter2 release];
	[composite release];
	
	NSLog(@"setupAudioChain complete");
}

void startAudio()
{
	[aqSink start];
}

void pauseAudio()
{
	[aqSink pause];
}

void stopAudio()
{
	[aqSink stop];
}
