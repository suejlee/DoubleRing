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
@property (nonatomic, retain) CAShapeLayer *progressLayer;
@property (nonatomic, retain) CAShapeLayer *progressSecondLayer;
@property (nonatomic, retain) CAShapeLayer *backgroundSecondLayer;
@property (nonatomic, retain) CAShapeLayer *backgroundLayer;
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
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = [UIColor blackColor].CGColor;
    _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = _backgroundLineWidth;
    [self.layer addSublayer:_backgroundLayer];
    
    _backgroundSecondLayer = [CAShapeLayer layer];
    _backgroundSecondLayer.strokeColor = [UIColor blackColor].CGColor;
    _backgroundSecondLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundSecondLayer.lineCap = kCALineCapRound;
    _backgroundSecondLayer.lineWidth = _backgroundLineWidth;
    [self.layer addSublayer:_backgroundSecondLayer];
    
    //Set up the progress layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.strokeColor = [UIColor greenColor].CGColor;
    _progressLayer.fillColor = nil;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _progressLineWidth;
    [self.layer addSublayer:_progressLayer];
    

    //Set up the progress layer
    _progressSecondLayer = [CAShapeLayer layer];
    _progressSecondLayer.strokeColor = [UIColor purpleColor].CGColor;
    _progressSecondLayer.fillColor = nil;
    _progressSecondLayer.lineCap = kCALineCapRound;
    _progressSecondLayer.lineWidth = _progressLineWidth;
    [self.layer addSublayer:_progressSecondLayer];
    
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
        if (dt >= 1.0) {
            //Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
            [super setProgress:_animationToValue animated:NO];
            [self setNeedsDisplay];
            return;
        }
        
        //Set progress
        [super setProgress:_animationFromValue + dt * (_animationToValue - _animationFromValue) animated:YES];
        [self setNeedsDisplay];
        
    });
}


#pragma mark Layout

- (void)layoutSubviews
{
    _backgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
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
    [self drawBackground];
    [self drawBackgroundSecond];
    [self drawProgress];
    [self drawProgressSecond];
}

- (void)drawBackground
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
    _backgroundLayer.path = path.CGPath;
}

- (void)drawBackgroundSecond
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
    _backgroundSecondLayer.path = path.CGPath;
}

- (void)drawProgress
{
    //Create parameters to draw progress
    float startAngle = - M_PI_2;
    float endAngle = startAngle + (2.0 * M_PI * self.progress);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundLineWidth) / 2.0; // align center of the background
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = _progressLineWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    [_progressLayer setPath:path.CGPath];
    
    //Update label
//        _percentageLabel.text = [NSString stringWithFormat:@"%f(s)", self.progress*self.animationDuration];
    
    _percentageLabel.text = [_percentageFormatter stringFromNumber:[NSNumber numberWithFloat:self.progress]];
}

- (void)drawProgressSecond
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
    [_progressSecondLayer setPath:path.CGPath];
    
}



@end
