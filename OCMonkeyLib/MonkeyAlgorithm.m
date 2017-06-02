//
//  MonkeyAlgorithm.m
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "MonkeyAlgorithm.h"
#import <XCTest/XCUIElementTypes.h>
#import "ElementInfo.h"
#import "Macros.h"

@implementation ElementStat

- (id)initWithPopularity:(int)popularity chosenCount:(int)count data:(id)data
{
    self = [super init];
    if (self) {
        _popularity = popularity;
        _chosenCount = count;
        _data = data;
    }
    return self;
}

@end

@implementation TreeStat

- (id)initWithElements:(NSDictionary *)elements
           chosenCount:(int)count
            popularity:(int)popularity
                  tree:(Tree *)tree
{
    self = [super init];
    if (self) {
        _elements = [NSMutableDictionary dictionaryWithDictionary:elements];
        _popularity = popularity;
        _chosenCount = count;
        _tree = tree;
    }
    return self;
}

@end

@implementation WeightedAlgorithm

- (id)init
{
    self = [super init];
    if (self) {
        _stat = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (int)computeElementPopularity:(Tree *)element
{
    XCUIElementType type = ((ElementInfo *)element.data).elementType;
    switch (type) {
        case XCUIElementTypeButton:
            return 200;
            
        case XCUIElementTypeTable:
            return 400;
            
        case XCUIElementTypeCollectionView:
            return 400;
            
        case XCUIElementTypeScrollView:
            return 300;
            
        case XCUIElementTypeCell:
            return 150;
            
        case XCUIElementTypeStaticText:
            return 100;
            
        case XCUIElementTypeOther:
            return 100;
            
        default:
            return 100;
    }
}

- (NSUInteger)chooseWithProbabilities:(NSArray<NSNumber *> *)normProbabilities
{
    NSMutableArray<NSNumber *> *cumulativeProbabilities = [[NSMutableArray alloc] init];
    float sum = 0;
    for (NSNumber *num in normProbabilities) {
        sum += [num floatValue];
        [cumulativeProbabilities addObject:[NSNumber numberWithFloat:sum]];
    }
    float seed = RandomZeroToOne;
    for (int i = 0; i < cumulativeProbabilities.count; i++) {
        if (seed < [cumulativeProbabilities[i] floatValue])
            return i;
    }
    return cumulativeProbabilities.count - 1;
}

/**
 pi : probability to select element[i]
 ci : chosen count of element[i] (normalized, c1 + c2 + c3 = 1)
 P1 : popularity of element[i]
 ==>
 p1 + p2 + p3 = 1
 p1+c2 : p2+c2 : p3+c3 = P1 : P2 : P3
 ==>
 pi = (1 + c1 + c2 + c3) * Pi / (P1 + P2 + P3) - ci
 If we also have Pi normalized, then we have:
 pi = 2 * Pi - ci
 
 @param elements elements
 @param treeHash to identify a tree
 @return chosen element
 */
- (Tree *)chooseAlgorithm:(NSArray<Tree *> *)elements treeHash:(TreeHashType *)treeHash
{
    NSMutableArray<NSNumber *> *popularities = [[NSMutableArray alloc] init];
    NSMutableArray<NSNumber *> *normPopularities = [[NSMutableArray alloc] init];
    NSMutableArray<NSNumber *> *finalPopularities = [[NSMutableArray alloc] init];
    NSMutableArray<NSNumber *> *chosens = [[NSMutableArray alloc] init];
    NSMutableArray<NSNumber *> *normChosens = [[NSMutableArray alloc] init];
    for (Tree *element in elements) {
        if (![_stat[treeHash].elements objectForKey:element.identifier]) {
            int popularity = [self computeElementPopularity:element];
            [_stat[treeHash].elements setObject:[[ElementStat alloc] initWithPopularity:popularity
                                                                            chosenCount:0
                                                                                   data:element.data]
                                         forKey:element.identifier];
        }
        NSNumber *popu = [NSNumber numberWithInt:_stat[treeHash].elements[element.identifier].popularity];
        NSNumber *chosen = [NSNumber numberWithInt:_stat[treeHash].elements[element.identifier].chosenCount];
        [popularities addObject:popu];
        [chosens addObject:chosen];
    }
    
    int popularitiesSum = 0;
    for (NSNumber *num in popularities) {
        popularitiesSum += [num intValue];
    }
    if (popularitiesSum == 0)
        return elements[arc4random() % elements.count];
    [popularities enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop) {
        [normPopularities addObject:[NSNumber numberWithFloat:[num intValue] / (float)popularitiesSum]];
    }];
    
    int chosenSum = 0;
    for (NSNumber *num in chosens) {
        chosenSum += [num intValue];
    }
    if (chosenSum == 0) {
        NSUInteger index = [self chooseWithProbabilities:normPopularities];
        return elements[index];
    }
    [chosens enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop) {
        [normChosens addObject:[NSNumber numberWithFloat:[num intValue] / (float)chosenSum]];
    }];
    
    for (int index = 0; index < elements.count; index++) {
        float finalPopularity = 2 * [normPopularities[index] floatValue] - [normChosens[index] floatValue];
        [finalPopularities addObject:[NSNumber numberWithFloat:finalPopularity]];
    };
    
    NSUInteger chosenIndex = [self chooseWithProbabilities:finalPopularities];
    return elements[chosenIndex];
}

/**
 Choose an element from a given UI Tree.
 TODO - We should separate container's children. Actually, we should treat a container as a leaf element.
 
 @param tree UI Tree
 @param elements elements to choose from
 @param treeHash a unique id to identify a UITree
 @return selected element
 */
- (Tree *)chooseAnElementFromTree:(Tree *)tree
                    AmongElements:(NSArray<Tree *> *)elements
                     withTreeHash:(TreeHashType *)treeHash
{
    NSMutableArray *news = [NSMutableArray new];
    BOOL isNewTree;
    if (![_stat objectForKey:treeHash]) {
        NSLog(@"A new root added: %@", treeHash);
        isNewTree = YES;
        [_stat setObject:[[TreeStat alloc] initWithElements:@{}
                                                chosenCount:0
                                                 popularity:0
                                                       tree:tree]
                  forKey:treeHash];
    } else {
        isNewTree = NO;
    }
    _stat[treeHash].chosenCount++;
    
    for (Tree *element in elements) {
        if ([_stat[treeHash].elements objectForKey:element.identifier])
            continue;
        if (!isNewTree) {
            /* TODO - We should raise the weight of new ones */
            //            NSLog(@"new element for tree: %@ ==> %@", element, treeHash);
            [news addObject:element];
        }
        int popularity = [self computeElementPopularity:element];
        [_stat[treeHash].elements setObject:[[ElementStat alloc] initWithPopularity:popularity
                                                                        chosenCount:0
                                                                               data:element.data]
                                     forKey:element.identifier];

    }
    Tree *elementChosen = [self chooseAlgorithm:elements treeHash:treeHash];
    _stat[treeHash].elements[elementChosen.identifier].chosenCount++;
    
    return elementChosen;
}

- (NSString *)statDescription
{
    NSMutableArray<NSString *> *lines = [[NSMutableArray alloc] init];
    for (TreeHashType *treeHash in _stat) {
        [lines addObject:[NSString stringWithFormat:@"tree: %@", treeHash]];
        for (ElementHashType *elementHash in _stat[treeHash].elements) {
            ElementStat *elementStat = _stat[treeHash].elements[elementHash];
            [lines addObject:[NSString stringWithFormat:@"  %d %@ %@", elementStat.chosenCount, elementStat.data, elementHash]];
        }
    }
    return [lines componentsJoinedByString:@"\n"];
}

@end
