//
//  InstrumentModel.h
//  Amg
//
//  Created by seagirl on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MajorScale.h"
#import "MinorScale.h"
#import "RyukyuScale.h"
#import "WholeToneScale.h"

@interface InstrumentModel : NSObject {
	float interval;
	float lifespan;
	float volume;
	float attack;
	float decay;
	float sustain;
	float release;
	
	int rootKey;
	int minimumKey;
	int maximumKey;
	
	int noteIndex;
	int scaleIndex;
	
	ScaleBase *scale;
}

@property float interval;
@property float lifespan;
@property float volume;
@property float attack;
@property float decay;
@property float sustain;
@property float release;

@property int rootKey;
@property int minimumKey;
@property int maximumKey;

@property int noteIndex;

@property int scaleIndex;
@property (retain) ScaleBase *scale;

@end
