//
//  Envelope.h
//  Ambient
//
//  Created by yoshizu on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thumb.h";

@interface Envelope : UIView {
	float volume;
	float attack;
	float decay;
	float sustain;
	float release;
	
	Thumb *point1;
	Thumb *point2;
	
	UIViewController *delegate;
	
	SEL onChange;
	SEL onTouchesBegan;
	SEL onTouchesEnd;
}

@property float volume;
@property float attack;
@property float decay;
@property float sustain;
@property float release;

@property (retain) Thumb *point1;
@property (retain) Thumb *point2;

@property (retain) UIViewController *delegate;

@property SEL onChange;
@property SEL onTouchesBegan;
@property SEL onTouchesEnd;

- (void) validateProperties;

@end
