//
//  ProgressRingView.m
//  ProgressView
//


#import "ProgressRingView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ProgressRingView ()
@property (nonatomic, retain) NSNumberFormatter *percentageFormatter;
@property (nonatomic, retain) UILabel *percentageLabel;
@property (nonatomic, assign) CGFloat animationFromValue;
@property (nonatomic, assign) CGFloat animationToValue;
@property (nonatomic, assign) CFTimeInterval animationStartTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, retain) CAShapeLayer *progressOutLayer;
@property (nonatomic, retain) CAShapeLayer *progressInLayour;
@property (nonatomic, retain) CAShapeLayer *backgroundInLayour;
@property (nonatomic, retain) CAShapeLayer *backgroundOutLayer;
@property (nonatomic, assign) CGFloat backgroundLineWidth;
@property (nonatomic, assign) CGFloat progressLineWidth;

@end


@implementation ProgressRingView

#pragma mark Initalization and setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    
    //Set defaut sizes
    _backgroundLineWidth = fmaxf(self.bounds.size.width * .025, 1.0);
    _progressLineWidth = 2 * _backgroundLineWidth;
    self.animationDuration = .2;
    
    //Set up the number formatter
    _percentageFormatter = [[NSNumberFormatter alloc] init];
    _percentageFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    //Set up the background layer
    _backgroundOutLayer = [CAShapeLayer layer];
    _backgroundOutLayer.strokeColor = [UIColor blackColor].CGColor;
    _backgroundOutLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundOutLayer.lineCap = kCALineCapRound;
    _backgroundOutLayer.lineWidth = _backgroundLineWidth;
    [self.layer addSublayer:_backgroundOutLayer];
    
    _backgroundInLayour = [CAShapeLayer layer];
    _backgroundInLayour.strokeColor = [UIColor blackColor].CGColor;
    _backgroundInLayour.fillColor = [UIColor clearColor].CGColor;
    _backgroundInLayour.lineCap = kCALineCapRound;
    _backgroundInLayour.lineWidth = _backgroundLineWidth;
    [self.layer addSublayer:_backgroundInLayour];
    
    //Set up the progress layer
    _progressOutLayer = [CAShapeLayer layer];
    _progressOutLayer.strokeColor = [UIColor greenColor].CGColor;
    _progressOutLayer.fillColor = nil;
    _progressOutLayer.lineCap = kCALineCapRound;
    _progressOutLayer.lineWidth = _progressLineWidth;
    [self.layer addSublayer:_progressOutLayer];
    

    //Set up the progress layer
    _progressInLayour = [CAShapeLayer layer];
    _progressInLayour.strokeColor = [UIColor purpleColor].CGColor;
    _progressInLayour.fillColor = nil;
    _progressInLayour.lineCap = kCALineCapRound;
    _progressInLayour.lineWidth = _progressLineWidth;
    [self.layer addSublayer:_progressInLayour];
    
    //Set the label
    _percentageLabel = [[UILabel alloc] init];
    _percentageLabel.textAlignment = NSTextAlignmentCenter;
    _percentageLabel.contentMode = UIViewContentModeCenter;
    _percentageLabel.font = [UIFont systemFontOfSize:(self.bounds.size.width / 10)];
    _percentageLabel.textColor = [UIColor redColor];

    [self addSubview:_percentageLabel];
}

#pragma mark Actions

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    // progress is % value in float
    if (self.progress == progress) { //if the same as current value
        return;
    }
    if (animated == NO) { // when I am moving the slider manually
        if (_displayLink) {
            //Kill running animations
            [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            _displayLink = nil;
        }
        [super setProgress:progress animated:animated];
        [self setNeedsDisplay];
    } else { // when animated
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue = progress;
        if (!_displayLink) {
            //Create and setup the display link
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - _animationStartTime) / self.animationDuration;
        if (dt >= 1.0) { // where it stops
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
            [super setProgress:_animationToValue animated:NO];
            [self setNeedsDisplay];
            return;
        }
        
        //Set progress
        [super setProgress:_animationFromValue + dt * (_animationToValue - _animationFromValue) animated:YES];
        
//        NSLog(@"%f", _animationFromValue + dt * (_animationToValue - _animationFromValue));
        [self setNeedsDisplay];
        
    });
}


#pragma mark Layout

- (void)layoutSubviews
{
    _backgroundOutLayer.frame = self.bounds;
    _progressOutLayer.frame = self.bounds;
    _percentageLabel.frame = self.bounds;
    
    //Redraw
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width;
    }
    [super setFrame:frame];
}

- (CGSize)intrinsicContentSize
{
    //This progress view scales
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawBackgroundOut];
    [self drawBackgroundIn];
    [self drawProgressOut];
    [self drawProgressIn];
}

- (void)drawBackgroundOut
{
    //Create parameters to draw background
    float startAngle = - M_PI_2;
    float endAngle = startAngle + (2.0 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundLineWidth) / 2.0;
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = _backgroundLineWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    _backgroundOutLayer.path = path.CGPath;
}

- (void)drawBackgroundIn
{
    //Create parameters to draw background
    float startAngle = - M_PI_2;
    float endAngle = startAngle + (2.0 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundLineWidth) / 3.0;
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = _backgroundLineWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    _backgroundInLayour.path = path.CGPath;
}

- (void)drawProgressOut
{
    //Create parameters to draw progress
    float startAngle = - M_PI_2;
    float endAngle = startAngle + (2.0 * M_PI * self.progress * 0.1);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundLineWidth) / 2.0; // align center of the background
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = _progressLineWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    [_progressOutLayer setPath:path.CGPath];
    
    //Update label
//        _percentageLabel.text = [NSString stringWithFormat:@"%f(s)", self.progress*self.animationDuration];
    
    _percentageLabel.text = [_percentageFormatter stringFromNumber:[NSNumber numberWithFloat:self.progress]];
}

- (void)drawProgressIn
{
    //Create parameters to draw progress
    float startAngle = - M_PI_2;
    float endAngle = startAngle + (2.0 * M_PI * self.progress);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundLineWidth) / 3.0; // align center of the background
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = _progressLineWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    [_progressInLayour setPath:path.CGPath];
    
}



@end
