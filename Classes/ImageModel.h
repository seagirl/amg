//
//  ImageModel.h
//  Amg
//
//  Created by yoshizu on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageModel : NSObject {
	CGImageRef data;
}

+ (ImageModel *) instance;

@property CGImageRef data;

@end
