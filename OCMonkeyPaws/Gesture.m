//
//  Gesture.m
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import "Gesture.h"
#import "math.h"
#import "MonkeyPaws.h"

static int count = 0;

UIBezierPath* monkeyHandPath(CGFloat angle, CGFloat scale, BOOL mirrored)
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    
    [bezierPath moveToPoint:CGPointMake(-5.91, 8.76)];
    [bezierPath addCurveToPoint: CGPointMake(-10.82, 2.15) controlPoint1: CGPointMake(-9.18, 7.11) controlPoint2: CGPointMake(-8.09, 4.9)];
    [bezierPath addCurveToPoint: CGPointMake(-16.83, -1.16) controlPoint1: CGPointMake(-13.56, -0.6) controlPoint2: CGPointMake(-14.65, 0.5)];
    [bezierPath addCurveToPoint: CGPointMake(-14.65, -6.11) controlPoint1: CGPointMake(-19.02, -2.81) controlPoint2: CGPointMake(-19.57, -6.66)];
    [bezierPath addCurveToPoint: CGPointMake(-8.09, -2.81) controlPoint1: CGPointMake(-9.73, -5.56) controlPoint2: CGPointMake(-8.64, -0.05)];
    [bezierPath addCurveToPoint: CGPointMake(-11.37, -13.82) controlPoint1: CGPointMake(-7.54, -5.56) controlPoint2: CGPointMake(-7, -8.32)];
    [bezierPath addCurveToPoint: CGPointMake(-7.54, -17.13) controlPoint1: CGPointMake(-15.74, -19.33) controlPoint2: CGPointMake(-9.73, -20.98)];
    [bezierPath addCurveToPoint: CGPointMake(-4.27, -8.87) controlPoint1: CGPointMake(-5.36, -13.27) controlPoint2: CGPointMake(-6.45, -7.76)];
    [bezierPath addCurveToPoint: CGPointMake(-4.27, -18.23) controlPoint1: CGPointMake(-2.08, -9.97) controlPoint2: CGPointMake(-3.72, -12.72)];
    [bezierPath addCurveToPoint: CGPointMake(0.65, -18.23) controlPoint1: CGPointMake(-4.81, -23.74) controlPoint2: CGPointMake(0.65, -25.39)];
    [bezierPath addCurveToPoint: CGPointMake(1.2, -8.32) controlPoint1: CGPointMake(0.65, -11.07) controlPoint2: CGPointMake(-0.74, -9.29)];
    [bezierPath addCurveToPoint: CGPointMake(3.93, -18.78) controlPoint1: CGPointMake(2.29, -7.76) controlPoint2: CGPointMake(3.93, -9.3)];
    [bezierPath addCurveToPoint: CGPointMake(8.3, -16.03) controlPoint1: CGPointMake(3.93, -23.19) controlPoint2: CGPointMake(9.96, -21.86)];
    [bezierPath addCurveToPoint: CGPointMake(5.57, -6.11) controlPoint1: CGPointMake(7.76, -14.1) controlPoint2: CGPointMake(3.93, -6.66)];
    [bezierPath addCurveToPoint: CGPointMake(9.4, -10.52) controlPoint1: CGPointMake(7.21, -5.56) controlPoint2: CGPointMake(9.16, -10.09)];
    [bezierPath addCurveToPoint: CGPointMake(12.13, -6.66) controlPoint1: CGPointMake(12.13, -15.48) controlPoint2: CGPointMake(15.41, -9.42)];
    [bezierPath addCurveToPoint: CGPointMake(8.3, -1.16) controlPoint1: CGPointMake(8.85, -3.91) controlPoint2: CGPointMake(8.85, -3.91)];
    [bezierPath addCurveToPoint: CGPointMake(8.3, 7.11) controlPoint1: CGPointMake(7.76, 1.6) controlPoint2: CGPointMake(9.4, 4.35)];
    [bezierPath addCurveToPoint: CGPointMake(-5.91, 8.76) controlPoint1: CGPointMake(7.21, 9.86) controlPoint2: CGPointMake(-2.63, 10.41)];
    [bezierPath closePath];
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(0.5, 0)];
    [bezierPath applyTransform:CGAffineTransformMakeScale(scale, scale)];
    
    if (mirrored) {
        [bezierPath applyTransform:CGAffineTransformMakeScale(-1, 1)];
    }
    
    [bezierPath applyTransform:CGAffineTransformMakeRotation(angle / 180 * M_PI)];
    
    return bezierPath;
}

UIBezierPath* circlePath()
{
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-circleRadius, -circleRadius, circleRadius * 2, circleRadius * 2)];
    
}

UIBezierPath* crossPath()
{
    return nil;
}

@implementation Gesture

+(int)counter
{
    return count;
}

-(id)initFrom:(CGPoint)from inLayer:(CALayer*)inLayer
{
    self = [super init];
    if (self) {
        self.points = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:from], nil];
        
        count += 1;
        
        CGFloat angle = 45 * (CGFloat)((fmod((float)count * 0.279, 1)) * 2 - 1);
        BOOL mirrored = count % 2 == 0;
        UIColor *colour = [UIColor colorWithHue:(CGFloat)(fmod(((float)count) * 0.391, 1)) saturation:1 brightness:0.5 alpha:1];
        self.startLayer = [CAShapeLayer layer];
        self.containerLayer = [CALayer layer];
        self.startLayer.path = monkeyHandPath(angle, 1, mirrored).CGPath;
        self.startLayer.strokeColor = colour.CGColor;
        self.startLayer.fillColor = nil;
        self.startLayer.position = from;
        [self.containerLayer addSublayer:self.startLayer];
        
        self.numberLayer = [CATextLayer layer];
        self.numberLayer.string = @"1";
        self.numberLayer.bounds = CGRectMake(0, 0, 32, 13);
        self.numberLayer.fontSize = 10;
        self.numberLayer.alignmentMode = kCAAlignmentCenter;
        self.numberLayer.foregroundColor = colour.CGColor;
        self.numberLayer.position = from;
        self.numberLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.containerLayer addSublayer:self.numberLayer];
        
        [inLayer addSublayer:self.containerLayer];
    }
    return self;
}

-(void)dealloc
{
    [_containerLayer removeFromSuperlayer];
}

-(void)setNumber:(int)number
{
    _number = number;
    _numberLayer.string = [NSString stringWithFormat:@"%d", number];
    float fraction = (float)(number - 1) / (float)[MonkeyPaws maxGesturesShown];
    float alpha = sqrtf(1 - fraction);
    _containerLayer.opacity = alpha;
}

-(void)extend:(CGPoint)to
{
    
    if (!_startLayer.path || !_points[0]) {
        NSAssert(NO, @"No start marker layer exist.");
    }
    CGPoint startPoint = [_points[0] CGPointValue];
    [_points addObject:[NSValue valueWithCGPoint:to]];
    
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.strokeColor = _startLayer.strokeColor;
        _pathLayer.fillColor = nil;
        
        CGMutablePathRef maskPath = CGPathCreateMutable();
        CGPathAddRect(maskPath, nil, CGRectMake(-10000, -10000, 20000, 20000));
        CGPathAddPath(maskPath, nil, _startLayer.path);
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        maskLayer.position = _startLayer.position;
        _pathLayer.mask = maskLayer;
        CGPathRelease(maskPath);
        
        
        [_containerLayer addSublayer:_pathLayer];
        
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    for (int i = 1; i < [_points count]; i++) {
        CGPoint point = [_points[i] CGPointValue];
        CGPathAddLineToPoint(path, nil, point.x, point.y);
    }
    _pathLayer.path = path;
    CGPathRelease(path);
}

-(void)end:(CGPoint)at
{
    NSAssert(!_endLayer, @"Attempted to end or cancel a gesture twice!");
    
    [self extend:at];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = _startLayer.strokeColor;
    layer.fillColor = nil;
    layer.position = at;
    
    UIBezierPath *path = circlePath();
    layer.path = path.CGPath;
    
    [_containerLayer addSublayer:layer];
    _endLayer = layer;
}

-(void)cancel:(CGPoint)at
{
    NSAssert(!_endLayer, @"Attempted to end or cancel a gesture twice!");
    [self extend:at];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = _startLayer.strokeColor;
    layer.fillColor = nil;
    layer.position = at;
    
    UIBezierPath *path = crossPath();
    layer.path = path.CGPath;
    
    [_containerLayer addSublayer:layer];
    _endLayer = layer;
}

@end
