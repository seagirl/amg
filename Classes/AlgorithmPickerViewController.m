//
//  AlgorithmPickerViewController.m
//  Amg
//
//  Created by seagirl on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AlgorithmPickerViewController.h"

@interface AlgorithmPickerViewController (PrivateMethods)

- (void) initializeProperties;

@end

@implementation AlgorithmPickerViewController

@synthesize closeLabel, picker;
@synthesize selectedRow;
@synthesize titles;
@synthesize delegate;

- (void) dealloc
	{
	[titles release];
	
	[delegate release];
	
    [super dealloc];
}

- (void) setSelectedRow: (NSInteger) value
{
	selectedRow = value;
	
	[self.picker selectRow: selectedRow inComponent: 0 animated: NO];
}

- (void) initializeProperties
{
	if (titles != nil)
		return;
	
	titles = [[NSArray arrayWithObjects: @"None", @"Random", nil] retain];
}

- (void) pickerView: (UIPickerView*) picker didSelectRow: (NSInteger) row  inComponent: (NSInteger) component
{  		
	if (selectedRow != row)
	{
		selectedRow = row;
		[delegate performSelector: @selector(changeAlgorithm)];
	}
}  

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) picker
{  
    return 1;  
}  

- (NSInteger) pickerView: (UIPickerView*) picker numberOfRowsInComponent: (NSInteger) component
{  
	[self initializeProperties];
	
    return [titles count];  
}

- (NSString*) pickerView: (UIPickerView*) picker titleForRow: (NSInteger) row forComponent: (NSInteger) component
{  
	[self initializeProperties];
		
	return [titles objectAtIndex: row];
} 

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == closeLabel)
	{
		if (self.view.alpha != 1)
			return;
		
		closeLabel.alpha = 0.5;
	}
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == closeLabel || [touch view] == self.view)
	{
		if (self.view.alpha != 1)
			return;
		
		closeLabel.alpha = 1;
		
		[UIView beginAnimations: nil context: NULL];
		[UIView setAnimationDuration: 0.2];
		
		self.view.alpha = 0;
		
		[UIView commitAnimations];
		
		[self.view removeFromSuperview];
	}
}


@end
