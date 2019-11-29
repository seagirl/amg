//
//  Thumb.h
//  Amg
//
//  Created by yoshizu on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"

@interface  Thumb: UIView
{
	float x;
	float y;
	
	BOOL isMoving;
	
	GLuint spriteTexture;
}

@property (readonly) float x;
@property (readonly) float y;

@property BOOL isMoving;

- (void) setupView;
- (void) drawView;

@end
