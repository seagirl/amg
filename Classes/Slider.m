//
//  Slider.m
//  Amg
//
//  Created by yoshizu on 1/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Slider.h"


@implementation Slider

@synthesize value;
@synthesize thumb;
@synthesize delegate;
@synthesize onChange, onTouchesBegan, onTouchesEnd;

- (void) dealloc
{
	[thumb release];
	
	[delegate release];
	
    [super dealloc];
}

- (void) setValue: (float) v
{	
	value = v;
	
	if (thumb == nil)
		return;
	
	CGRect frame = [thumb frame];
	frame.origin.x = (value * self.frame.size.width) - thumb.frame.size.width / 2;
	[thumb setFrame: frame];
}

- (id) initWithFrame: (CGRect) frame
{
    if (self = [super initWithFrame: frame]) {
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
		
		CGRect frame = CGRectMake(self.value * 320, 0, 64, 64); 
		thumb = [[Thumb alloc] initWithFrame: frame];
		[self addSubview: thumb];
    }
	
    return self;
}

- (void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
	
    CGContextMoveToPoint(context, 0, rect.size.height / 2);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 2);
	CGContextStrokePath(context);
	
	[thumb setNeedsDisplay];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == thumb)
	{
		thumb.isMoving = YES;
		
		[delegate performSelector: onTouchesBegan];
	}
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == thumb) {
		CGPoint location = [touch locationInView: self];
		
		if (location.x >= 0 && location.x <= self.frame.size.width)
		{
			self.value = location.x / self.frame.size.width;
			[delegate performSelector: onChange];
		}
	}
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == thumb)
	{
		thumb.isMoving = NO;
		
		[delegate performSelector: onTouchesEnd];
	}
}


@end
