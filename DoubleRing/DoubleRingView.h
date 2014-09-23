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

@property (nonatomic, assign) CGFloat progressRingLineWidth;
@property (nonatomic, assign) NSInteger numberOfSegments;
@property (nonatomic, assign) CGFloat segmentSeparationAngle;
@property (nonatomic, assign) SegmentBoundaryType segmentBoundaryType;
@property (nonatomic, assign) BOOL showPercentage;


@end
