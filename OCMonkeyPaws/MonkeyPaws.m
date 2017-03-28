//
//  MonkeyPaws.m
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import "MonkeyPaws.h"
#import "UIApplication+Monkey.h"
#import <objc/runtime.h>
#import "Gesture.h"

const int maxGesturesShown = 15;
const CGFloat crossRadius = 7;
const CGFloat circleRadius = 7;

@interface MonkeyPaws () <CALayerDelegate>
@end

@implementation MonkeyPaws

+(NSMutableArray<MonkeyPaws*>*)tappingTracks
{
    static NSMutableArray<MonkeyPaws*> *tracks = nil;
    if (tracks == nil) {
        // create tracks;
        tracks = [NSMutableArray array];
    }
    return tracks;
}

+(int)maxGesturesShown
{
    static int _maxGesturesShown = nil;
    if (_maxGesturesShown == nil) {
        _maxGesturesShown = [[[NSProcessInfo processInfo] environment][@"maxGesturesShown"] intValue];
        if (!_maxGesturesShown)
            _maxGesturesShown = maxGesturesShown;
    }
    return _maxGesturesShown;
}

-(id)initWithView:(UIView *)view tapUIApplication: (BOOL)tap
{
    self = [super init];
    if (self) {
        _gestures = [NSMutableArray array];
        _view = view;
        
        _layer = [CALayer layer];
        _layer.delegate = self;
        _layer.opaque = NO;
        _layer.frame = view.layer.bounds;
        _layer.contentsScale = [[UIScreen mainScreen] scale];
        _layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        [view.layer addSublayer:_layer];
        
        if (tap) {
            [self tapUIApplicationSendEvent];
        }
        
    }
    return self;
}

-(void)append:(UIEvent *)event
{
    if (event.type != UIEventTypeTouches) {
        return;
    }
    if (!event.allTouches) {
        return;
    }
    for (UITouch *touch in event.allTouches) {
        [self appendTouch: touch];
    }
    
    [self bumpAndDisplayLayer];
}

-(void)appendTouch2:(UITouch *)touch
{
    const CGPoint point = [touch locationInView:_view];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = nil;
    layer.position = point;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-circleRadius, -circleRadius, circleRadius * 2, circleRadius * 2)];
    layer.path = path.CGPath;
    
    [_layer addSublayer:layer];
}

-(void)appendTouch:(UITouch *)touch
{
    if (!_view) {
        return;
    }
    
    const NSUInteger touchHash = [touch hash];
    const CGPoint point = [touch locationInView:_view];
    
    NSUInteger index = [_gestures indexOfObjectPassingTest:^(GestureHash *gestureHash, NSUInteger idx, BOOL *stop) {
        BOOL found = gestureHash.hashValue == touchHash;
        if (found) {
            *stop = YES;
        } else {
            *stop = NO;
        }
        return found;
    }];
    
    if (index != NSNotFound) {
        Gesture *gesture = _gestures[index].gesture;
        UITouchPhase phase = [touch phase];
        if (phase == UITouchPhaseEnded) {
            [_gestures[index].gesture end:point];
            _gestures[index].hashValue = 0;
        } else if (phase == UITouchPhaseCancelled) {
            [_gestures[index].gesture cancel:point];
            _gestures[index].hashValue = 0;
        } else  {
            [gesture extend:point];
        }
    } else {
        if ([_gestures count] > [MonkeyPaws maxGesturesShown]) {
            [_gestures removeObjectAtIndex:0];
        }
        [_gestures addObject:[[GestureHash alloc] initWithHash:touchHash
                                                      gesture:[[Gesture alloc] initFrom:point inLayer:_layer]]];
        for (int i = 0; i < [_gestures count]; i++) {
            _gestures[i].gesture.number = (int)[_gestures count] - i;
        }
    }
}

-(void)tapUIApplicationSendEvent
{
    [self swizzleMethods];
    [[MonkeyPaws tappingTracks] addObject:self];
}

-(BOOL)swizzleMethods
{
    Class class = [UIApplication class];
    SEL originalSelector = @selector(sendEvent:);
    SEL swizzledSelector = @selector(monkey_sendEvent:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

-(void)bumpAndDisplayLayer
{
    CALayer *superlayer = _layer.superlayer;
    if (!_layer.superlayer)
        return;
    NSArray<CALayer *> *layers = superlayer.sublayers;
    if (!layers)
        return;
    NSUInteger index = [layers indexOfObject:_layer];
    if (index == NSNotFound)
        return;
    
    if (index != [layers count] -1) {
        [_layer removeFromSuperlayer];
        [superlayer addSublayer:_layer];
    }
    
    _layer.frame = superlayer.bounds;
    
    [_layer setNeedsDisplay];
    [_layer displayIfNeeded];
    
}

@end
