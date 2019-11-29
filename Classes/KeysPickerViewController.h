//
//  KeysPickerViewController.h
//  Amg
//
//  Created by seagirl on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeysPickerViewController : UIViewController <UIPickerViewDelegate> {
	IBOutlet UILabel *closeLabel;
	IBOutlet UIPickerView *picker;
	
	NSInteger selectedRow1;
	NSInteger selectedRow2;
	NSInteger selectedRow3;
	
	NSArray *rootKeys;
	NSArray *scales;
	NSArray *ranges;
	
	UIViewController *delegate;
}

@property (nonatomic, retain) UILabel *closeLabel;
@property (nonatomic, retain) UIPickerView *picker;

@property NSInteger selectedRow1;
@property NSInteger selectedRow2;
@property NSInteger selectedRow3;

@property (retain) NSArray *rootKeys;
@property (retain) NSArray *scales;
@property (retain) NSArray *ranges;

@property (retain) UIViewController *delegate;

@end
