//
//  MathUtils.h
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#ifndef MathUtils_h
#define MathUtils_h

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

extern CGFloat GGDefaultFrameFuzzyThreshold;

CGPoint getRectCenter(CGRect rect);

BOOL isFloatEqualToFloat(CGFloat float1, CGFloat float2, CGFloat threshold);

BOOL isPointEqualToPoint(CGPoint point1, CGPoint point2, CGFloat threshold);

BOOL isSizeEqualToSize(CGSize size1, CGSize size2, CGFloat threshold);

BOOL isRectEqualToRect(CGRect rect1, CGRect rect2, CGFloat threshold);

/**
 Determine whether a frame's center is inside another frame

 @param guest the previous frame
 @param host the latter frame
 @return BOOL
 */
BOOL isFrameInFrame(CGRect guest, CGRect host);



#endif /* MathUtils_h */
