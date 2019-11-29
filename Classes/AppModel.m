//
//  AppModel.m
//  Amg
//
//  Created by seagirl on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

+ (AppModel *) instance
{
	static AppModel* _instance = nil;
	
 	@synchronized(self)
 	{
 		if(_instance == nil)
 		{
 			_instance = [[AppModel alloc] init];
 		}
 	}
	
 	return _instance;
}

@synthesize data0, data1, data2;

- (void) dealloc
{
	[data0 release];
	[data1 release];
	[data2 release];
	
	[super dealloc];
}

- (void) initData
{
	for (int i = 0; i < 3; i++)
	{
		NSArray *keys = [NSArray arrayWithObjects:
						 @"algorithmIndex",
						 @"rootKey",
						 @"scaleIndex",
						 @"range",
						 @"minimumKey",
						 @"maximumKey",
						 @"interval",
						 @"volume",
						 @"attack",
						 @"decay",
						 @"sustain",
						 @"release",
						 nil];
		
		NSArray *objects = [NSArray arrayWithObjects:
							@"0",
							@"0",
							@"0",
							@"2",
							@"64",
							@"78",
							@"0.25",
							@"0.8",
							@"0.5",
							@"0.2",
							@"0.5",
							@"0.3",
							nil];
		
		switch (i) {
			case 0:
				self.data0 = [NSMutableDictionary dictionaryWithObjects: objects forKeys: keys];
				break;
			case 1:
				self.data1 = [NSMutableDictionary dictionaryWithObjects: objects forKeys: keys];
				break;
			case 2:
				self.data2 = [NSMutableDictionary dictionaryWithObjects: objects forKeys: keys];
				break;
		}
	}
}

@end
