//
//  MonkeyAlgorithm.h
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "Tree.h"

typedef NSString TreeHashType;
typedef NSString ElementHashType;


@interface ElementStat : NSObject
@property int popularity;
@property int chosenCount;
@property id data;
@end


@interface TreeStat : NSObject
@property int popularity;
@property int chosenCount;
@property NSMutableDictionary<ElementHashType*, ElementStat*> *elements;
@property Tree *tree;
@end


@protocol MonkeyAlgorithm <NSObject>
@required

/**
 Select an element to perform actions.

 @param tree element tree
 @param elements element set to choose from
 @param treeHash a string to identifiy an element tree
 @return selected element
 */
- (Tree *)chooseAnElementFromTree:(Tree *)tree AmongElements:(NSArray *)elements withTreeHash:(TreeHashType *)treeHash;

/**
 Get a description of current statisitic

 @return NSString
 */
- (NSString *)statDescription;

@end


@interface WeightedAlgorithm : NSObject  <MonkeyAlgorithm>
@property (nonatomic, readwrite) NSMutableDictionary<TreeHashType*, TreeStat*> *stat;
@end
