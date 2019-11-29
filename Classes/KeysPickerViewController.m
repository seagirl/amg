//
//  KeysPickerViewController.m
//  Amg
//
//  Created by seagirl on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KeysPickerViewController.h"


@interface KeysPickerViewController (PrivateMethods)

- (void) initializeProperties;

@end

@implementation KeysPickerViewController

@synthesize closeLabel, picker;
@synthesize selectedRow1, selectedRow2, selectedRow3;
@synthesize rootKeys, scales, ranges;
@synthesize delegate;

- (void) dealloc
{	
	[delegate release];
	
	[rootKeys release];
	[scales release];
	[ranges release];
	
    [super dealloc];
}

- (void) setSelectedRow1: (NSInteger) value
{
	selectedRow1 = value;
	
	[self.picker selectRow: selectedRow1 inComponent: 0 animated: NO];
}

- (void) setSelectedRow2: (NSInteger) value
{
	selectedRow2 = value;
	
	[self.picker selectRow: selectedRow2 inComponent: 1 animated: NO];
}

- (void) setSelectedRow3: (NSInteger) value
{
	selectedRow3 = value;
	
	[self.picker selectRow: selectedRow3 inComponent: 2 animated: NO];
}


- (void) initializeProperties
{
	if (rootKeys != nil && scales != nil && ranges != nil)
		return;
	
	rootKeys = [[NSArray arrayWithObjects: @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", nil] retain];
	scales = [[NSArray arrayWithObjects: @"Major Scale", @"Minor Scale", @"Ryukyu Scale", @"Whole Tone Scale", nil] retain];
	ranges = [[NSArray arrayWithObjects: @"Low", @"Mid", @"Hi", nil] retain];
}

- (void) pickerView: (UIPickerView *) picker didSelectRow: (NSInteger) row inComponent: (NSInteger) component
{  	
	if (component == 0)
	{
		if (selectedRow1 != row)
		{
			selectedRow1 = row;
			[delegate performSelector: @selector(changeKeys)];
		}
		
	}
	else if (component == 1)
	{
		if (selectedRow2 != row)
		{
			selectedRow2 = row;
			[delegate performSelector: @selector(changeKeys)];
		}
	}
	else if (component == 2)
	{
		if (selectedRow3 != row)
		{
			selectedRow3 = row;
			[delegate performSelector: @selector(changeKeys)];
		}
	}
}  

- (CGFloat) pickerView: (UIPickerView *) pickerView widthForComponent: (NSInteger) component
{
	if (component == 0)
	{
		return 50;
	}
	else if (component == 1)
	{
		return 190;
	}
	else if (component == 2)
	{
		return 80;
	}
	
	return 0;
}

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) picker
{  
    return 3;
}

- (NSInteger) pickerView: (UIPickerView *) picker numberOfRowsInComponent: (NSInteger) component
{  
	[self initializeProperties];
	
	if (component == 0)
	{
		return [rootKeys count];
	}
	else if (component == 1)
	{
		return [scales count];
	}
	else if (component == 2)
	{
		return [ranges count];
	}
	
	return 0;
}

- (NSString *) pickerView: (UIPickerView *) picker titleForRow: (NSInteger) row forComponent: (NSInteger) component
{  
	[self initializeProperties];
	
	if (component == 0)
	{		
		return [rootKeys objectAtIndex: row];
	}
	else if (component == 1)
	{
		return [scales objectAtIndex: row];
	}
	else if (component == 2)
	{

		return [ranges objectAtIndex: row];
	}
	
	return @"";
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
