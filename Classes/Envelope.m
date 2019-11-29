//
//  Envelope.m
//  Ambient
//
//  Created by yoshizu on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Envelope.h"

@interface Envelope (PrivateMethods)

- (void) validatePoint1;
- (void) validatePoint2;

@end

@implementation Envelope

@synthesize volume, attack, decay, sustain, release;
@synthesize point1, point2;
@synthesize delegate;
@synthesize onChange, onTouchesBegan, onTouchesEnd;

- (void) dealloc
{	
	[point1 release];
	[point2 release];
	
	[delegate release];
	
    [super dealloc];
}

- (id) initWithFrame: (CGRect) frame
{
	if (self = [super initWithFrame: frame])
	{
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
		
		CGRect frame1 = CGRectMake(1, 1, 64, 64);
		point1 = [[Thumb alloc] initWithFrame: frame1];
		[self addSubview: point1];
		
		CGRect frame2 = CGRectMake(1, 1, 64, 64);
		point2 = [[Thumb alloc] initWithFrame: frame2];
		[self addSubview: point2];
	}
	
    return self;
}

- (void) validateProperties
{
	[self validatePoint1];
	[self validatePoint2];
}

- (void) validatePoint1
{
	CGRect frame1 = [point1 frame];
	frame1.origin.x = (attack * self.frame.size.width) - (point1.frame.size.width / 2);
	frame1.origin.y = ((1 - volume) * self.frame.size.height) - (point1.frame.size.height / 2);
	[point1 setFrame: frame1];
}

- (void) validatePoint2
{
	float value = decay + attack;
	
	if (value > 1)
		value = 1;
	
	CGRect frame2 = [point2 frame];
	frame2.origin.x = (value * self.frame.size.width) - (point2.frame.size.width / 2);
	frame2.origin.y = ((1 - sustain) * self.frame.size.height) - (point2.frame.size.height / 2);
	[point2 setFrame: frame2];
}

- (void) drawRect: (CGRect) rect
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
	
    CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, point1.x, point1.y);
	CGContextAddLineToPoint(context, point2.x, point2.y);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextStrokePath(context);
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{	
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == point1 ||
		[touch view] == point2)
	{
		Thumb *thumb = (Thumb *) [touch view];
		thumb.isMoving = YES;
		
		[self bringSubviewToFront: thumb];
		
		[delegate performSelector: onTouchesBegan];
	}
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: self];
	
	if ([touch view] == point1) {		
		if (location.x >= 0 &&
			(location.x + point1.frame.size.width / 6) <= point2.frame.origin.x + point2.frame.size.width / 3)
		{
			attack = location.x / self.frame.size.width;
		}
		
		if (location.y >= 0 && location.y <= self.frame.size.height)
		{
			volume = (self.frame.size.height - location.y) / self.frame.size.height;
		}
		
		[self validatePoint1];
	}
	else if ([touch view] == point2) {
		
		if ((location.x - point2.frame.size.width / 6) >= point1.frame.origin.x + point1.frame.size.width / 3 * 2 &&
			location.x <= self.frame.size.width)
		{
			decay = location.x / self.frame.size.width - attack;
		}
		
		if (location.y >= 0 && location.y <= self.frame.size.height)
		{
			sustain = (self.frame.size.height - location.y) / self.frame.size.height;
		}
		
		[self validatePoint2];
	}
	
	release = 1 - attack - decay;
	
	[delegate performSelector: onChange];
	
	[self setNeedsDisplay];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == point1 ||
		[touch view] == point2)
	{
		Thumb *thumb = (Thumb *) [touch view];
		thumb.isMoving = NO;
		
		[delegate performSelector: onTouchesEnd];
	}
}


@end
