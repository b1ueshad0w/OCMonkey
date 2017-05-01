//
//  Monkey+XCUITest.m
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#import "Monkey+XCUITest.h"
#import "XCUIApplication.h"
#import "Monkey.h"
#import "ClassPath.h"
#import "ClassPathItem.h"
#import "Tree.h"
#import "ElementTree.h"
#import "ElementInfo.h"
#import "ElementTypeTransformer.h"

@implementation Monkey (XCUITest)

-(void)addXCTestTapAlertAction:(int)interval
{
    [self addAction:^(void){
        XCUIApplication *app = nil;
        NSArray<XCUIElement *> *alerts = [app.alerts allElementsBoundByIndex];
        for (int i = 0; i < alerts.count; i++) {
            NSArray<XCUIElement *> *buttons = [alerts[i].buttons allElementsBoundByIndex];
            [buttons[arc4random() % buttons.count] tap];
        }
    }  withInterval:interval];
}

//-(XCUIElement *)findTreeCorrespondingXCUIElementByClassPath:(Tree *)tree
//{
//    ClassPath *path = getClassPathForElement(tree);
//    return [self findElementByClassPath:path];
//}

//-(XCUIElement *)findTreeCorrespondingXCUIElementByDescendantsIndex:(Tree *)tree
//{
//    NSUInteger index = getIndexOfDescendantsMatchingType(tree);
//    XCUIElementType elementType = ((ElementInfo *)(tree.data)).elementType;
//    return [[self.testedApp descendantsMatchingType:elementType] allElementsBoundByIndex][index];
//}

//-(XCUIElement *)findElementByClassPath:(ClassPath *)classPath
//{
//    XCUIElement *element = self.testedApp;
//    for (ClassPathItem *pathItem in classPath.pathItems) {
//        XCUIElementType elementType = [ElementTypeTransformer elementTypeWithTypeName:pathItem.className];
//        element = [[element childrenMatchingType:elementType] elementBoundByIndex:pathItem.index];
//    }
//    return element;
//}

@end
