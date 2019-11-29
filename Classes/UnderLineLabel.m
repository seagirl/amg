//
//  UnderLineLabel.m
//  Amg
//
//  Created by yoshizu on 1/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UnderLineLabel.h"


@implementation UnderLineLabel

@synthesize underline;

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithCoder: (NSCoder *) coder
{
	if (self = [super initWithCoder: coder]) {
		self.underline = YES;
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    }
	
    return self;
}

- (void) drawRect: (CGRect) rect
{
	[super drawRect: rect];
	
	if (underline) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
		
		CGRect textRect = [self textRectForBounds: rect limitedToNumberOfLines: 1];
		
		CGContextMoveToPoint(context, 0, self.font.pointSize + self.baselineAdjustment + 2);
		CGContextAddLineToPoint(context, textRect.size.width, self.font.pointSize + self.baselineAdjustment + 2);
		CGContextStrokePath(context);
	}
}


@end
