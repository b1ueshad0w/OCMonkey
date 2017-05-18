//
//  Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/03/2017.
//
//

#import "Monkey.h"
#import "XCUIApplication.h"
#import "XCUIElement.h"
#import "XCUIApplication+Monkey.h"
#import "RandomAction.h"
#import "RegularAction.h"
#import "Macros.h"


@interface Monkey()
@property NSString *testedAppBundleID;
@property (nonatomic) XCUIApplication *testedApp;
@property CGRect screenFrame;
@property (readwrite) int actionCounter;
@property double totalWeight;
@property NSMutableArray<RandomAction *> *randomActions;
@property NSMutableArray<RegularAction *> *regularActions;
@end

@implementation Monkey

-(id)initWithBundleID:(NSString*)bundleID
{
    return [self initWithBundleID:bundleID launchEnvironment:@{}];
}

-(id)initWithBundleID:(NSString*)bundleID launchEnvironment:(NSDictionary *)launchEnv
{
    if (self = [super init]) {
        _testedAppBundleID = bundleID;
        _testedApp = [[XCUIApplication alloc] initPrivateWithPath:nil bundleID:self.testedAppBundleID];
        _launchEnvironment = [NSMutableDictionary dictionaryWithDictionary:launchEnv];
        /* if test target embeds MonkeyPaws.framework */
        if (![_launchEnvironment objectForKey:@"maxGesturesShown"])
            _launchEnvironment[@"maxGesturesShown"] = @5;
        
        /* Use _testedApp.frame will cause strange issue:
         * _testedApp.lastSnapshot will never change
         */
        _screenFrame = CGRectMake(0, 0, 375, 667);
        
        _actionCounter = 0;
        _regularActions = [[NSMutableArray alloc] init];
        _randomActions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(XCUIApplication *)testedApp
{
    [_testedApp query];
    [_testedApp resolve];
    return _testedApp;
}

-(void)preRun
{
    _testedApp.launchEnvironment = _launchEnvironment;
    [_testedApp launch];
}

-(void)postRun
{
    [_testedApp terminate];
}

-(void)run:(int)steps
{
    [self preRun];
    
    for (int i = 0; i < steps; i++) {
        [NSThread sleepForTimeInterval:0.5];
        @autoreleasepool {
            [self actRandomly];
            [self actRegularly];
        }
    }
    
    [self postRun];
}

-(void)run
{
    [self preRun];
    
    while (YES) {
        @autoreleasepool {
            [self actRandomly];
            [self actRegularly];
        }
    }
    
//    [self postRun];
}

-(void)actRandomly
{
    double x = RandomZeroToOne * _totalWeight;
    for (RandomAction *action in _randomActions) {
        if (x < action.accumulatedWeight) {
            action.action();
            return;
        }
    }
}

-(void)actRegularly
{
    _actionCounter += 1;
    for (RegularAction *action in _regularActions) {
        if (_actionCounter % action.interval == 0) {
            action.action();
        }
    }
}

-(void)addAction:(ActionBlock)action withWeight:(double)weight
{
    _totalWeight += weight;
    [_randomActions addObject:[[RandomAction alloc] initWithWeight:_totalWeight action:action]];
}

-(void)addAction:(ActionBlock)action  withInterval:(int)interval
{
    [_regularActions addObject:[[RegularAction alloc] initWithInterval:interval action:action]];
}

-(CGPoint)randomPoint
{
    return [self randomPointInRect:_screenFrame];
}

-(CGPoint)randomPointInRect:(CGRect)rect
{
    return CGPointMake(rect.origin.x + RandomZeroToOne * rect.size.width,
                       rect.origin.y + RandomZeroToOne * rect.size.height);
}

-(CGPoint)randomPointAvoidingPanelAreas
{
    CGFloat topHeight = 30;
    CGFloat bottomHeight = 25;
    CGRect frameWithoutTopAndBottom = CGRectMake(0,
                                                 topHeight,
                                                 _screenFrame.size.width,
                                                 _screenFrame.size.height - topHeight - bottomHeight);
    return [self randomPointInRect:frameWithoutTopAndBottom];
}

-(CGRect)randomRect
{
    return [self rectAround:[self randomPoint] inRect:_screenFrame];
}

-(CGRect)randomRectWithSizeFraction:(CGFloat)sizeFraction
{
    return [self rectAround:[self randomPoint] sizeFraction:sizeFraction inRect:_screenFrame];
}

-(CGRect)rectAround:(CGPoint)point inRect:(CGRect)inRect
{
    return [self rectAround:point sizeFraction:3 inRect:inRect];
}


-(CGRect)rectAround:(CGPoint)point sizeFraction:(float)sizeFraction inRect:(CGRect)inRect
{
    CGFloat size = MIN(_screenFrame.size.width, _screenFrame.size.height) / sizeFraction;
    CGFloat x0 = (point.x - _screenFrame.origin.x) * (_screenFrame.size.width - size) / _screenFrame.size.width + _screenFrame.origin.x;
    CGFloat y0 = (point.y - _screenFrame.origin.y) * (_screenFrame.size.height - size) / _screenFrame.size.width  + _screenFrame.origin.y;
    return CGRectMake(x0, y0, size, size);
}

@end
