//
//  DoubleRingViewController.m
//  ViewPractice
//
//  Created by Sue Lee on 9/20(Saturday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "DoubleRingViewController.h"

@interface DoubleRingViewController ()

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

- (void)progressChanged:(id)sender
{
    [_progressView setProgress:_progressSlider.value animated:NO];
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    _iconControl.enabled = NO;
    _indeterminateSwitch.enabled = NO;
    
    [self performSelector:@selector(setQuarter) withObject:Nil afterDelay:1];
}

- (void)setQuarter
{
    [_progressView setProgress:.25 animated:YES];
    [self performSelector:@selector(setTwoThirds) withObject:nil afterDelay:3];
}

- (void)setTwoThirds
{
    [_progressView setProgress:.66 animated:YES];
    [self performSelector:@selector(setThreeQuarters) withObject:nil afterDelay:1];
}

- (void)setThreeQuarters
{
    [_progressView setProgress:.75 animated:YES];
    [self performSelector:@selector(setOne) withObject:nil afterDelay:1.5];
}

- (void)setOne
{
    [_progressView setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:_progressView.animationDuration + .1];
}

- (void)setComplete
{
    [_progressView performAction:ProgressViewActionSuccess animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1.5];
}

- (void)reset
{
    [_progressView performAction:ProgressViewActionNone animated:YES];
    [_progressView setProgress:0 animated:YES];
    //Enable other controls
    _progressSlider.enabled = YES;
    _iconControl.enabled = YES;
    _indeterminateSwitch.enabled = YES;
}

- (void)iconChanged:(id)sender
{
    if (_iconControl.selectedSegmentIndex == 0) {
        //Change progress view icon to none
        [_progressView performAction:ProgressViewActionNone animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 1) {
        //Change progress view icon to success
        [_progressView performAction:ProgressViewActionSuccess animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 2) {
        //Change to failure
        [_progressView performAction:ProgressViewActionFailure animated:YES];
    }
}

- (void)indeterminateChanged:(id)sender
{
    if (_indeterminateSwitch.on) {
        _progressSlider.enabled = NO;
        _iconControl.enabled = NO;
        _animateButton.enabled = NO;
        //Set to indeterminate mode
        [_progressView setIndeterminate:YES];
    } else {
        _progressSlider.enabled = YES;
        _iconControl.enabled = YES;
        _animateButton.enabled = YES;
        //Disable indeterminate mode
        [_progressView setIndeterminate:NO];
    }
}

- (void)showPercentage:(id)sender
{
    [_progressView setShowPercentage:_showPercentageSwitch.on];
}

- (void)separationChanged:(id)sender
{
    if (_separationControl.selectedSegmentIndex == 0) {
        [_progressView setSegmentBoundaryType:SegmentBoundaryTypeWedge];
    } else {
        [_progressView setSegmentBoundaryType:SegmentBoundaryTypeRectangle];
    }
}

@end
