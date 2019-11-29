//
//  ScaleBase.h
//  AmbientSoundGenerator
//
//  Created by yoshizu on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScaleBase : NSObject {
	int key;
	int min;
	int max;
	
	NSArray *map;
	NSMutableArray *notes;
}

@property (readonly, retain, nonatomic) NSMutableArray *notes;

- (id) initWithKey: (int) aKey minimum: (int) aMin maximum: (int) aMax;
- (void) initialize;
- (NSArray *) setup;

@end
