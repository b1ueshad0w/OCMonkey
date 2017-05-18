//
//  WeightedMonkey.m
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "WeightedMonkey.h"
#import "MonkeyAlgorithm.h"
#import "Tree.h"
#import "XCUIApplication+Monkey.h"
#import "Monkey+XCUITestPrivate.h"
#import "MathUtils.h"
#import "SmartMonkey.h"
#import "Macros.h"
#import <math.h>

@implementation WeightedMonkey

-(id)initWithBundleID:(NSString*)bundleID
{
    return [self initWithBundleID:bundleID algorithm:[[WeightedAlgorithm alloc] init]];
}

-(id)initWithBundleID:(NSString *)bundleID algorithm:(id<MonkeyAlgorithm>)algorithm
{
    self = [super initWithBundleID:bundleID];
    if (self) {
        _algorithm = [[WeightedAlgorithm alloc] init];
    }
    return self;
}

-(void)runOneStep
{
//    [self performGoBackIfNeeded];
    Tree *uiTree = [self.testedApp tree];
    NSArray<Tree *> *elements = [uiTree leaves];
    TreeHashType *treeHash = [self getCurrentVC];
    Tree *selected = [_algorithm chooseAnElementFromTree:uiTree
                                           AmongElements:elements
                                            withTreeHash:treeHash];
    [self tapElement:selected];
}

-(void)performGoBackIfNeeded
{
    double depth = log10(self.vcStack.count);
    if (RandomZeroToOne < depth)
        [self goBack];
}

-(void)goBack
{
    NSUInteger stackLength = self.vcStack.count;
    XCUIElement *backButton = [self.testedApp.navigationBars.buttons allElementsBoundByIndex][0];
    if (backButton.exists) {
        [backButton tap];
        if (self.vcStack.count < stackLength)
            return;
    }
    [self goBackByDragFromScreenLeftEdgeToRight];
    if (self.vcStack.count < stackLength)
        return;
    NSLog(@"Failed to go back.");
}

-(void)postRun
{
    [super postRun];
    NSLog(@"%@", [_algorithm statDescription]);
}
@end
