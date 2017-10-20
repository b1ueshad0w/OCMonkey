//
//  WeightedMonkey.m
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "WeightedMonkey.h"
#import "MonkeyAlgorithm.h"
#import "ElementTree.h"
#import "XCUIElement+Tree.h"
#import "Monkey+XCUITestPrivate.h"
#import "MathUtils.h"
#import "SmartMonkey.h"
#import "Macros.h"
#import <math.h>
#import "MathUtils.h"
#import "Keyboard.h"
#import "Random.h"
#import "GGLogger.h"
#import "GGSpringboardApplication.h"

#define ContainerScrollWeight 0.2

@interface WeightedMonkey()
@property (nonatomic, readwrite) NSMutableDictionary<TreeHashType *, VCCallback> *vcCallbacks;
/**
 [[time0, vc1], [time1, vc2], ... [timeN, vcN]]
 where time is obtained from CFAbsoluteTimeGetCurrent()
 */
@property (nonatomic, readwrite) NSMutableArray<NSMutableArray *> *vcSequence;
@end

@implementation WeightedMonkey

static NSArray * containers;


+(NSArray *)containers
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        containers =
            @[
              @(XCUIElementTypeTable),
              @(XCUIElementTypeCollectionView),
              ];
    });
    return containers;
}

+(BOOL)isContainer:(XCUIElementType)elementType
{
    return [[self containers] containsObject:@(elementType)];
}

-(id)initWithBundleID:(NSString*)bundleID
{
    return [self initWithBundleID:bundleID algorithm:[[WeightedAlgorithm alloc] init]];
}

-(id)initWithBundleID:(NSString *)bundleID algorithm:(id<MonkeyAlgorithm>)algorithm
{
    self = [super initWithBundleID:bundleID];
    if (self) {
        _algorithm = algorithm;
        _vcCallbacks = [[NSMutableDictionary alloc] init];
        _frequencyOfStateChecking = 0.3;
        _vcSequence = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)registerAction:(VCCallback)callback forVC:(NSString *)vc
{
    [_vcCallbacks setObject:callback forKey:vc];
}

-(NSMutableArray<ElementTree *> *)getValidElementsFromTree:(ElementTree *)uiTree
{
    NSMutableArray<ElementTree *> *elements = [[NSMutableArray alloc] init];
    [uiTree traverseDown:^BOOL(Tree *element, BOOL *stop) {
        ElementInfo *data = ((ElementTree*)element).data;
        if (!data.isVisible)
            return NO;  // discard invisible element and its descendants
        
        /*! Main Window is broken on iOS 11 */
        /*
        if (data.elementType == XCUIElementTypeWindow && !data.isMainWindow)
            return NO;  // discard non-mainWindows' descendants
         */
        
        if (data.elementType == XCUIElementTypeStatusBar)
            return NO;  // discard StatusBar and its descendants
        
        /*
        BOOL isTooBigElement = (data.frame.size.width > (self.screenFrame.size.width - 1) &&
                                data.frame.size.height > self.screenFrame.size.height - 1);
        if ([WeightedMonkey isContainer:data.elementType]) {
            [elements addObject:(ElementTree*)element];
            return NO;
        }
        if (isTooBigElement)
            return YES;
         */
         
        if (element.children.count == 0 || [WeightedMonkey isContainer:data.elementType]) {
            [elements addObject:(ElementTree*)element];
            return NO;
        }
        return YES;
    }];
    return elements;
}

/**
 Principals:
 weight of the following kinds of elements should be raised:
    1. Label has value > Label is blank (or nil)
 
 Shortages:
 1. Because all action is based on tapping elements' coordinates, if a selected element is invisible, we will tap another element instead.
 So such info ButtonA ==> xxxVC is not relieable.
 */
-(void)runOneStep
{
    if (RandomZeroToOne < _frequencyOfStateChecking) {
        [self checkAppState];
    }
    
    if (RandomZeroToOne < 0.1 && [self shouldGoBack]) {
        [GGLogger log:@"Perform GoBack."];
        [self goBack];
    }
    
    ElementTree *uiTree = [self.testedApp treeDetectVisible:NO];
//    NSArray<ElementTree *> *elements = [uiTree leaves];
    NSArray<ElementTree *> *elements = [self getValidElementsFromTree:uiTree];
    [GGLogger logFmt:@"leaves count: %ld    valid ones count: %ld", [uiTree leaves].count, elements.count];
    
//    NSMutableArray *desc = NSMutableArray.new;
//    for (Tree *element in elements) {
//        [desc addObject:[NSString stringWithFormat:@"%@ %@", element.identifier, element.data]];
//    }
//    [GGLogger logFmt:@"Leaves: %@", [desc componentsJoinedByString:@"\n"]];
    
    TreeHashType *treeHash = [self getCurrentVC];
    if (!_vcSequence.lastObject || ![_vcSequence.lastObject.lastObject isEqualToString:treeHash]) {
        [_vcSequence addObject:[NSMutableArray arrayWithObjects:@(CFAbsoluteTimeGetCurrent()), treeHash, nil]];
    }
    if ([treeHash hasSuffix:@"WebViewController"]) {
        if (RandomZeroToOne < 0.4) {
            [self goBack];
            return;
        }
    }
    if ([_vcCallbacks objectForKey:treeHash]) {
        if (!_vcCallbacks[treeHash](uiTree))
            return;
    }
    
    if (![elements count]) {
        [Monkey tapAtLocation:[self randomPoint]];
        return;
    }
    
    ElementTree *selected;
    if (treeHash) {
        selected = (ElementTree *)[_algorithm chooseAnElementFromTree:uiTree
                                                        AmongElements:elements
                                                         withTreeHash:treeHash];
    } else {
        NSUInteger index = arc4random() % elements.count;
        selected = elements[index];
    }
//    ElementTree *selected = elements[4];
    [GGLogger logFmt:@"selected: %@ %@", selected.identifier, selected.data];
    
    if (![WeightedMonkey isContainer:selected.data.elementType])
        [self processElement:selected];
    else {
        if (RandomZeroToOne < ContainerScrollWeight) {
            [self scrollContainer:selected];
        }
        NSMutableArray<ElementTree *> *tableElements = [[NSMutableArray alloc] init];
        [selected traverseDown:^BOOL(Tree *node, BOOL *stop) {
            ElementInfo *data = ((ElementTree *)node).data;
            if (node.children.count == 0) {
                [tableElements addObject:(ElementTree *)node];
                return NO;
            }
            if (data.elementType == XCUIElementTypeCell) {
                if (isFrameInFrame(data.frame, selected.data.frame))
                    [tableElements addObject:(ElementTree *)node];
                return NO;
            }
            return YES;
        }];
        Tree *finalSelected = [_algorithm chooseAnElementFromTree:uiTree
                                                    AmongElements:tableElements
                                                     withTreeHash:treeHash];
        [GGLogger logFmt:@"selected from container: %@ %@", finalSelected.identifier, finalSelected.data];
        [self processElement:finalSelected];
    }
}

-(void)processElement:(ElementTree *)element
{
    XCUIElementType elementType = element.data.elementType;
    
    if (elementType == XCUIElementTypeTextField || elementType == XCUIElementTypeSearchField || elementType == XCUIElementTypeTextView) {
        [element tap];
        [Keyboard typeText:[Random randomString] error:nil];
        return;
    }
    if (elementType == XCUIElementTypeImage) {
        float p_to_swipe = RandomZeroToOne;
        if (isSizeEqualToSize(element.data.frame.size, self.screenFrame.size, 5)) {
            if (p_to_swipe < 0.7) {
                [element swipeLeft];
            } else {
                [element tap];
            }
        } else {
            if (p_to_swipe < 0.3) {
                [element swipeLeft];
            } else {
                [element tap];
            }
        }
        return;
    }
    [element tap];
}

-(void)scrollContainer:(ElementTree *)container
{
    /* 1/5 ~ 4/5 */
    CGSize size = container.data.frame.size;
    CGPoint origin = container.data.frame.origin;
    BOOL isVertical = size.height > size.width ? YES : NO;
    CGPoint start, end;
    /*ElementTree *firstCell;
    for (ElementTree *child in container.children) {
        if (child.data.elementType != XCUIElementTypeCell)
            continue;
        firstCell = child;
        break;
    }
    if (!firstCell) {
        [GGLogger log:@"Scroll container error: Not found first cell!"];
        return;
    }
    start = getRectCenter(firstCell.data.frame);*/
    if (isVertical) {
        CGFloat startY = origin.y + size.height * 0.2;
        startY = startY < 20 ? 25 : startY;
        start = CGPointMake(origin.x + size.width * 0.5, startY);
        end = CGPointMake(start.x, origin.y + size.height * 0.8);
    } else {
        CGFloat startY = origin.y + size.height * 0.5;
        startY = startY > size.height - 20 ? size.height - 25 : startY;
        start = CGPointMake(origin.x + size.width * 0.2, startY);
        end = CGPointMake(origin.x + size.width * 0.8, start.y);
    }
    
    if (RandomZeroToOne < 0.3) {
        [Monkey dragFrom:start to:end duration:0 velocity:2000];  // fetch new data
    } else {
        [Monkey dragFrom:end to:start duration:0 velocity:2000];  // show more cells
    }
}

-(BOOL)shouldGoBack
{
    return RandomZeroToOne < (float)self.stackDepth / 20;
}

-(void)goBack
{
    NSUInteger stackLength = self.stackDepth;
    CGSize size = GGAdjustDimensionsForApplication(self.screenFrame.size, (UIInterfaceOrientation)[XCUIDevice sharedDevice].orientation);
    [Monkey swipeRightThroughFrame:size];
    if (self.stackDepth < stackLength)
        return;
    
    if ([self.testedApp.navigationBars count]) {
        if ([self.testedApp.navigationBars.buttons count]) {
            XCUIElement *backButton = [self.testedApp.navigationBars.buttons allElementsBoundByIndex][0];
            if (backButton.exists && backButton.isEnabled && backButton.isHittable) {
                [backButton tap];
                if (self.stackDepth < stackLength)
                    return;
            }
        }
    }
    
    CGPoint backButton = CGPointMake(40, 42);
    [Monkey tapAtLocation:backButton];
    if (self.stackDepth < stackLength)
        return;
    
    [GGLogger log:@"Failed to go back."];
}

-(void)postRun
{
    [super postRun];
//    [GGLogger log:[_algorithm statDescription]];
    NSArray<NSString *> *vcs = [_algorithm viewControllers];
    [GGLogger logFmt:@"visited vc count: %lu", (unsigned long)vcs.count];
    
    int max = _vcSequence.count - 1;
    for (int i = 0; i < max; i++) {
        _vcSequence[i][0] = @([_vcSequence[i+1][0] doubleValue] - [_vcSequence[i][0] doubleValue]);
    }
    (_vcSequence.lastObject)[0] = @0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeStyle:@"hh:mm:ss"];
    NSDictionary *testResult = @{
        @"ExitStatus": self.exitReason,
        @"StartTime": [dateFormatter stringFromDate:self.startTime],
        @"Duration": @((int)[self.endTime timeIntervalSinceDate:self.startTime]),
        @"ElementsCount": @0,
        @"MonkeyAlgorithm": NSStringFromClass([self.algorithm class]),
//        @"ViewControllers": vcs,
        @"ViewControllersCount": @(vcs.count),
        @"VCSequence": _vcSequence
    };
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [[NSProcessInfo processInfo] environment][@"TestResultFileName"];
    if (!fileName)
        fileName = @"test_result.json";
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
        [GGLogger logFmt:@"Removing existing file: %@", fileName];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            [GGLogger logFmt:@"Delete file failed."];
        } else {
            [GGLogger logFmt:@"Delete success"];
        }
    }
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:testResult
                                                       options:kNilOptions
                                                         error:&error];
    if (error) {
        [GGLogger logFmt:@"NSJSONSerialization failed: %@", error];
    }
    [GGLogger logFmt:@"Save test result to: %@", filePath];
    [jsonData writeToFile:filePath atomically:YES];
}
@end
