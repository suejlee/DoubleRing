//
//  DoubleRingViewController.m
//  ViewPractice
//
//  Created by Sue Lee on 9/20(Saturday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "DoubleRingViewController.h"

@interface DoubleRingViewController ()
@property (nonatomic, retain) IBOutlet DoubleRing *progressView;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UIButton *animateButton;
@end

@implementation DoubleRingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)progressChanged:(id)sender
{
    [_progressView setProgress:_progressSlider.value animated:NO];
}

- (IBAction)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    
    [self performSelector:@selector(setOne) withObject:Nil afterDelay:1];
}

- (void)setOne
{
    [_progressView setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:_progressView.animationDuration + .1];
}

- (void)setComplete
{
    [_progressView performAction:ProgressViewActionSuccess animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1];
}

- (void)reset
{
    [_progressView performAction:ProgressViewActionNone animated:YES];
    [_progressView setProgress:0 animated:YES];
    _progressSlider.enabled = YES;
}

@end
