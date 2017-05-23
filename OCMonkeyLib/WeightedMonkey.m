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
#import "XCUIApplication+Monkey.h"
#import "Monkey+XCUITestPrivate.h"
#import "MathUtils.h"
#import "SmartMonkey.h"
#import "Macros.h"
#import <math.h>
#import "MathUtils.h"

#define ContainerScrollWeight 0.2

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
    }
    return self;
}

-(void)runOneStep
{
    [self performGoBackIfNeeded];
    
    ElementTree *uiTree = [self.testedApp tree];
    NSLog(@"leaves count: %ld", [uiTree leaves].count);
    
    NSMutableArray<ElementTree *> *elements = [[NSMutableArray alloc] init];
    [uiTree traverseDown:^BOOL(Tree *element, BOOL *stop) {
        ElementInfo *data = ((ElementTree*)element).data;
        if (data.elementType == XCUIElementTypeStatusBar)
            return NO;
        BOOL isTooBigElement = (data.frame.size.width > (self.screenFrame.size.width - 1) &&
                                data.frame.size.height > self.screenFrame.size.height - 1);
        if ([WeightedMonkey isContainer:data.elementType]) {
            [elements addObject:(ElementTree*)element];
            return NO;
        }
        if (isTooBigElement)
            return YES;
        [elements addObject:(ElementTree*)element];
        return YES;
    }];
    
//    NSArray<ElementTree *> *elements = [uiTree leaves];
    
    NSLog(@"valid leaves count: %ld", elements.count);
    
    
    NSMutableArray *desc = NSMutableArray.new;
    for (Tree *element in elements) {
        [desc addObject:[NSString stringWithFormat:@"%@ %@", element.identifier, element.data]];
    }
    NSLog(@"Leaves: %@", [desc componentsJoinedByString:@"\n"]);
    
    TreeHashType *treeHash = [self getCurrentVC];
    
    if ([treeHash hasSuffix:@"WebViewController"])
        [self goBack];
//    if ([treeHash isEqualToString:@"REInfoCodeController"]) {
//        NSUInteger stackLength = self.vcStack.count;
//        [self goBackByDragFromScreenLeftEdgeToRight];
//        if (self.vcStack.count < stackLength)
//            NSLog(@"Success");
//        else
//            NSLog(@"Failed");
//    }
    
//    ElementTree *selected = (ElementTree *)[_algorithm chooseAnElementFromTree:uiTree
//                                                                 AmongElements:elements
//                                                                  withTreeHash:treeHash];
    ElementTree *selected = elements[4];
    NSLog(@"selected: %@ %@", selected.identifier, selected.data);
    
    if (![WeightedMonkey isContainer:selected.data.elementType])
        [self tapElement:selected];
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
        NSLog(@"selected from container: %@ %@", finalSelected.identifier, finalSelected.data);
        [self tapElement:finalSelected];
    }
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
        NSLog(@"Scroll container error: Not found first cell!");
        return;
    }
    start = getRectCenter(firstCell.data.frame);*/
    if (isVertical) {
        start = CGPointMake(origin.x + size.width * 0.5, origin.y + size.height * 0.2);
        end = CGPointMake(start.x, origin.y + size.height * 0.8);
    } else {
        start = CGPointMake(origin.x + size.width * 0.2, origin.y + size.height * 0.5);
        end = CGPointMake(origin.x + size.width * 0.8, start.y);
    }
    
    if (RandomZeroToOne < 0.3) {
        [self dragFrom:start to:end];  // fetch new data
    } else {
        [self dragFrom:end to:start];  // show more cells
    }
}

-(void)performGoBackIfNeeded
{
    if (RandomZeroToOne < (float)self.vcStack.count / 10) {
        NSLog(@"Perform GoBack.");
        [self goBack];
    }
}

-(void)goBack
{
    NSUInteger stackLength = self.vcStack.count;
    [self goBackByDragFromScreenLeftEdgeToRight];
    if (self.vcStack.count < stackLength)
        return;
    
    XCUIElement *backButton = [self.testedApp.navigationBars.buttons allElementsBoundByIndex][0];
    if (backButton.exists) {
        [backButton tap];
        if (self.vcStack.count < stackLength)
            return;
    }
    
    NSLog(@"Failed to go back.");
}

-(void)postRun
{
    [super postRun];
    NSLog(@"%@", [_algorithm statDescription]);
}
@end
