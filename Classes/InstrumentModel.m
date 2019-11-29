//
//  InstrumentModel.m
//  Amg
//
//  Created by seagirl on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InstrumentModel.h"


@implementation InstrumentModel

@synthesize interval;
@synthesize lifespan;
@synthesize volume;
@synthesize attack;
@synthesize decay;
@synthesize sustain;
@synthesize release;

@synthesize rootKey;
@synthesize minimumKey;
@synthesize maximumKey;

@synthesize noteIndex;

@synthesize scaleIndex;
@synthesize scale;


- (void) dealloc
{
	[scale release];
	
	[super dealloc];
}

- (id) init
{
	[super init];
		
	self.lifespan = 3.0f;
	self.volume = 1.0f;
	self.attack = 0.1;
	self.decay = 0.6;
	self.sustain = 0.4;
	self.release = 0.3;
	
	self.interval = 0.5;
	
	self.rootKey = 0;
	self.minimumKey = 64;
	self.maximumKey = 78;
	
	self.scale = [[MajorScale alloc] initWithKey: rootKey minimum: minimumKey maximum: maximumKey];
	self.scaleIndex = 0;
	
	return self;
}

@end
