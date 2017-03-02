//
//  Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/03/2017.
//
//

#import "Monkey.h"
#import "XCUIApplication.h"
#import "XCEventGenerator.h"


@interface Monkey()
@property NSString *testedAppBundleID;
@property XCEventGenerator *eventGenerator;
@property int screenWidth;
@property int screenHeight;
@end

@implementation Monkey

-(id)initWithBundleID:(NSString*)bundleID
{
    if (self = [super init]) {
        self.testedAppBundleID = bundleID;
        self.eventGenerator = [XCEventGenerator sharedGenerator];
        self.screenWidth = 375;
        self.screenHeight = 667;
    }
    return self;
}

-(void)run:(int)steps
{
    XCUIApplication *app = [[XCUIApplication alloc] initPrivateWithPath:nil bundleID:self.testedAppBundleID];
    [app launch];
    
    for (int i = 0; i < steps; i++) {
        @autoreleasepool {
            [self one_step:app];
        }
    }
    
    [app terminate];
}

-(void)one_step:(XCUIApplication *)app
{
//    [self random_drag:app];
    [self random_tap:app];
}

-(void)random_drag:(XCUIApplication *)app
{
    float from_x = arc4random() % self.screenWidth;
    float from_y = arc4random() % self.screenHeight;
    float to_x = arc4random() % self.screenWidth;
    float to_y = arc4random() % self.screenHeight;
    CGPoint point = {from_x, from_y};
    CGPoint pointEnd = {to_x, to_y};
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    XCEventGeneratorHandler handlerBlock = ^(XCSynthesizedEventRecord *record, NSError *commandError) {
        if (commandError) {
            NSLog(@"Failed to perform step: %@", commandError);
        }
        dispatch_semaphore_signal(semaphore);
    };
    
    //    if ([eventGenerator respondsToSelector:@selector(tapAtTouchLocations:numberOfTaps:orientation:handler:)]) {
    //        [eventGenerator tapAtTouchLocations:@[[NSValue valueWithCGPoint:point]] numberOfTaps:1 orientation:app.interfaceOrientation handler:handlerBlock];
    //    }
    
    [self.eventGenerator pressAtPoint:point forDuration:0 liftAtPoint:pointEnd velocity:1000 orientation:app.interfaceOrientation name:@"Monkey Drag" handler:handlerBlock];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)random_tap:(XCUIApplication *)app
{
    
    float x = arc4random() % self.screenWidth;
    float y = arc4random() % self.screenHeight;
    CGPoint point = {x, y};
    NSArray *locations = @[[NSValue valueWithCGPoint:point]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    XCEventGeneratorHandler handlerBlock = ^(XCSynthesizedEventRecord *record, NSError *commandError) {
        if (commandError) {
            NSLog(@"Failed to perform step: %@", commandError);
        }
        dispatch_semaphore_signal(semaphore);
    };
    
    [self.eventGenerator tapAtTouchLocations:locations numberOfTaps:1 orientation:app.interfaceOrientation handler:handlerBlock];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
@end
