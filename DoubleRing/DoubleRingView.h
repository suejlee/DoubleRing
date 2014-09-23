//
//  DoubleRingView.h
//  ViewPractice
//
//  Created by Sue Lee on 9/20(Saturday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

typedef enum {
    SegmentBoundaryTypeWedge,
    SegmentBoundaryTypeRectangle
} SegmentBoundaryType;

#import "ProgressView.h"

/**Progress is shown by a ring split up into segments.*/
@interface DoubleRing : ProgressView

/**@name Appearance*/
/**The width of the progress ring in points.*/
@property (nonatomic, assign) CGFloat progressRingWidth;
/**The number of segments to display in the progress view.*/
@property (nonatomic, assign) NSInteger numberOfSegments;
/**The angle of the separation between the segments in radians.*/
@property (nonatomic, assign) CGFloat segmentSeparationAngle;
/**The type of boundary between segments.*/
@property (nonatomic, assign) SegmentBoundaryType segmentBoundaryType;
/**@name Percentage*/
/**Wether or not to display a percentage inside the ring.*/
@property (nonatomic, assign) BOOL showPercentage;


@end
