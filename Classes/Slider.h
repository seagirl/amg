//
//  Slider.h
//  Amg
//
//  Created by yoshizu on 1/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thumb.h"

@interface Slider : UIView {
	float value;
	
	Thumb *thumb;
	
	UIViewController *delegate;
	
	SEL onChange;
	SEL onTouchesBegan;
	SEL onTouchesEnd;
}

@property float value;
@property (retain) Thumb *thumb;
@property (retain) UIViewController *delegate;

@property SEL onChange;
@property SEL onTouchesBegan;
@property SEL onTouchesEnd;

@end
