//
//  Tone.h
//  AmbientSoundGenerator
//
//  Created by yoshizu on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#define SAMPLING_RATE 44100
#define FRAMES 4096
#define BUFFERS 3

typedef short AudioSample;

@interface Tone : NSObject {
	NSMutableArray *channels;
	AudioQueueRef outAQ;
	AudioQueueBufferRef mBuffers[BUFFERS];
	
	NSLock *lock;
	NSTimer *timer;
	
	int state;
	
	float phase;
	float amplifier;
	
	float frequency;
	float lifespan;
	float volume;
	float attack;
	float decay;
	float sustain;
	float release;
	
	float v1;
	float v2;
	float v3;

}

- (id) initWithFrequency: (float) f
				lifespan: (float) l
				  volume: (float) v
				  attack: (float) a
				   decay: (float) d
				 sustain: (float) s
				 release: (float) r;

- (void) initializeVelocity;
- (void) initializeAudioQueue;

- (void) start;
- (void) stop;
- (void) pause;
- (void) resume;

- (void) fillBuffer: (AudioSample*) buffer frames: (int) frames;
- (void) timerAction;

@end
