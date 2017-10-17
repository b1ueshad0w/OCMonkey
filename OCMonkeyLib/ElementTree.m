//
//  ElementTree.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "ElementTree.h"
#import "ClassPath.h"
#import "ClassPathItem.h"
#import "ElementTypeTransformer.h"
#import "ElementInfo.h"
#import "NSMutableArray+Reverse.h"
#import "Monkey+XCUITestPrivate.h"
#import "MathUtils.h"

@implementation ElementTree

@dynamic data;

-(id)appendChildWithData:(id)data identifier:(NSString *)identifier
{
    ElementTree *child = [[ElementTree alloc] initWithParent:self withData:data withID:identifier];
    [self.children addObject:child];
    return self;
}

-(NSArray<ElementTree *> *)descendantsMatchingType:(XCUIElementType)elementType
{
    __block NSMutableArray<ElementTree *> *matches = [[NSMutableArray alloc] init];
    [self traverseDown:^BOOL(Tree *node, BOOL *stop) {
        ElementTree *aNode = (ElementTree*)node;
        if (aNode.data.elementType == elementType) {
            [matches addObject:aNode];
        }
        return YES;
    }];
    return matches;
}

-(NSArray<ElementTree *> *)childrenMatchingType:(XCUIElementType)elementType
{
    __block NSMutableArray<ElementTree *> *matches = [[NSMutableArray alloc] init];
    if (self.children.count) {
        for (ElementTree *child in self.children) {
            if (child.data.elementType == elementType) {
                [matches addObject:child];
            }
        }
    }
    return matches;
}

-(void)tap
{
    [Monkey tapAtLocation:getRectCenter(self.data.frame)];
}

-(void)swipeLeft
{
    [Monkey swipeLeftFrame:self.data.frame];
}

-(void)swipeRight
{
    [Monkey swipeRightFrame:self.data.frame];
}

-(void)swipeUp
{
    [Monkey swipeUpFrame:self.data.frame];
}

-(void)swipeDown
{
    [Monkey swipeDownFrame:self.data.frame];
}

@end


ClassPath* getClassPathForElement(Tree *element)
{
    NSMutableArray<ClassPathItem *> *pathItems = [[NSMutableArray alloc] init];
    Tree *currentNode = element;
    while (currentNode.parent) {
        XCUIElementType elementType = ((ElementInfo *)(currentNode.data)).elementType;
        NSString *className = [ElementTypeTransformer shortStringWithElementType:elementType];
        __block int classIndex = 0;
        [currentNode.parent.children enumerateObjectsUsingBlock:^(Tree *node, NSUInteger index, BOOL *stop) {
            if (node == currentNode) {
                *stop = YES;
                return;
            }
            if (((ElementInfo *)(currentNode.data)).elementType == elementType) {
                classIndex += 1;
            }
        }];
        [pathItems addObject:[[ClassPathItem alloc] initWithIndex:classIndex className:className]];
        currentNode = currentNode.parent;
    }
    [pathItems reverse];
    return [[ClassPath alloc]  initWithPathItems:pathItems];
}

NSUInteger getIndexOfDescendantsMatchingType(Tree *element)
{
    __block NSMutableArray<Tree *> *elementsOfType = [[NSMutableArray alloc] init];
    XCUIElementType elementType = ((ElementInfo *)(element.data)).elementType;
    Tree *root = [element root];
    [root traverseDown:^BOOL(Tree *node, BOOL *stop){
        if (((ElementInfo *)(node.data)).elementType == elementType) {
            [elementsOfType addObject:node];
        }
        return YES;
    }];
    return [elementsOfType indexOfObject:element];
}
