//
//  Tone.m
//  AmbientSoundGenerator
//
//  Created by yoshizu on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Tone.h"


@implementation Tone

static void AQBufferCallback(void *aqData, AudioQueueRef queue, AudioQueueBufferRef buffer)
{	
	Tone *tone = (Tone *) aqData;
	AudioSample *coreAudioBuffer = (AudioSample *) buffer->mAudioData;
	buffer->mAudioDataByteSize = sizeof(AudioSample) * 2 * FRAMES;
	[tone fillBuffer:coreAudioBuffer frames:FRAMES];
	AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
}

- (id) initWithFrequency: (float) f
				lifespan: (float) l
				  volume: (float) v
				  attack: (float) a
				   decay: (float) d
				 sustain: (float) s
				 release: (float) r
{
	[super init];
	
	lock = [[NSLock alloc] init];
	
	phase = 0;
	amplifier = 0.0f;
	
	state = 1;
	
	frequency = f;
	lifespan = l;
	volume = v;
	attack = a;
	decay = d;
	sustain = s;
	release = r;
	
	[self initializeVelocity];
	[self initializeAudioQueue];

	return self;
}

- (void) initializeVelocity
{
	// 速度 = ボリュームの変化量 / サンプリングレート * 秒数
	v1 = volume / (SAMPLING_RATE * attack * lifespan);
	v2 = (volume - sustain) / (SAMPLING_RATE * decay * lifespan);
	v3 = sustain / (SAMPLING_RATE * release * lifespan);
}

- (void) initializeAudioQueue
{
	AudioStreamBasicDescription desc;
	desc.mSampleRate = SAMPLING_RATE;
	desc.mFormatID = kAudioFormatLinearPCM;
	desc.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	desc.mBytesPerPacket = 4;
	desc.mFramesPerPacket = 1;
    desc.mBytesPerFrame = 4;
	desc.mChannelsPerFrame = 2;
	desc.mBitsPerChannel = 16;
	
	UInt32 bufferBytes = FRAMES * desc.mBytesPerFrame;
	
	AudioQueueNewOutput(&desc, AQBufferCallback, self, NULL, kCFRunLoopCommonModes, 0, &outAQ);
	AudioQueueSetParameter(outAQ, kAudioQueueParam_Volume, 1.0);
	
	for (int i = 0; i < BUFFERS; i++)
	{
		AudioQueueAllocateBuffer(outAQ, bufferBytes, &mBuffers[0]);
		AQBufferCallback(self, outAQ, mBuffers[0]);
	}
}

- (void) start
{	
	timer = [NSTimer scheduledTimerWithTimeInterval: lifespan
											 target: self
										   selector: @selector(timerAction)
										   userInfo: nil
											repeats: YES];
	
    AudioQueueStart(outAQ, NULL);
}

- (void) stop
{
	AudioQueueStop(outAQ, YES);
	
	[self release];
}

- (void) pause
{
	AudioQueuePause(outAQ);
}

- (void) resume
{
	AudioQueueStart(outAQ, NULL);
}

- (void) fillBuffer: (AudioSample *) buffer frames: (int) frames
{	
	[lock lock];
	
	int i = 0;
    for (i = 0; i < frames; i++)
	{
		phase += frequency / SAMPLING_RATE;
		
		float phaseAngle = phase * M_PI * 2;
		float sample = sinf(phaseAngle) * amplifier;
		
		AudioSample value = sample * 7000;
		
		*(buffer++) = value; // L
		*(buffer++) = value; // R
		
		if (state == 1)
		{
			amplifier += v1;
			
			if (amplifier >= volume)
			{
				amplifier = volume;
				state = 2;
			}
		}
		else if (state == 2)
		{
			amplifier -= v2;
			
			if (volume >= sustain)
			{
				if (amplifier <= sustain)
				{
					amplifier = sustain;
					state = 3;
				}
			}
			else {
				if (amplifier >= sustain)
				{
					amplifier = sustain;
					state = 3;
				}
			}
				
		}
		else if (state == 3)
		{
			amplifier -= v3;
			
			if (amplifier <= 0)
			{
				amplifier = 0;
			}
		}
	}
	
	[lock unlock];
}

- (void) timerAction
{		
	amplifier = 0;
	
	[timer invalidate];
	
	[self stop];
}

- (void) dealloc
{	
	AudioQueueDispose(outAQ, YES);
	
	[lock release];
	
	[super dealloc];
}

@end
