//
//  Bar.m
//  Amg
//
//  Created by seagirl on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Bar.h"


@implementation Bar

- (id) initWithFrame: (CGRect) frame
{
    if (self = [super initWithFrame: frame])
	{
    }
    
	return self;
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 1, 1, 1, 0.6);
	CGContextFillRect(context, rect);
}


- (void) dealloc
{	
    [super dealloc];
}


@end
