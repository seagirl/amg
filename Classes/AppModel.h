//
//  AppModel.h
//  Amg
//
//  Created by seagirl on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppModel : NSObject {
	NSMutableDictionary *data0;
	NSMutableDictionary *data1;
	NSMutableDictionary *data2;
}

+ (AppModel *) instance;

@property (retain) NSMutableDictionary *data0;
@property (retain) NSMutableDictionary *data1;
@property (retain) NSMutableDictionary *data2;

- (void) initData;

@end
