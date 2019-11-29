//
//  AlgorithmPickerViewController.h
//  Amg
//
//  Created by seagirl on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlgorithmPickerViewController : UIViewController <UIPickerViewDelegate> {
	IBOutlet UILabel *closeLabel;
	IBOutlet UIPickerView *picker;
	
	NSInteger selectedRow;
	
	NSArray *titles;
	
	UIViewController *delegate;
}

@property (nonatomic, retain) UILabel *closeLabel;
@property (nonatomic, retain) UIPickerView *picker;

@property NSInteger selectedRow;

@property (retain) NSArray *titles;

@property (retain) UIViewController *delegate;

@end
