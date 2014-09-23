//
//  DoubleRingViewController.h
//  ViewPractice
//
//  Created by Sue Lee on 9/20(Saturday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleRingView.h"

@interface DoubleRingViewController : UIViewController

@property (nonatomic, retain) IBOutlet DoubleRing *progressView;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UIButton *animateButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *iconControl;
@property (nonatomic, retain) IBOutlet UISwitch *indeterminateSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *showPercentageSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *separationControl;

- (IBAction)animateProgress:(id)sender;
- (IBAction)progressChanged:(id)sender;
- (IBAction)iconChanged:(id)sender;
- (IBAction)indeterminateChanged:(id)sender;
- (IBAction)showPercentage:(id)sender;
- (IBAction)separationChanged:(id)sender;

@end

