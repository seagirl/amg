//
//  AmViewController.m
//  Am
//
//  Created by yoshizu on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AmViewController.h"
#import "AmAppDelegate.h"

void audioSessionInterruptionListener(void *inUserData, UInt32 interruptionState)
{
	AmViewController *controller = (AmViewController *) inUserData;
	
	if (interruptionState == kAudioSessionBeginInterruption)
	{
		NSLog(@"interruptionState: begin");
		[controller.instrument stop];
	}
	else if (interruptionState == kAudioSessionEndInterruption)
	{
		NSLog(@"interruptionState: end");
		[controller.instrument start];
	}
}

@interface AmViewController (PrivateMethods)

- (void) createBar;
- (void) createInstrument;

- (void) createAlgorithm;
- (void) createKeys;
- (void) createInterval;
- (void) createEnvelope;

- (void) showAlgorithmPicker;
- (void) showKeysPicker;

- (void) enableScrollView;
- (void) disableScrollView;

@end

@implementation AmViewController

@synthesize pageNumberLabel, algorithmTitle, algorithmLabel, keysTitle, keysLabel;
@synthesize pageNumber;
@synthesize model;
@synthesize canvas, interval, envelope;
@synthesize instrument;
@synthesize algorithm, keys;


- (void) dealloc
{
	[pageNumberLabel release];
	[algorithmLabel release];
	[keysLabel release];
	
	[model release];
	
	[canvas release];
	[interval release];
	[envelope release];
	
	[instrument release];
	
	[algorithm release];
	[keys release];
	
    [super dealloc];
}

- (id)initWithPageNumber: (int) page
{
    if (self = [super initWithNibName: @"AmView" bundle:nil]) {
		AudioSessionInitialize(NULL, NULL, audioSessionInterruptionListener, self);
		
        pageNumber = page;
    }
	
    return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
	
    pageNumberLabel.text = [NSString stringWithFormat: @"%d", pageNumber + 1];
	
	[self createInstrument];
	
	[self createAlgorithm];
	[self createKeys];
	[self createInterval];
	[self createEnvelope];
}

- (void) createInstrument
{	
	instrument = [[Instrument instrumentWithType: pageNumber] retain];
	instrument.canvas = canvas;
}

- (void) createAlgorithm
{
	algorithm = [[AlgorithmPickerViewController alloc] initWithNibName: @"AlgorithmPicker" bundle: nil];
	algorithm.delegate = self;
	algorithm.view.alpha = 0;
	
	int algorithmIndex = [(NSString *) [model objectForKey: @"algorithmIndex"] intValue];
	
	algorithm.selectedRow = algorithmIndex;
	
	[self changeAlgorithm];
	
	if (algorithmIndex != 0)
		[self hideControl];
}

- (void) createKeys
{
	keys = [[KeysPickerViewController alloc] initWithNibName: @"KeysPicker" bundle:nil];
	keys.delegate = self;
	keys.view.alpha = 0;
	
	int rootKey = [(NSString *) [model objectForKey: @"rootKey"] intValue];
	int scaleIndex = [(NSString *) [model objectForKey: @"scaleIndex"] intValue];
	int range = [(NSString *) [model objectForKey: @"range"] intValue];
	
	keys.selectedRow1 = rootKey;
	keys.selectedRow2 = scaleIndex;
	keys.selectedRow3 = range;
	
	[self changeKeys];
}

- (void) createInterval
{
	CGRect frame = CGRectMake(30, 206, 260, 64);
	
	interval = [[[Slider alloc] initWithFrame: frame] retain];
	interval.delegate = self;
	interval.onChange = @selector(changeInterval);
	interval.onTouchesBegan = @selector(disableScrollView);
	interval.onTouchesEnd = @selector(enableScrollView);
	
	interval.value = [(NSString *) [model objectForKey: @"interval"] floatValue];
	
	[self changeInterval];
	[self.view addSubview: interval];
}

- (void) createEnvelope
{
	CGRect frame = CGRectMake(30, 308, 256, 140);
	
	envelope = [[[Envelope alloc] initWithFrame: frame] retain];
	envelope.delegate = self;
	envelope.onChange = @selector(changeEnvelope);
	envelope.onTouchesBegan = @selector(disableScrollView);
	envelope.onTouchesEnd = @selector(enableScrollView);
	
	envelope.volume = [(NSString *) [model objectForKey: @"volume"] floatValue];
	envelope.attack = [(NSString *) [model objectForKey: @"attack"] floatValue];
	envelope.decay = [(NSString *) [model objectForKey: @"decay"] floatValue];
	envelope.sustain = [(NSString *) [model objectForKey: @"sustain"] floatValue];
	envelope.release = [(NSString *) [model objectForKey: @"release"] floatValue];
	[envelope validateProperties];
	
	[self changeEnvelope];
	[self.view addSubview: envelope];
}

- (void) changeAlgorithm
{	
	[model setValue: [NSString stringWithFormat: @"%d", algorithm.selectedRow] forKey: @"algorithmIndex"];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: model forKey: [NSString stringWithFormat: @"data%d", pageNumber]];
	
	if (algorithm.selectedRow == 0) {
		[instrument stop];
	}
	else if (algorithm.selectedRow == 1) {
		[instrument start];
	}
	
	algorithmLabel.text = [algorithm.titles objectAtIndex: algorithm.selectedRow];
	
	CGRect textRect = [algorithmLabel textRectForBounds: [self.view frame] limitedToNumberOfLines: 1];
	
	CGRect frame = [algorithmLabel frame];
	frame.size.width = textRect.size.width;
	frame.size.height = textRect.size.height;
	[algorithmLabel setFrame: frame];
}

- (void) changeKeys
{	
	[model setValue: [NSString stringWithFormat: @"%d", keys.selectedRow1] forKey: @"rootKey"];
	[model setValue: [NSString stringWithFormat: @"%d", keys.selectedRow2] forKey: @"scaleIndex"];
	[model setValue: [NSString stringWithFormat: @"%d", keys.selectedRow3] forKey: @"range"];
	 
	if (keys.selectedRow3 == 0) {
		[model setValue: @"36" forKey: @"minimumKey"];
		[model setValue: @"50" forKey: @"maximumKey"];
	}
	else if (keys.selectedRow3 == 1) {
		[model setValue: @"50" forKey: @"minimumKey"];
		[model setValue: @"64" forKey: @"maximumKey"];
	}
	else if (keys.selectedRow3 == 2) {
		[model setValue: @"64" forKey: @"minimumKey"];
		[model setValue: @"78" forKey: @"maximumKey"];
	}
	
	instrument.model = model;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: model forKey: [NSString stringWithFormat: @"data%d", pageNumber]];
	
	keysLabel.text = [NSString stringWithFormat: @"%@ %@, %@",
					  [keys.rootKeys objectAtIndex: keys.selectedRow1],
					  [keys.scales objectAtIndex: keys.selectedRow2],
					  [keys.ranges objectAtIndex: keys.selectedRow3]];
	
	CGRect textRect = [keysLabel textRectForBounds: [self.view frame] limitedToNumberOfLines: 1];
	
	CGRect frame = [keysLabel frame];
	frame.size.width = textRect.size.width;
	frame.size.height = textRect.size.height;
	[keysLabel setFrame: frame];
}

- (void) changeInterval
{	
	[model setValue: [NSString stringWithFormat: @"%f", interval.value] forKey: @"interval"];
	
	instrument.model = model;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: model forKey: [NSString stringWithFormat: @"data%d", pageNumber]];
}

- (void) changeEnvelope
{	
	[model setValue: [NSString stringWithFormat: @"%f", envelope.volume] forKey: @"volume"];
	[model setValue: [NSString stringWithFormat: @"%f", envelope.attack] forKey: @"attack"];
	[model setValue: [NSString stringWithFormat: @"%f", envelope.decay] forKey: @"decay"];
	[model setValue: [NSString stringWithFormat: @"%f", envelope.sustain] forKey: @"sustain"];
	[model setValue: [NSString stringWithFormat: @"%f", envelope.release] forKey: @"release"];
	
	instrument.model = model;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: model forKey: [NSString stringWithFormat: @"data%d", pageNumber]];
}

- (void) showAlgorithmPicker
{
	algorithmLabel.alpha = 1;
	
	[self.view.superview.superview addSubview: algorithm.view];
	
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.2];
	
	algorithm.view.alpha = 1;
	
	[UIView commitAnimations];
}

- (void) showKeysPicker
{
	keysLabel.alpha = 1;
	
	[self.view.superview.superview addSubview: keys.view];
	
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.2];
	
	keys.view.alpha = 1;
	
	[UIView commitAnimations];
}


- (void) enableScrollView
{
	UIScrollView *scrollView = (UIScrollView *) self.view.superview;
	scrollView.scrollEnabled = YES;
}

- (void) disableScrollView
{
	UIScrollView *scrollView = (UIScrollView *) self.view.superview;
	scrollView.scrollEnabled = NO;
}

- (void) hideControl
{
	AmAppDelegate* delegate = (AmAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 1.0];
	
	delegate.scrollView.alpha = 0;
	delegate.pageControl.alpha = 0;
	delegate.clock.alpha = 1;
	delegate.canvas.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{	
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == algorithmLabel ||
		[touch view] == keysLabel)
	{
		UILabel *label = (UILabel *) [touch view];
		label.alpha = 0.5;
	}
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2)
	{
		UIApplication* delegate = (UIApplication*) [[UIApplication sharedApplication] delegate];
		UIScrollView* scrollView = (UIScrollView*)  [delegate performSelector: @selector(scrollView)];
		
		if (scrollView.alpha == 1)
		{
			[self hideControl];
		}

		return;
	}
	
	if ([touch view] == algorithmLabel || [touch view] == algorithmTitle)
	{
		[self showAlgorithmPicker];
	}
	else if ([touch view] == keysLabel || [touch view] == keysTitle)
	{
		[self showKeysPicker];
	}
}

@end
