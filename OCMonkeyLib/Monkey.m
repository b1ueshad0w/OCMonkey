//
//  Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/03/2017.
//
//

#import "Monkey.h"
#import "GGApplication.h"
#import "XCUIElement.h"
#import "XCUIElement+Tree.h"
#import "RandomAction.h"
#import "RegularAction.h"
#import "Macros.h"
#import "GGLogger.h"
#import "GGExceptionHandler.h"
#import "GGSpringboardApplication.h"
#import "XCUIDevice+Monkey.h"
#import "XCApplicationMonitor_iOS.h"
#import "XCApplicationMonitor.h"
#import "XCUIApplicationProcess.h"
#import "XCUIApplicationImpl.h"


@interface Monkey()
@property (nonatomic) XCUIApplication *testedApp;
@property (readwrite) int actionCounter;
@property double totalWeight;
@property NSMutableArray<RandomAction *> *randomActions;
@property NSMutableArray<RegularAction *> *regularActions;
@property (nonatomic, readwrite) NSDate *endTime;
@property (nonatomic, readwrite) NSString *exitReason;
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
        _testedApp = [[GGApplication alloc] initWithBundleID:self.testedAppBundleID];
        _launchEnvironment = [NSMutableDictionary dictionaryWithDictionary:launchEnv];
        /* if test target embeds MonkeyPaws.framework */
        if (![_launchEnvironment objectForKey:@"maxGesturesShown"])
            _launchEnvironment[@"maxGesturesShown"] = @5;
        
        NSString *crashDelay = [[NSProcessInfo processInfo] environment][@"MakeAppCrashAfterSeconds"];
        if (crashDelay) {
            _launchEnvironment[@"MakeAppCrashAfterSeconds"] = crashDelay;
        }
        
        /* Use _testedApp.frame will cause strange issue:
         * _testedApp.lastSnapshot will never change
         */
        _screenFrame = CGRectMake(0, 0, 375, 667);
        
        _actionCounter = 0;
        _regularActions = [[NSMutableArray alloc] init];
        _randomActions = [[NSMutableArray alloc] init];
        _startTime = [NSDate date];
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
    @try {
        [_testedApp terminate];
    } @catch (NSException *exception) {
        ;
    } @finally {
        ;
    }
    [GGLogger log:@"Monkey will exit."];
}

-(void)runOneStep
{
    [self actRandomly];
    [self actRegularly];
}

-(void)run:(int)steps
{
    [self preRun];
    static dispatch_once_t onceToken;
    for (int i = 0; i < steps; i++) {
        if (i % 100 == 0) {
            [GGLogger logFmt:@"Monkey step count: %d", i];
        }
        [NSThread sleepForTimeInterval:0.5];
        @autoreleasepool {
            dispatch_once(&onceToken, ^{      
                _screenFrame = self.testedApp.frame;
                _testedAppIdentifier = self.testedApp.label;
                _testedAppPid = self.testedApp.processID;
            });
//            [self runOneStep];
            @try {
                [self runOneStep];
            } @catch (NSException *exception) {
                if ([exception.name isEqualToString:GGApplicationCrashedException] ||
                    [exception.name isEqualToString:GGApplicationDeadlockDetectedException]) {
                    _exitReason = exception.name;
                    [GGLogger logFmt:@"Monkey loop will exit because: %@", exception.reason];
                }
                else {
                    [GGLogger logFmt:@"Exception: %@ %@", exception, [exception.callStackSymbols componentsJoinedByString:@"\n"]];
                    _exitReason = @"Monkey internal crash.";
                }
                break;
            }
//            @finally {
//            }
        }
    }
    _endTime = [NSDate date];
    if (!_exitReason) {
        _exitReason = @"Normal ends.";
    }
    @try {
        [self postRun];
    } @catch (NSException *exception) {
        [GGLogger logFmt:@"Exception: %@ %@", exception, [exception.callStackSymbols componentsJoinedByString:@"\n"]];
    }
}

-(void)run
{
    [self preRun];
    
    while (YES) {
        @autoreleasepool {
            [self runOneStep];
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

-(void)checkAppState
{
    /*
    if (_testedApp.applicationImpl.currentProcess.running) {
        NSLog(@"App is running");
    } else {
        NSLog(@"App process is not running.");
    }
    return;
    NSArray<XCUIApplicationImpl *> *appImpls = [XCApplicationMonitor_iOS sharedMonitor].monitoredApplications;
    XCUIApplication *app = [[XCApplicationMonitor_iOS sharedMonitor] monitoredApplicationWithProcessIdentifier:_testedAppPid];
    XCUIApplicationProcess *process = [app.applicationImpl currentProcess];
    
    NSSet *set = [NSSet setWithObject:process];
    XCUIApplicationProcess *result = [[XCApplicationMonitor_iOS sharedMonitor] _appFromSet:set thatTransitionedToNotRunningDuringTimeInterval:3];
     */
    
    int activeAppPid = [GGApplication activeAppProcessID];
    if (activeAppPid == _testedApp.processID) {
        return;
    }
    [GGLogger logFmt:@"TestedApp is not active."];
    pid_t springboardPid = [GGSpringboardApplication springboardProcessID];
    
    /* Three cases:
     1. Authorization Alert shows (It belongs to Springboard process)
     2. Springboard Desktop shows
     3. Another app shows
     */
    if (activeAppPid != springboardPid) { // case 3
        [[XCUIDevice sharedDevice] pressHome];
        activeAppPid = [GGApplication activeAppProcessID];
        if (activeAppPid != springboardPid) {
            [[NSException exceptionWithName:GGMonkeyInternalError reason:@"Press Home buton failed." userInfo:nil] raise];
        }
    }
    if (activeAppPid == springboardPid) { // case 1 or case 2
        [self checkAndHandleSpringboardAlerts];
        if ([GGApplication activeAppProcessID] != _testedAppPid) {
            [[GGSpringboardApplication springboard] tapApplicationWithIdentifier:_testedAppIdentifier error:nil];
        }
    } else {
        [[NSException exceptionWithName:GGMonkeyInternalError
                                 reason:@"Unexpected active app's process id."
                               userInfo:nil]
         raise];
    }
    // TestedApp is expected to be active for now
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    pid_t activeAppPidAfterFix = [GGApplication activeAppProcessID];
    if (activeAppPidAfterFix == springboardPid) {
        NSString *msg = @"Could not bring back testedApp from Springboard";
        [[NSException exceptionWithName:GGMonkeyInternalError
                                 reason:msg
                               userInfo:nil]
         raise];
    } else if (activeAppPidAfterFix != _testedAppPid) {
        NSString *msg = @"Application's processID is changed. It may possibly had crashed.";
        [GGLogger log:msg];
        [[NSException exceptionWithName:GGApplicationCrashedException
                                 reason:msg
                               userInfo:nil]
         raise];
    }
}

-(void)checkAndHandleSpringboardAlerts {
    
//    [self.testedApp resolveHandleUIInterruption:YES];
//    return;
//    XCUIElementQuery *query = [[GGSpringboardApplication springboard] descendantsMatchingType:XCUIElementTypeAlert];
//    XCUIElement *alert = [query elementBoundByIndex:0];
//    if (!alert)
//        return;
    ElementTree *tree = [[GGSpringboardApplication springboard] tree];
    NSArray<ElementTree *> *alerts = [tree descendantsMatchingType:XCUIElementTypeAlert];
    if (0 == alerts.count) {
        return;
    }
    ElementTree *alert = alerts[0];
    [GGLogger logFmt:@"SpringBoard Alert appears: %@", alert.data];
    ElementTreeArray *buttons = [alert descendantsMatchingType:XCUIElementTypeButton];
    NSAssert(buttons.count > 0, @"Springboard Alert has no buttons!");
    if (1 == buttons.count) {
        [buttons.lastObject tap];
    } else {
        // 允许 不允许
        [buttons.lastObject tap];
    }
}

@end
