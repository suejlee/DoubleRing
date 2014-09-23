//
//  ProgressView.h
//  ProgressView
//

#import <UIKit/UIKit.h>

typedef enum {
    ProgressViewActionNone,
    ProgressViewActionSuccess,
    ProgressViewActionFailure
} ProgressViewAction;

@interface ProgressView : UIView

@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, retain) UIColor *secondaryColor;

@property (nonatomic, assign) BOOL indeterminate;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, readonly) CGFloat progress;

/**@name Actions*/
/**Set the progress of the `ProgressView`.
 @param progress The progress to show on the progress view.
 @param animated Wether or not to animate the progress change.*/
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
/**Perform the given action if defined. Usually showing success or failure.
 @param action The action to perform.
 @param animated Wether or not to animate the change*/
- (void)performAction:(ProgressViewAction)action animated:(BOOL)animated;

@end
