//
//  Instrument.h
//  AmbientSoundGenerator
//
//  Created by yoshizu on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"
#import "Circle.h"
#import "Image.h"
#import "Tone.h"
#import "MajorScale.h"
#import "MinorScale.h"
#import "RyukyuScale.h"
#import "WholeToneScale.h"

@interface Instrument : NSObject {
	int counter;
	NSTimer *timer;
	
	BOOL isPlaying;
	
	int type;
	
	float locationX;
	float locationY;
	
	NSDictionary *model;
	
	int noteIndex;
	
	ScaleBase *scale;
	int scaleIndex;
	
	int rootKey;
	int minKey;
	int maxKey;
	
	Canvas *canvas;
	Image *image;
}

@property float locationX;
@property float locationY;

@property int noteIndex;
@property (retain) NSDictionary *model;
@property (retain) ScaleBase *scale;
@property (retain) Canvas *canvas;

+ (id) instrumentWithType: (int) t;
- (id) initWithType: (int) t;

- (void) start;
- (void) stop;

- (void) selectScale;
- (void) selectLocation;
- (void) ring;
- (void) draw;

- (void) timerAction;

@end
