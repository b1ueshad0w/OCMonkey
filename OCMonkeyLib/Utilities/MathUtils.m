//
//  MathUtils.m
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#import "MathUtils.h"

CGFloat GGDefaultFrameFuzzyThreshold = 2.0;

CGPoint getRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

BOOL isFrameInFrame(CGRect guest, CGRect host)
{
    return CGRectContainsPoint(host, getRectCenter(guest));
}

BOOL isFloatEqualToFloat(CGFloat float1, CGFloat float2, CGFloat threshold)
{
    return (fabs(float1 - float2) <= threshold);
}

BOOL isPointEqualToPoint(CGPoint point1, CGPoint point2, CGFloat threshold)
{
    return
    isFloatEqualToFloat(point1.x, point2.x, threshold) &&
    isFloatEqualToFloat(point1.y, point2.y, threshold);
}

BOOL isSizeEqualToSize(CGSize size1, CGSize size2, CGFloat threshold)
{
    return
    isFloatEqualToFloat(size1.width, size2.width, threshold) &&
    isFloatEqualToFloat(size1.height, size2.height, threshold);
}

BOOL isRectEqualToRect(CGRect rect1, CGRect rect2, CGFloat threshold)
{
    return
    isPointEqualToPoint(getRectCenter(rect1), getRectCenter(rect2), threshold) &&
    isSizeEqualToSize(rect1.size, rect2.size, threshold);
}
