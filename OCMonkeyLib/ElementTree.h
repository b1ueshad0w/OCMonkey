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

@end

ClassPath* getClassPathForElement(Tree *element);

NSUInteger getIndexOfDescendantsMatchingType(Tree *element);
