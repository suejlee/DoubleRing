//
//  RingViewController.m
//  ProgressView
//

#import "RingViewController.h"

@interface RingViewController ()
@property (nonatomic, retain) IBOutlet ProgressRingView *progressView;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UIButton *animateButton;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation RingViewController

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
    [_progressView setAnimationDuration:_speedSlider.value];
    
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

- (IBAction)speedChanged:(id)sender
{
    [_progressView setAnimationDuration:_speedSlider.value];
    _speedLabel.text = [NSString stringWithFormat:@"%f", _speedSlider.value];
}

- (IBAction)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;

    [_progressView setProgress:1 animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1.5];

}

- (void)reset
{
    [_progressView setProgress:0 animated:YES];
    _progressSlider.enabled = YES;
}

@end
