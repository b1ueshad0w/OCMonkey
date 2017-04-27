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
@property (nonatomic) XCUIApplication *testedApp;
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

-(XCUIApplication *)testedApp
{
    [_testedApp query];
    [_testedApp resolve];
    return _testedApp;
}

-(void)run:(int)steps
{
    [_testedApp launch];
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
    [self tap:point];
}

-(void)tap:(CGPoint)location
{
    NSArray *locations = @[[NSValue valueWithCGPoint:location]];
    
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

-(CGPoint)getCenter:(CGRect)rect
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

-(void)performActionRandomLeafElement
{
    XCUIApplication *app = self.testedApp;
    Tree *tree = [app tree];
    NSArray<Tree *> *leaves = [tree leaves];
    Tree *leafChosen = leaves[arc4random() % leaves.count];
//    Tree *leafChosen = leaves[0];
    NSLog(@"Chosen element: id: %@ data: %@", leafChosen.identifier, leafChosen.data);
//    NSLog(@"tree: %@", tree);
//    for (Tree *leaf in leaves) {
//        NSLog(@"leaf: %@ %@", leaf.identifier, leaf.data);
//    }

    
    CGPoint center = [self getCenter:((ElementInfo*)leafChosen.data).frame];
    [self tap:center];
}

-(XCUIElement *)findTreeCorrespondingXCUIElementByClassPath:(Tree *)tree
{
    ClassPath *path = getClassPathForElement(tree);
    return [self findElementByClassPath:path];
}

-(XCUIElement *)findTreeCorrespondingXCUIElementByDescendantsIndex:(Tree *)tree
{
    NSUInteger index = getIndexOfDescendantsMatchingType(tree);
    XCUIElementType elementType = ((ElementInfo *)(tree.data)).elementType;
    return [[self.testedApp descendantsMatchingType:elementType] allElementsBoundByIndex][index];
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
