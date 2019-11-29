//
//  Canvas.m
//  Amg
//
//  Created by yoshizu on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "Canvas.h"
#import "AmAppDelegate.h"
#import "AmViewController.h"

#define USE_DEPTH_BUFFER 0


@interface Canvas (PrivateMethods)

- (void) changeKeys: (int) page;

@end


@implementation Canvas

 
+ (Class) layerClass {
    return [CAEAGLLayer class];
}

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;

@synthesize fps;

- (id)initWithCoder: (NSCoder*) coder
{
    if(self = [super initWithCoder: coder])
	{	
		self.alpha = 0.7;
		
		fps = 24.0;
		
		rateX = 320 / 2.0;
		rateY = 480 / 2.0;
		
		circles = [[NSMutableArray array] retain];
		
		CAEAGLLayer* eaglLayer = (CAEAGLLayer *) self.layer;
        
        eaglLayer.opaque = NO;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool: NO],
										kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8,
										kEAGLDrawablePropertyColorFormat,
										nil];
        
        context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext: context]) {
            [self release];
            return nil;
        }
		
		animationInterval = 1.0 / fps;
		
		[self setupView];
		[self drawView];
	}
	
	return self;
}

- (void) dealloc
{
	[self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext: nil];
    }
    
    [context release];
	
    [super dealloc];
}

- (void) addCircle: (Circle*) circle
{	
	[circles insertObject: circle atIndex: 0];
}

- (void) clearView
{
	if ([circles count] == 0)
		return;
	
	[circles removeAllObjects];
	
	[EAGLContext setCurrentContext: context];

	glClear(GL_COLOR_BUFFER_BIT);  
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);

    [context presentRenderbuffer: GL_RENDERBUFFER_OES];
}

- (void) setupView
{
	glClearColor(0, 0, 0, 0);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	const GLshort spriteTexcoords[] =
	{
		0, 0,
		1, 0,
		0, 1,
		1, 1,
	};
	
	glTexCoordPointer(2, GL_SHORT, 0, spriteTexcoords);
	
	glGenTextures(1, &spriteTexture);
	glBindTexture(GL_TEXTURE_2D, spriteTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glEnable(GL_TEXTURE_2D);
	
	glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
	glEnable(GL_BLEND);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
}

- (void) drawView
{		
	if ([circles count] == 0)
		return;
	
	willDeleteCircles = [NSMutableArray array];
	
	[EAGLContext setCurrentContext: context];
	
	glClear(GL_COLOR_BUFFER_BIT);
	glViewport(0, 0, backingWidth, backingHeight);
	
	for (Circle* circle in circles)
	{
		[self drawCircle: circle];
	}
	
	for (Circle* circle in willDeleteCircles)
	{
		[circles removeObject: circle];
	}
    
    [context presentRenderbuffer: GL_RENDERBUFFER_OES];
}

- (void) drawCircle: (Circle*) circle
{	
	[circle validateAmplifier];
	
	const int size = circle.maxSize * circle.amplifier1 * 1.1;
	
	const GLfloat squareVertices[] =
	{
		(circle.x - rateX - (size / 2)) / rateX,
		(circle.y - rateY - (size / 2)) / rateY,
		
		(size + circle.x - rateX - (size / 2)) / rateX,
		(circle.y - rateY - (size / 2)) / rateY,
		
		(circle.x - rateX - (size / 2)) / rateX,
		(size + circle.y - rateY - (size / 2)) / rateY,
		
		(size + circle.x - rateX - (size / 2)) / rateX,
		(size + circle.y - rateY - (size / 2)) / rateY,
    };
	
	const int color = (rand() % 10 + 245) * circle.amplifier2;
	
	const GLbyte squareColors[] =
	{
		color, color, color, 0,
		color, color, color, 0,
		color, color, color, 0,
		color, color, color, 0,
	};
	
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE, circle.data);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	if (circle.amplifier2 == 0)
		[willDeleteCircles addObject: circle];
}

- (void) layoutSubviews
{
    [EAGLContext setCurrentContext: context];
    [self destroyFramebuffer];
    [self createFramebuffer];
}


- (BOOL) createFramebuffer
{
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable: (CAEAGLLayer*) self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void) destroyFramebuffer
{    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void) startAnimation
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval: animationInterval
														   target: self
														 selector: @selector(drawView)
														 userInfo: nil
														  repeats: YES];
}


- (void) stopAnimation
{
    self.animationTimer = nil;
}


- (void) setAnimationTimer: (NSTimer*) newTimer
{
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void) setAnimationInterval: (NSTimeInterval) interval
{    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

- (void) showControl
{
	UIApplication* delegate = (UIApplication*) [[UIApplication sharedApplication] delegate];
	UIScrollView* scrollView = (UIScrollView*)  [delegate performSelector: @selector(scrollView)];
	UIPageControl* pageControl = (UIPageControl*)  [delegate performSelector: @selector(pageControl)];
	UILabel* clock = (UILabel*) [delegate performSelector: @selector(clock)];
	
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 1.0];
	
	scrollView.alpha = 1;
	pageControl.alpha = 1;
	clock.alpha = 0;
	self.alpha = 0.7;
	
	[UIView commitAnimations];
}

- (void) changeKeys: (int) page
{
	AmAppDelegate* delegate = (AmAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSMutableArray *viewControllers = delegate.viewControllers;
	
	AmViewController* controller = [viewControllers objectAtIndex: page];
	
	int range = 2;
	
	if (holdLocation.y >= 480 / 3.0)
	{
		range = 1;
		
		if (holdLocation.y >= 960 / 3.0)
		{
			range = 0;
		}
	}
	
	controller.keys.selectedRow3 = range;
	
	[controller changeKeys];
}

- (void) onHold
{
	if (holdStatus == 2)
		return;
	
	holdStatus = 1;
	
	int page = 0;
	
	if (holdLocation.x >= 320 / 3.0)
	{
		page = 1;
		
		if (holdLocation.x >= 640 / 3.0)
		{
			page = 2;
		}
	}
	
	holdImage = [[Image alloc] initWithType: page];
	holdCircle = [[Circle alloc] initWithFPS: fps
										type: 1
									lifespan: 4.0
									  volume: 1.0
									  attack: 0.1
									   decay: 0.2
									 sustain: 0.1
									 release: 0.7];
	
	holdCircle.amplifier2 = 0.6;
	
	holdCircle.x = holdLocation.x - holdCircle.size / 2;
	holdCircle.y = (480 - holdLocation.y) - holdCircle.size / 2;
	
	holdCircle.image = [[ImageModel instance] data];
	holdCircle.data = holdImage.data;
	holdCircle.context = holdImage.context;
	
	[self addCircle: holdCircle];
	
	[self changeKeys: page];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	holdStatus = 0;
	holdLocation = [touch locationInView: self];
	holdTimer = [NSTimer scheduledTimerWithTimeInterval: 0.6
												 target: self
											   selector: @selector(onHold)
											   userInfo: nil
												repeats: NO];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{	
	if (holdStatus != 1)
	{
		UIApplication* delegate = (UIApplication*) [[UIApplication sharedApplication] delegate];
		UIScrollView* scrollView = (UIScrollView*)  [delegate performSelector: @selector(scrollView)];
		
		if (scrollView.alpha == 0)
		{
			[self showControl];
		}
	}
	else
	{
		[circles removeObject: holdCircle];
		
		[holdCircle release];
		[holdImage release];
	}
	
	holdStatus = 2;
}


@end
