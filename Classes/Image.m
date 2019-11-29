//
//  Image.m
//  Amg
//
//  Created by seagirl on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Image.h"


@implementation Image

@synthesize data;
@synthesize context;

- (void) dealloc
{   
	free(data);

	CGContextRelease(context);
	
	[super dealloc];
}

- (id) initWithType: (int) type
{
	if (self = [super init])
	{
		CGImageRef image = [[ImageModel instance] data];
		
		size_t width = CGImageGetWidth(image);
		size_t height = CGImageGetHeight(image);
		
		self.data = (GLubyte *) malloc(width * height * 4);
		
		float blur = 12.0;
		CGRect rect = CGRectMake(blur / 2, blur / 2, 128 - blur, 128 - blur);
		CGColorRef color =  [[UIColor whiteColor] CGColor];
		
		float red, green, blue;
		
		if (type == 0)
		{
			red = (rand() % 10 + 180) / 255.0;
			green = (rand() % 10 + 200) / 255.0;
			blue = (rand() % 10 + 200) / 255.0;
		}
		else if (type == 1)
		{
			red = (rand() % 10 + 200) / 255.0;
			green = (rand() % 10 + 200) / 255.0;
			blue = (rand() % 10 + 170) / 255.0;
		}
		else if (type == 2)
		{
			red = (rand() % 10 + 200) / 255.0;
			green = (rand() % 10 + 180) / 255.0;
			blue = (rand() % 10 + 180) / 255.0;
		}
		
		context = CGBitmapContextCreate(data,
										width,
										height,
										8,
										width * 4,
										CGImageGetColorSpace(image),
										kCGImageAlphaPremultipliedLast);
		
		CGContextClearRect(context, rect);
		CGContextSetRGBFillColor(context, red, green, blue, 1.0);
		CGContextSetShadowWithColor(context, CGSizeZero, blur, color);
		CGContextFillEllipseInRect(context, rect);
		CGContextDrawImage(context, CGRectZero, image);
	}
	
	return self;
}


@end
