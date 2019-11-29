//
//  AmViewController.h
//  Am
//
//  Created by yoshizu on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instrument.h"
#import "Canvas.h"
#import "AlgorithmPickerViewController.h"
#import "KeysPickerViewController.h"
#import "UnderLineLabel.h"
#import "Envelope.h"
#import "Slider.h"

@interface AmViewController : UIViewController {
	IBOutlet UILabel *pageNumberLabel;
	IBOutlet UILabel *algorithmTitle;
	IBOutlet UnderLineLabel *algorithmLabel;
	IBOutlet UILabel *keysTitle;
	IBOutlet UnderLineLabel *keysLabel;
	
	int pageNumber;
	
	NSMutableDictionary *model;
	
	Canvas *canvas;
	Slider *interval;
	Envelope *envelope;
	
	Instrument *instrument;
	
	AlgorithmPickerViewController *algorithm;
	KeysPickerViewController *keys;
}

@property (nonatomic, retain) UILabel *pageNumberLabel;
@property (nonatomic, retain) UILabel *algorithmTitle;
@property (nonatomic, retain) UILabel *keysTitle;
@property (nonatomic, retain) UnderLineLabel *algorithmLabel;
@property (nonatomic, retain) UnderLineLabel *keysLabel;

@property int pageNumber;

@property (retain) NSDictionary *model;

@property (retain) Canvas *canvas;
@property (retain) Slider *interval;
@property (retain) Envelope *envelope;

@property (retain) Instrument *instrument;

@property (retain) AlgorithmPickerViewController *algorithm;
@property (retain) KeysPickerViewController *keys;

- (id)initWithPageNumber:(int)page;

- (void) changeAlgorithm;
- (void) changeKeys;
- (void) changeInterval;
- (void) changeEnvelope;

- (void) hideControl;

@end

