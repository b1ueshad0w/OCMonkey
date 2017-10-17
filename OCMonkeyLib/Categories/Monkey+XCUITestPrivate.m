//
//  Monkey+XCUITestPrivate.m
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#import "Monkey+XCUITestPrivate.h"
#import "XCEventGenerator.h"
#import "XCUIApplication.h"
#import "XCUIElement+Tree.h"
#import "Macros.h"
#import "MathUtils.h"
#import "Monkey.h"
#import "Tree.h"
#import "ElementInfo.h"
#import "GGLogger.h"

#import "XCPointerEventPath.h"
#import "XCSynthesizedEventRecord.h"
#import "XCTestDaemonsProxy.h"
#import "XCTestManager_ManagerInterface-Protocol.h"
#import "RunLoopSpinner.h"

UIInterfaceOrientation orientationValue = UIInterfaceOrientationPortrait;

@interface Monkey ()

@end


@implementation Monkey (XCUITestPrivate)

#pragma mark Configure Monkey Event Types and Weights

-(void)addDefaultXCTestPrivateActions
{
    [self addXCTestTapAction:25];
    [self addXCTestLongPressAction:1];
    [self addXCTestDragAction:1];
    [self addXCTestPinchCloseAction:1];
    [self addXCTestPinchOpenAction:1];
    [self addXCTestRotateAction:1];
    [self addMonkeyLeafElementAction:25];
}


-(void)addXCTestTapAction:(double)weight
{
    [self addXCTestTapAction:weight
      multipleTapProbability:0.05
    multipleTouchProbability:0.05];
}


/**
 For testing Monkey methods:
    [Monkey randomRect]
    [Monkey randomPointInRect:]
 */
-(void)addXCTestTapAction:(double)weight inRect:(CGRect)rect
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        CGPoint point = [weakSelf randomPointInRect:rect];
        NSArray *locations = @[[NSValue valueWithCGPoint:point]];
        [Monkey tapAtTouchLocations:locations numberOfTaps:1 orientation:orientationValue];
    }    withWeight:weight];

}


-(void)addXCTestTapAction:(double)weight
   multipleTapProbability:(double)multiTap
 multipleTouchProbability:(double)multiTouch
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        int numberOfTaps;
        if (RandomZeroToOne < multiTap) {
            numberOfTaps = 2 + arc4random() % 2;
        } else {
            numberOfTaps = 1;
        }

        NSMutableArray *locations = [[NSMutableArray alloc] init];
        if (RandomZeroToOne < multiTouch) {
            int numberOfTouches = arc4random() % 3 + 2;
            CGRect rect = [weakSelf randomRect];
            for (int i = 1; i < numberOfTouches; i++) {
                CGPoint point = [weakSelf randomPointInRect:rect];
                [locations addObject:[NSValue valueWithCGPoint:point]];
                // [GGLogger logFmt:@"point %d: {%.1f, %.1f}", i, point.x, point.y);
            }
        } else {
            CGPoint point = [weakSelf randomPoint];
            [locations addObject:[NSValue valueWithCGPoint:point]];
            // [GGLogger logFmt:@"point: {%.1f, %.1f}", point.x, point.y);
        }
        [Monkey tapAtTouchLocations:locations numberOfTaps:numberOfTaps orientation:orientationValue];
    }    withWeight:weight];
}


-(void)addXCTestLongPressAction:(int)weight
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        CGPoint point = [weakSelf randomPoint];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[XCEventGenerator sharedGenerator] pressAtPoint:point
                                             forDuration:0.5
                                             orientation:orientationValue
                                                 handler:^(XCSynthesizedEventRecord *record, NSError *commandError) {
                                                     if (commandError) {
                                                         [GGLogger logFmt:@"Failed to perform step: %@", commandError];
                                                     }
                                                     dispatch_semaphore_signal(semaphore);
                                                 }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } withWeight:weight];
}


-(void)addXCTestDragAction:(int)weight
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        CGPoint start = [weakSelf randomPointAvoidingPanelAreas];
        CGPoint end = [weakSelf randomPoint];
        [Monkey dragFrom:start to:end];
    } withWeight:weight];
}


-(void)addXCTestPinchCloseAction:(int)weight
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        CGRect rect = [weakSelf randomRectWithSizeFraction:2];
        CGFloat scale = 1 / (CGFloat)(RandomZeroToOne * 4 + 1);
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[XCEventGenerator sharedGenerator] pinchInRect:rect
                                             withScale:scale
                                                velocity:1
                                             orientation:orientationValue
                                                 handler:^(XCSynthesizedEventRecord *record, NSError *commandError) {
                                                     if (commandError) {
                                                         [GGLogger logFmt:@"Failed to perform step: %@", commandError];
                                                     }
                                                     dispatch_semaphore_signal(semaphore);
                                                 }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } withWeight:weight];
}


-(void)addXCTestPinchOpenAction:(int)weight
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        CGRect rect = [weakSelf randomRectWithSizeFraction:2];
        CGFloat scale = (CGFloat)(RandomZeroToOne * 4 + 1);
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[XCEventGenerator sharedGenerator] pinchInRect:rect
                                              withScale:scale
                                               velocity:3
                                            orientation:orientationValue
                                                handler:^(XCSynthesizedEventRecord *record, NSError *commandError) {
                                                    if (commandError) {
                                                        [GGLogger logFmt:@"Failed to perform step: %@", commandError];
                                                    }
                                                    dispatch_semaphore_signal(semaphore);
                                                }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } withWeight:weight];
}


-(void)addXCTestRotateAction:(int)weight
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        CGRect rect = [weakSelf randomRectWithSizeFraction:2];
        CGFloat angle = (CGFloat)(RandomZeroToOne * 2 * 3.141592);
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[XCEventGenerator sharedGenerator] rotateInRect:rect
                                            withRotation:angle
                                               velocity:5
                                            orientation:orientationValue
                                                handler:^(XCSynthesizedEventRecord *record, NSError *commandError) {
                                                    if (commandError) {
                                                        [GGLogger logFmt:@"Failed to perform step: %@", commandError];
                                                    }
                                                    dispatch_semaphore_signal(semaphore);
                                                }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } withWeight:weight];
}


-(void)addMonkeyLeafElementAction:(int)weight
{
    __typeof__(self) __weak weakSelf = self;
    [self addAction:^(void){
        [weakSelf performActionRandomLeafElement];
    } withWeight:weight];
}


-(void)performActionRandomLeafElement
{
    ElementTree *tree = [self.testedApp tree];
    ElementTreeArray *leaves = [tree leaves];
    ElementTree *leafChosen = leaves[arc4random() % leaves.count];
    //    Tree *leafChosen = leaves[0];
    [GGLogger logFmt:@"Chosen element: id: %@ data: %@", leafChosen.identifier, leafChosen.data];
    //    [GGLogger logFmt:@"tree: %@", tree);
    //    for (Tree *leaf in leaves) {
    //        [GGLogger logFmt:@"leaf: %@ %@", leaf.identifier, leaf.data);
    //    }
    
    [leafChosen tap];
}


#pragma mark Tap

+(void)tapAtLocation:(CGPoint)location
{
    [Monkey tapAtTouchLocations:@[[NSValue valueWithCGPoint:location]]
                   numberOfTaps:1
                    orientation:orientationValue];
}


+(void)tapAtTouchLocations:(NSArray *)locations
              numberOfTaps:(int)taps
               orientation:(UIInterfaceOrientation)orientationValue
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    XCEventGeneratorHandler handlerBlock = ^(XCSynthesizedEventRecord *record, NSError *commandError) {
        if (commandError) {
            [GGLogger logFmt:@"Failed to perform step: %@", commandError];
        }
        dispatch_semaphore_signal(semaphore);
    };
    
    [[XCEventGenerator sharedGenerator] tapAtTouchLocations:locations
                                               numberOfTaps:taps
                                                orientation:orientationValue
                                                    handler:handlerBlock];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

#pragma mark Swipe

+(void)swipeRightThroughFrame:(CGRect)frame
{
    CGFloat halfHeight = frame.size.height / 2;
    CGPoint start = CGPointMake(0, halfHeight);
    CGPoint end = CGPointMake(frame.size.width - 10, halfHeight);
    [Monkey dragFrom:start to:end duration:0 velocity:2000];
}


+(void)swipeRightThroughFrame:(CGRect)frame forDuration:(double)duration velocity:(double)velocity
{
    CGFloat halfHeight = frame.size.height / 2;
    CGPoint start = CGPointMake(0, halfHeight);
    CGPoint end = CGPointMake(frame.size.width - 10, halfHeight);
    [Monkey dragFrom:start to:end duration:duration velocity:velocity];
}


+(void)swipeUpFrame:(CGRect)frame
{
    [Monkey swipeFrame:frame vertically:NO];
}


+(void)swipeDownFrame:(CGRect)frame
{
    [Monkey swipeFrame:frame vertically:YES];
}

+(void)swipeLeftFrame:(CGRect)frame
{
    CGFloat halfHeight = frame.size.height / 2;
    CGPoint start = CGPointMake(frame.size.width / 5, halfHeight);
    CGPoint end = CGPointMake(frame.size.width / 5 * 4, halfHeight);
    [Monkey swipeFrom:end to:start];
}

+(void)swipeRightFrame:(CGRect)frame
{
    CGFloat halfHeight = frame.size.height / 2;
    CGPoint start = CGPointMake(frame.size.width / 5, halfHeight);
    CGPoint end = CGPointMake(frame.size.width / 5 * 4, halfHeight);
    [Monkey swipeFrom:start to:end];
}

+(void)swipeFrame:(CGRect)frame vertically:(BOOL)reversed
{
    CGFloat halfWidth = frame.size.width /2;
    CGPoint start = CGPointMake(halfWidth, frame.size.height / 5);
    CGPoint end = CGPointMake(halfWidth, frame.size.height / 5 * 4);
    if (reversed) {
        [Monkey swipeFrom:start to:end];
    } else {
        [Monkey swipeFrom:end to:start];
    }
}


+(void)swipeFrom:(CGPoint)start to:(CGPoint)end
{
    [Monkey dragFrom:start to:end duration:0 velocity:4000];
}


#pragma mark Drag

+(void)dragFrom:(CGPoint)start to:(CGPoint)end
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[XCEventGenerator sharedGenerator] pressAtPoint:start
                                         forDuration:0
                                         liftAtPoint:end
                                            velocity:1000
                                         orientation:orientationValue
                                                name:@"Monkey drag"
                                             handler:^(XCSynthesizedEventRecord *record, NSError *commandError) {
                                                 if (commandError) {
                                                     [GGLogger logFmt:@"Failed to perform drag: %@", commandError];
                                                 }
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


+(void)dragFrom:(CGPoint)start to:(CGPoint)end duration:(double)duration velocity:(double)velocity
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[XCEventGenerator sharedGenerator] pressAtPoint:start
                                         forDuration:duration
                                         liftAtPoint:end
                                            velocity:velocity
                                         orientation:orientationValue
                                                name:@"Monkey drag"
                                             handler:^(XCSynthesizedEventRecord *record, NSError *commandError) {
                                                 if (commandError) {
                                                     [GGLogger logFmt:@"Failed to perform drag: %@", commandError];
                                                 }
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


#pragma mark low level

-(void)dragFrom:(CGPoint)start AtOffset:(double)a to:(CGPoint)end AtOffset:(double)b liftUpAtOffset3:(double)c
{
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:start offset:a];
    [path moveToPoint:end atOffset:b];
    [path liftUpAtOffset:c];
    XCSynthesizedEventRecord *record = [[XCSynthesizedEventRecord alloc] initWithName:@"gogle swipe" interfaceOrientation:UIInterfaceOrientationPortrait];
    [record addPointerEventPath:path];
    [RunLoopSpinner spinUntilCompletion:^(void(^completion)()){
        [[XCTestDaemonsProxy testRunnerProxy] _XCT_synthesizeEvent:record completion:^(NSError *error) {
            NSLog(@"error: %@", error);
            if (error) {
                [GGLogger logFmt:@"Operation failed: %@", error];
            }
            completion();
        }];
    }];
}

@end
