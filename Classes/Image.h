//
//  Image.h
//  Amg
//
//  Created by seagirl on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>

#import "ImageModel.h"

@interface Image : NSObject {
	GLubyte *data;
	CGContextRef context;
}

@property GLubyte *data;
@property CGContextRef context;

- (id) initWithType: (int) type;

@end
