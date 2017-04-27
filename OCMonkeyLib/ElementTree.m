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

@implementation ElementTree

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
    [root traverseDown:^BOOL(Tree *node){
        if (((ElementInfo *)(node.data)).elementType == elementType) {
            [elementsOfType addObject:node];
        }
        return YES;
    }];
    return [elementsOfType indexOfObject:element];
}
