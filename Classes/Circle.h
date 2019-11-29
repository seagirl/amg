//
//  Circle.h
//  Amg
//
//  Created by yoshizu on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>

@interface Circle : NSObject
{
	CGImageRef image;
	GLubyte* data;
	CGContextRef context;
	
	float amplifier1;
	float amplifier2;
	
	int size;
	int maxSize;
	
	int type;
	int state;
	float fps;
	
	float volume;
	float attack;
	float decay;
	float sustain;
	float release;
	
	float maxAmplifier1;
	float maxAmplifier2;
	
	float v1, v2, v3;
	float x, y;
	float red, green, blue;
	
	NSTimer* timer;
}

@property CGImageRef image;
@property GLubyte* data;
@property CGContextRef context;

@property float amplifier1;
@property float amplifier2;

@property int size;
@property int maxSize;
@property int type;

@property float x;
@property float y;

@property float red;
@property float green;
@property float blue;

@property (nonatomic, assign) NSTimer* timer;

- (id) initWithFPS: (int) f
			  type: (int) t
		  lifespan: (float) l
			volume: (float) v
			attack: (float) a
			 decay: (float) d
		   sustain: (float) s
		   release: (float) r;

- (void) initializeVelocity;
- (void) validateAmplifier;

@end
