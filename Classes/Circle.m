//
//  Circle.m
//  Amg
//
//  Created by yoshizu on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"


@implementation Circle

@synthesize image, data, context;
@synthesize amplifier1, amplifier2;
@synthesize size, maxSize, type;
@synthesize x, y, red, green, blue;
@synthesize timer;

- (void) dealloc
{   	
	[super dealloc];
}

- (id) initWithFPS: (int) f
			  type: (int) t
		  lifespan: (float) l
			volume: (float) v
			attack: (float) a
			 decay: (float) d
		   sustain: (float) s
		   release: (float) r
{
	if (self = [super init])
	{
		self.amplifier1 = 0.0f;
		self.amplifier2 = 0.0f;
		
		float max = v > s ? v : s;
		
		self.maxSize = 64 * max + 64;
		self.type = t;
		
		state = 1;
		
		fps = f;

		volume = v;
		attack = a;
		decay = d;
		sustain = s;
		release = r;
		
		[self initializeVelocity];
	}
	
	return self;
}

- (void) initializeVelocity
{
	if (volume > sustain)
	{
		maxAmplifier1 = volume;
		maxAmplifier2 = 1.0;
		
		v1 = maxAmplifier1 / (fps * attack);
		v2 = maxAmplifier2 / (fps * attack);
		v3 = maxAmplifier2 / (fps * (decay + release));
	}
	else
	{
		maxAmplifier1 = sustain;
		maxAmplifier2 = 1.0;
		
		v1 = maxAmplifier1 / (fps * (attack + decay));
		v2 = maxAmplifier2 / (fps * (attack + decay));
		v3 = maxAmplifier2 / (fps * release);
	}
}

- (void) validateAmplifier
{	
	if (state == 1)
	{
		amplifier1 += v1;
		amplifier2 += v2;
		
		if (amplifier1 >= maxAmplifier1)
		{
			amplifier1 = maxAmplifier1;
			amplifier2 = maxAmplifier2;
			
			state = 2;
		}
	}
	else if (state == 2)
	{
		amplifier2 -= v3;
		
		if (amplifier2 <= 0)
		{
			amplifier2 = 0;
		}
		
	}
}


@end
