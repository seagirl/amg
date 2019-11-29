//
//  AmAppDelegate.h
//  Am
//
//  Created by yoshizu on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "Canvas.h"

@class AmViewController;

@interface AmAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate, UIAccelerometerDelegate> {
	IBOutlet UIWindow* window;
	IBOutlet Canvas* canvas;
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	IBOutlet UILabel* clock;
	
	NSMutableArray *viewControllers;
	
	BOOL pageControlUsed;
	int currentPage;
	
	BOOL isShaking;
	BOOL isRespondingShake;
	NSTimer* shakeTimer;
	
	NSTimer* clockTimer;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Canvas *canvas;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel* clock;

@property (nonatomic, retain) NSMutableArray *viewControllers;

@property int currentPage;

- (IBAction) changePage: (id) sender;

@end

