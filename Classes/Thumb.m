//
//  EnvelopePoint.m
//  Ambient
//
//  Created by yoshizu on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Thumb.h"


@implementation Thumb

- (float) x
{
	return self.frame.origin.x + (self.frame.size.width / 2);
}

- (float) y
{
	return self.frame.origin.y + (self.frame.size.height / 2);
}

- (BOOL) isMoving
{
	return isMoving;
}

- (void) setIsMoving: (BOOL) value
{
	isMoving = value;
	
	[self setNeedsDisplay];
}

- (id) initWithFrame: (CGRect) frame
{
    if (self = [super initWithFrame: frame])
	{
        self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
		
		self.isMoving = NO;
		
		//[self setupView];
		//[self drawView];
    }
	
    return self;
}

- (void) setupView
{
	glClearColor(0, 0, 0, 0);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	const GLshort spriteTexcoords[] =
	{
		0, 0,
		1, 0,
		0, 1,
		1, 1,
	};
	
	glTexCoordPointer(2, GL_SHORT, 0, spriteTexcoords);
	
	glGenTextures(1, &spriteTexture);
	glBindTexture(GL_TEXTURE_2D, spriteTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glEnable(GL_TEXTURE_2D);
	
	glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
	glEnable(GL_BLEND);
}

- (void) drawView
{		
	//[EAGLContext setCurrentContext: self.context];
	
	//glClear(GL_COLOR_BUFFER_BIT);
	//glViewport(0, 0, backingWidth, backingHeight);
	
    
   // [self.context presentRenderbuffer: GL_RENDERBUFFER_OES];
}



- (void) drawRect: (CGRect) rect
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (isMoving)
	{
		self.alpha = 0.7;
		
		CGContextSetRGBFillColor(context, 0.7, 0.7, 0.7, 1);
		CGContextFillEllipseInRect(context, rect);
	}
	else
	{
		self.alpha = 1;
	}

	CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
	CGContextFillEllipseInRect(context, CGRectMake(rect.size.width / 8 * 3,
												   rect.size.height / 8 * 3,
												   rect.size.width / 4,
												   rect.size.height / 4));

}

- (void) dealloc
{
    [super dealloc];
}


@end
