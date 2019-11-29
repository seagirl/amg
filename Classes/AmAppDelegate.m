//
//  AmAppDelegate.m
//  Am
//
//  Created by yoshizu on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AmAppDelegate.h"
#import "AmViewController.h"

static NSUInteger kNumberOfPages = 3;

@interface AmAppDelegate (PrivateMethods)

- (void) loadScrollViewWithPage: (int) page;
- (void) scrollViewDidScroll: (UIScrollView *) sender;

@end

@implementation AmAppDelegate

@synthesize window, canvas, scrollView, pageControl, clock;
@synthesize viewControllers;
@synthesize currentPage;

- (void) dealloc
{
	[viewControllers release];
	
	[clock release];
	[canvas release];
	[scrollView release];
	[pageControl release];
	[window release];
	
	[super dealloc];
}

+ (void) initialize
{
    if ([self class] == [AmAppDelegate class]) {
        NSDictionary *resourceDict = [NSDictionary dictionaryWithObject: @"YES" forKey: @"isFirst"];
        [[NSUserDefaults standardUserDefaults] registerDefaults: resourceDict];
    }
}


- (void) applicationDidFinishLaunching: (UIApplication *) application
{	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
	clock.alpha = 0;
	
	clockTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
												  target: self
												selector: @selector(didPassed)
												userInfo: nil
												 repeats: YES];
	
    sleep(1);
	
	AppModel *model = [AppModel instance];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *version = [defaults stringForKey: @"version"];
	BOOL isFirst = [defaults boolForKey: @"isFirst"];
		
	// バージョンアップの時にどうにかしたいことを書く
	if ([version isEqualToString: @"1.0"] == NO)
	{		
		[defaults setObject: @"1.0" forKey: @"version"];
		
		isFirst = YES;
	}
	
	if (isFirst == YES)
	{
		[defaults setBool: NO forKey: @"isFirst"];
		
		[model initData];
		
		[defaults setObject: model.data0 forKey: @"data0"];
		[defaults setObject: model.data1 forKey: @"data1"];
		[defaults setObject: model.data2 forKey: @"data2"];
		
		UIAlertView *alert = [[UIAlertView alloc]  
							  initWithTitle: @"Hello!"  
							  message: @"To generate a sound, simply shake iPhone, or change the algorithm settings from \"None\" to \"Random\"."
							  delegate: self  
							  cancelButtonTitle: nil  
							  otherButtonTitles: @"OK", nil];  
		[alert show];  
		[alert release];
	}
	else
	{
		model.data0 = [NSMutableDictionary dictionaryWithDictionary: [defaults dictionaryForKey: @"data0"]];
		model.data1 = [NSMutableDictionary dictionaryWithDictionary: [defaults dictionaryForKey: @"data1"]];
		model.data2 = [NSMutableDictionary dictionaryWithDictionary: [defaults dictionaryForKey: @"data2"]];
	}
	
	self.currentPage = 0;
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	
	for (unsigned i = 0; i < kNumberOfPages; i++) {
		[controllers addObject: [NSNull null]];
	}
	
	self.viewControllers = controllers;
	
	[controllers release];
	
	isShaking = NO;
	isRespondingShake = NO;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval: 0.1];  
    [[UIAccelerometer sharedAccelerometer] setDelegate: self];
	
	canvas.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
	
	scrollView.pagingEnabled = YES;
	scrollView.alwaysBounceHorizontal = YES;
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.scrollsToTop = NO;
	scrollView.delaysContentTouches = NO;
	scrollView.delegate = self;
	scrollView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
	
	pageControl.numberOfPages = kNumberOfPages;
	pageControl.currentPage = 0;
	
	[self loadScrollViewWithPage: 0];
	[self loadScrollViewWithPage: 1];
	[self loadScrollViewWithPage: 2];
}

- (void) applicationWillTerminate: (UIApplication *) application
{	
	NSLog(@"Terminate Application");
}

- (void) applicationWillResignActive: (UIApplication*) application
{
	[self.canvas stopAnimation];
}

- (void) applicationDidBecomeActive: (UIApplication*) application
{
	[self.canvas clearView];
	[self.canvas startAnimation];
}

- (void) didPassed
{
	if (clock.alpha == 0)
		return;
	
	NSDate* now = [NSDate date];
	unsigned components = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents* date = [[NSCalendar currentCalendar] components: components fromDate: now];
	
	clock.text = [NSString stringWithFormat: @"%02d:%02d:%02d", date.hour, date.minute, date.second];
}

- (void) loadScrollViewWithPage: (int) page
{	
	if (page < 0 || page >= kNumberOfPages)
		return;
	
	AmViewController *controller = [viewControllers objectAtIndex: page];
	
	if ((NSNull *) controller == [NSNull null])
	{
		AppModel *model = [AppModel instance];
		
		controller = [[AmViewController alloc] initWithPageNumber: page];
		
		switch (page) {
			case 0:
				controller.model = model.data0;
				break;
			case 1:
				controller.model = model.data1;
				break;
			case 2:
				controller.model = model.data2;
				break;
		}
		
		controller.canvas = canvas;
		
		[viewControllers replaceObjectAtIndex: page withObject: controller];
		
		[controller release];
	}
	else
	{
		controller.algorithmLabel.alpha = 1;
		controller.keysLabel.alpha = 1;
	}
	
	if (nil == controller.view.superview) {
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
		controller.view.frame = frame;
		[scrollView addSubview: controller.view];
	}
}

- (void) scrollViewDidScroll: (UIScrollView *) sender
{
	if (pageControlUsed)
		return;
	
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.currentPage = pageControl.currentPage = page;
	
	[self loadScrollViewWithPage: page - 1];
	[self loadScrollViewWithPage: page];
	[self loadScrollViewWithPage: page + 1];
}


- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
	pageControlUsed = NO;
}

- (void) accelerometer: (UIAccelerometer*) accelerometer didAccelerate: (UIAcceleration*) acceleration
{  
    const float violence = 2.0;
    BOOL shake = NO;
	
    if (isShaking || isRespondingShake)
		return;
	
    isShaking = YES;  
    
	if (acceleration.x > violence || acceleration.x < -1 * violence)  
        shake = YES;  
    
	if (acceleration.y > violence || acceleration.y < -1 * violence)  
        shake = YES;  
    
	if (acceleration.z > violence || acceleration.z < -1 * violence)  
        shake = YES;  
	
	if (shake)
	{
		isRespondingShake = YES;
		
		shakeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
													  target: self
													selector: @selector(didRespondShake)
													userInfo: nil
													 repeats: NO];
		
		int counter = 0;
		
		for (AmViewController* controller in viewControllers)
		{
			if ((NSNull *) controller == [NSNull null])
				continue;
			
			if (controller.algorithm.selectedRow == 0)
				continue;
				
			counter++;
		}
		
		for (AmViewController* controller in viewControllers)
		{
			if ((NSNull *) controller == [NSNull null])
				continue;
			
			if (counter == 0)
			{
				[controller hideControl];
				
				controller.algorithm.selectedRow = 1;
			}
			else
			{
				[canvas showControl];
				
				controller.algorithm.selectedRow = 0;
			}
			
			[controller changeAlgorithm];
		}
    }
	
    isShaking = NO;  
}  

- (void) didRespondShake
{
	isRespondingShake = NO;
}

- (IBAction) changePage: (id) sender
{
	int page = pageControl.currentPage;

	[self loadScrollViewWithPage: page - 1];
	[self loadScrollViewWithPage: page];
	[self loadScrollViewWithPage: page + 1];

	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible: frame animated: YES];

	pageControlUsed = YES;
}



@end
