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
#import "XCElementSnapshot.h"
#import "XCUIElement.h"
#import "Tree.h"
#import "ElementInfo.h"
#import "XCUIApplication+Monkey.h"
#import "ElementTree.h"
#import "ClassPath.h"
#import "ClassPathItem.h"
#import "ElementTypeTransformer.h"


@interface Monkey()
@property NSString *testedAppBundleID;
@property XCUIApplication *testedApp;
@property XCEventGenerator *eventGenerator;
@property int screenWidth;
@property int screenHeight;
@end

@implementation Monkey

-(id)initWithBundleID:(NSString*)bundleID
{
    if (self = [super init]) {
        self.testedAppBundleID = bundleID;
        self.testedApp = [[XCUIApplication alloc] initPrivateWithPath:nil bundleID:self.testedAppBundleID];
        self.eventGenerator = [XCEventGenerator sharedGenerator];
        self.screenWidth = 375;
        self.screenHeight = 667;
    }
    return self;
}

-(void)run:(int)steps
{
    [self.testedApp launch];
    [self.testedApp query];
    [self.testedApp resolve];
    for (int i = 0; i < steps; i++) {
        @autoreleasepool {
            [self performAction];
        }
    }
    
    [self.testedApp terminate];
}

-(void)performAction
{
//    [self performActionRandomDrag];
//    [self performActionRandomTap];
    [self performActionRandomLeafElement];
}

-(void)performActionRandomDrag
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
    
    [self.eventGenerator pressAtPoint:point
                          forDuration:0
                          liftAtPoint:pointEnd
                             velocity:1000
                          orientation:self.testedApp.interfaceOrientation
                                 name:@"Monkey Drag"
                              handler:handlerBlock];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)performActionRandomTap
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
    
    [self.eventGenerator tapAtTouchLocations:locations
                                numberOfTaps:1
                                 orientation:self.testedApp.interfaceOrientation
                                     handler:handlerBlock];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)performActionRandomLeafElement
{
    Tree *tree = [self.testedApp tree];
//    NSLog(@"tree: %@", tree);
    NSArray<Tree *> *leaves = [tree leaves];
//    for (Tree *leaf in leaves) {
//        NSLog(@"leaf: %@ %@", leaf.identifier, leaf.data);
//    }
    
    Tree *leafChosen = leaves[arc4random() % leaves.count];
    ClassPath *path = getClassPathForElement(leafChosen);
    NSLog(@"Chosen element: path: %@ data: %@", path, leafChosen.data);
    
    XCUIElement *element = [self findElementByClassPath:path];
    if (element && element.hittable && element.enabled) {
        [element tap];
    }
}

-(XCUIElement *)findElementByClassPath:(ClassPath *)classPath
{
    XCUIElement *element = self.testedApp;
    for (ClassPathItem *pathItem in classPath.pathItems) {
        XCUIElementType elementType = [ElementTypeTransformer elementTypeWithTypeName:pathItem.className];
        element = [[element childrenMatchingType:elementType] elementBoundByIndex:pathItem.index];
    }
    return element;
}

@end
