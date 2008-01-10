enum
{
  PITCH_STRAIGHT=1,
  PITCH_TURNTABLE,
};


void ENTrack::decode(void)
{
  //char buf[100];

  madResults=mad_frame_decode(&frame, &stream);
  //  sprintf(buf,"%d  %d\n",madResults,stream.error);  strcat(dataCaps,buf);

  while( (madResults==-1) &&
         ((stream.error == MAD_ERROR_BUFLEN) || (stream.error == MAD_ERROR_BUFPTR))
         )
  {
    // Fill up the remainder of the file buffer.
    fillFileBuffer();
   
    // Give new buffer to the stream.
    mad_stream_buffer(&stream, fileBuffer, sizeof(fileBuffer));

    madResults=mad_frame_decode(&frame, &stream);
    //    sprintf(buf,"%d  %d\n",madResults,stream.error);strcat(dataCaps,buf);
  }

  // Synth the frame.
  mad_synth_frame(&synth, &frame);

  if(madResults==0){sampPlayCount+=synth.pcm.length;}
 
  //  char buf[100];
  //  sprintf(buf,"synth.pcm.length=%f,",sampPlayCount);
  //  quickString(buf,0,250,0xffff00ff,0);
  //  quickString(buf,0,250,0xffff00ff,0);
  //  waitForButtonPress(0);

  //  Kprintf("banana\n");
 
}






Kernel thread/application runLoop begins here!!!!!


   // the audio ISR
      static void fillOutputBuffer(void* buffer, unsigned int samplesToWrite, void* userData)
      {
        unsigned int i,tr=0;
        int stw;
        Sample* destination = static_cast<Sample*> (buffer);
        Sample* dst = static_cast<Sample*> (buffer);   
        //static int outSamps=0;

        if(powerStop==1){return;}

        // first, fill buffer w/ zeros
        for(i=0;i<samplesToWrite;i++){dst->left=0;dst->right=0;dst++;}

        if(track[tr].noiseAdd==1){
          for(i=0;i<samplesToWrite;i++){
            dst->left+=i*i;
            dst->right+=dst->left*i;
          }
         
        }


    // for each track/turntable..
        for(tr=0;tr<2;tr++)
        {
          dst = destination;
          stw = samplesToWrite;

          switch(track[tr].pitchMode)
          {


    case PITCH_STRAIGHT:
            while (stw > 0)
            {
              // Enough samples available?
              track[tr].samplesAvailable = track[tr].synth.pcm.length - track[tr].samplesRead;
              if (track[tr].samplesAvailable > samplesToWrite)
              {
                track[tr].convertAddL(dst,dst+stw);
                track[tr].convertAddR(dst,dst+stw);
                track[tr].sampPlayCount += stw;
                track[tr].samplesRead += stw;  // We're still using the same PCM data.
                stw = 0;  // Done.
              } else
              {
                track[tr].convertAddL(dst,dst+track[tr].samplesAvailable);
                track[tr].convertAddR(dst,dst+track[tr].samplesAvailable);

                track[tr].sampPlayCount+=track[tr].samplesAvailable;
                track[tr].samplesRead = 0;
                track[tr].decode();           // We need more PCM data.
                // We've still got more to write.
                dst += track[tr].samplesAvailable;
                stw -= track[tr].samplesAvailable;
              }
            }
            break;


    case PITCH_TURNTABLE:
           
            // get rid of waste samples to make tracks sync up
            track[tr].wasteSamples = MIN(track[tr].wasteSamplesLeft, 5000);
            //track[tr].wasteSamples = track[tr].wasteSamplesLeft;
            track[tr].wasteSamplesLeft-=track[tr].wasteSamples;

            while( (track[tr].wasteSamples>0) )
            {
              // Enough samples available?
              track[tr].samplesAvailablef = track[tr].synth.pcm.length - track[tr].frameConsumeIdx;
              if (track[tr].samplesAvailablef > track[tr].wasteSamples)
              {
                track[tr].frameConsumeIdx += (int) track[tr].wasteSamples;  // We're still using the same PCM data.
                track[tr].wasteSamples = 0;  // Done.
              } else
              {
                track[tr].frameConsumeIdx+=track[tr].samplesAvailablef;
                track[tr].decode();           // We need more PCM data.
                track[tr].frameConsumeIdx = 0;

                // We've still got more to write.
                track[tr].wasteSamples -= track[tr].samplesAvailablef;
              }
            }







     // render samples
            while (stw > 0)
            {
              float samplesNeeded=stw*track[tr].playRate;

              track[tr].samplesAvailablef = track[tr].synth.pcm.length - track[tr].frameConsumeIdx;
              if(track[tr].samplesAvailablef >= samplesNeeded)
              {
                track[tr].convertTurnTable(dst,dst+stw);
                track[tr].frameConsumeIdx+=samplesNeeded;
                stw=0;
              } else
              {
                float s1 = track[tr].samplesAvailablef/track[tr].playRate;
                int samplesCalculable = (int)s1;
                track[tr].convertTurnTable(dst,dst+samplesCalculable);
                track[tr].frameConsumeIdx += samplesCalculable*track[tr].playRate;

                track[tr].decode();           // We need more PCM data.
                track[tr].frameConsumeIdx = 0;
               
                // We've still got more to write.
                dst += samplesCalculable;
                stw -= samplesCalculable;
              }
            }
            break;







void ENTrack::convertAddL(Sample* first, Sample* last)
{
  src = &synth.pcm.samples[0][samplesRead];

  for (Sample* dst = first; dst != last; ++dst)
  {
    dst->left += (convertSample(*src++) * trackVol)>>12;
  }
}

void ENTrack::convertAddR(Sample* first, Sample* last)
{
  src = &synth.pcm.samples[1][samplesRead];

  for (Sample* dst = first; dst != last; ++dst)
  {
    dst->right += (convertSample(*src++) * trackVol)>>12;
  }
}

// like a turntable, this scales in pitch and time simultaneously
void ENTrack::convertTurnTable(Sample* first, Sample* last)
{
  sampIdx    = (int)frameConsumeIdx;
  sampSubIdx = (int)((frameConsumeIdx-(float)sampIdx)*4194304.0);

  src  = &synth.pcm.samples[0][sampIdx];
  srcR = &synth.pcm.samples[1][sampIdx];
 
  for (Sample* dst = first; dst != last; ++dst)
  {
    //    if( (samplesRead+sampIdx)>=synth.pcm.length){sampIdx--;}

    dst->left  += (convertSample(*(src ) ) * trackVol)>>12;
    dst->right += (convertSample(*(srcR) ) * trackVol)>>12;

    sampSubIdx  += playRateFixed;
    src         += sampSubIdx>>22;
    srcR        += sampSubIdx>>22;
    sampSubIdx  &= 0x03fffff;
  }
 
}
