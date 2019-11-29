//
//  Instrument.m
//  AmbientSoundGenerator
//
//  Created by yoshizu on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

@synthesize locationX, locationY;
@synthesize noteIndex;
@synthesize model;
@synthesize scale;
@synthesize canvas;


+ (id) instrumentWithType: (int) t
{	
	return [[[Instrument alloc] initWithType: t] autorelease];
}

- (void) dealloc
{
	[model release];
	[scale release];
	[canvas release];
	[image release];
	
	[super dealloc];
}

- (id) initWithType: (int) t
{
	if (self = [super init])
	{
		type = t;
		counter = 0;
		isPlaying = NO;
		noteIndex = 0;
		
		srand((unsigned) time(NULL));
		
		image = [[Image alloc] initWithType: type];
	}
	
	return self;
}

- (void) start
{
	if (isPlaying == YES)
		return;
	
	isPlaying = YES;
	
	UInt32 sessionCategory = kAudioSessionCategory_LiveAudio;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	AudioSessionSetActive(true);
	
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
											 target: self
										   selector: @selector(timerAction)
										   userInfo: nil
											repeats: YES];
}

- (void) stop
{
	if (isPlaying == NO)
		return;
	
	isPlaying = NO;
	
	[timer invalidate];
	
	[canvas clearView];
	
	AudioSessionSetActive (false);
}

- (float) getFrequency: (NSMutableArray *) notes
{
	return [[notes objectAtIndex: noteIndex] floatValue];
}

- (void) selectLocation
{
	int range = [(NSString *) [model objectForKey: @"range"] intValue];
	
	locationX = (float) noteIndex / (float) scale.notes.count * canvas.frame.size.width;
	locationY = rand() % (int) (canvas.frame.size.height / 3) + range * canvas.frame.size.height / 3;
}

- (void) selectScale
{
	int index = [(NSString *) [model objectForKey: @"scaleIndex"] intValue];
	int root = [(NSString *) [model objectForKey: @"rootKey"] intValue];
	int min = [(NSString *) [model objectForKey: @"minimumKey"] intValue];
	int max = [(NSString *) [model objectForKey: @"maximumKey"] intValue];
	
	if (scale == nil || scaleIndex != index || rootKey != root || minKey != min || maxKey != max)
	{
		scaleIndex = index;
		rootKey = root;
		minKey = min;
		maxKey = max;
		
		switch (scaleIndex) {
			case 0:
				scale = [[MajorScale alloc] initWithKey: rootKey minimum: minKey maximum: maxKey];
				break;
			case 1:
				scale = [[MinorScale alloc] initWithKey: rootKey minimum: minKey maximum: maxKey];
				break;
			case 2:
				scale = [[RyukyuScale alloc] initWithKey: rootKey minimum: minKey maximum: maxKey];
				break;
			case 3:
				scale = [[WholeToneScale alloc] initWithKey: rootKey minimum: minKey maximum: maxKey];
				break;
			default:
				NSLog(@"Invalid scaleIndex: %d", scaleIndex);
				break;
		}
	}
	
	noteIndex = rand() % scale.notes.count;
}

- (void) ring
{
	float volume = [(NSString *) [model objectForKey: @"volume"] floatValue];
	float attack = [(NSString *) [model objectForKey: @"attack"] floatValue];
	float decay = [(NSString *) [model objectForKey: @"decay"] floatValue];
	float sustain = [(NSString *) [model objectForKey: @"sustain"] floatValue];
	float release = [(NSString *) [model objectForKey: @"release"] floatValue];
	float frequency = [self getFrequency: scale.notes];
	
	Tone *aTone = [[Tone alloc] initWithFrequency: frequency
										   lifespan: 3.0
											 volume: volume
											 attack: attack
											  decay: decay
											sustain: sustain
											release: release];
	[aTone start];
}

- (void) draw
{
	float volume = [(NSString *) [model objectForKey: @"volume"] floatValue];
	float attack = [(NSString *) [model objectForKey: @"attack"] floatValue] * 3.0;
	float decay = [(NSString *) [model objectForKey: @"decay"] floatValue] * 3.0;
	float sustain = [(NSString *) [model objectForKey: @"sustain"] floatValue];
	float release = [(NSString *) [model objectForKey: @"release"] floatValue] * 3.0;
	
	Circle* circle = [[Circle alloc] initWithFPS: canvas.fps
											type: type
										lifespan: 4.0
										  volume: volume
										  attack: attack
										   decay: decay
										 sustain: sustain
										 release: release];
	
	circle.x = locationX - circle.size / 2;
	circle.y = locationY - circle.size / 2;

	circle.image = [[ImageModel instance] data];
	circle.data = image.data;
	circle.context = image.context;
	
	[canvas addCircle: circle];
	[circle release];
}

- (void) timerAction
{
	float interval = [(NSString *) [model objectForKey: @"interval"] floatValue] + 0.20;
	
	int value = interval * 70.0f;
	
	if (value == 0)
		value = 1;
	
	if (counter++ % value != 0)
		return;
	
	[self selectScale];
	[self selectLocation];
	[self ring];
	[self draw];
}


@end
