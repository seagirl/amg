//
//  Canvas.h
//  Amg
//
//  Created by yoshizu on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Circle.h"
#import "Image.h"

@interface Canvas : UIView {	
	GLuint spriteTexture;
	
	GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext* context;
    
    GLuint viewRenderbuffer;
	GLuint viewFramebuffer;
    GLuint depthRenderbuffer;
	
	NSTimer* animationTimer;
    NSTimeInterval animationInterval;
	
	float fps;
	float rateX;
	float rateY;
	
	NSMutableArray* circles;
	NSMutableArray* willDeleteCircles;
	
	int holdStatus;
	CGPoint holdLocation;
	NSTimer* holdTimer;
	Image* holdImage;
	Circle* holdCircle;
}

@property NSTimeInterval animationInterval;
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

@property float fps;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

- (void) startAnimation;
- (void) stopAnimation;

- (void) clearView;
- (void) setupView;
- (void) drawView;
- (void) drawCircle: (Circle*) circle;
- (void) addCircle: (Circle*) circle;

- (void) showControl;


@end
