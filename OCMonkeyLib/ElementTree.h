//
//  ElementTree.h
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "Tree.h"
#import "ClassPath.h"
#import "ElementInfo.h"

@interface ElementTree : Tree

@property (nonatomic, strong) ElementInfo *data;

-(NSArray<ElementTree *> *)descendantsMatchingType:(XCUIElementType)elementType;

-(NSArray<ElementTree *> *)childrenMatchingType:(XCUIElementType)elementType;

-(void)tap;

@end

typedef NSArray<ElementTree *> ElementTreeArray;

ClassPath* getClassPathForElement(Tree *element);

NSUInteger getIndexOfDescendantsMatchingType(Tree *element);
