//
//  ImageModel.m
//  Amg
//
//  Created by yoshizu on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageModel.h"


@implementation ImageModel

+ (ImageModel *) instance
{
	static ImageModel* _instance = nil;
	
 	@synchronized(self)
 	{
 		if(_instance == nil)
 		{
 			_instance = [[ImageModel alloc] init];
 		}
 	}
	
 	return _instance;
}

@synthesize data;

- (id) init
{
	if (self = [super init])
	{
		self.data = [UIImage imageNamed: @"Sprite.png"].CGImage;
	}
	
	return self;
}

@end
