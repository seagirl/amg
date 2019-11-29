//
//  ScaleBase.m
//  AmbientSoundGenerator
//
//  Created by yoshizu on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ScaleBase.h"

@implementation ScaleBase

@synthesize notes;

- (id) initWithKey: (int) aKey minimum: (int) aMin maximum: (int) aMax
{
	[super init];
	
	key = aKey;
	min = aMin;
	max = aMax;
	
	map = [self setup];

	[self initialize];
	
	return self;
}

- (NSArray *) setup
{
	return nil;
}

- (void) initialize
{
	int counter = 0;
	int noteNumber = key;
	
	notes = [[NSMutableArray alloc] init];
	
	while (noteNumber <= 127)
	{
		if (noteNumber >= min && noteNumber <= max)
		{
			NSNumber *note = [[[NSNumber alloc] initWithFloat: 442.0f * pow(2, (noteNumber - 69) / 12.0f)] autorelease];
			[notes addObject: note];
		}
		
		int position = counter++ % [map count];
		noteNumber += [[map objectAtIndex: position] floatValue];
	}
}

- (void) dealloc
{
	NSLog(@"dealloc scale");
	
	[notes release];
	[map release];

	[super dealloc];
}

@end
