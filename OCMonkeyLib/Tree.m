//
//  Tree.m
//  tree
//
//  Created by gogleyin on 26/04/2017.
//  Copyright © 2017 blueshadow. All rights reserved.
//

#import "Tree.h"

#define separator @"/"

@implementation Tree

+(NSString *)generateId:(Tree *)parent
{
    if (!parent) {
        return @"0";
    }
    NSString *identifier = [parent.identifier stringByAppendingFormat:@"%@%lu", separator, (unsigned long)[parent.children count]];
    return identifier;
}

-(id)initWithParent:(Tree *)parent withData:(id)data
{
    return [self initWithParent:parent withData:data withID:nil];
}

-(id)initWithParent:(Tree *)parent withData:(id)data withID:(NSString *)identifier
{
    self = [super init];
    if (self) {
        if (!parent)
            _depth = 0;
        else
            _depth = parent.depth + 1;
        _parent = parent;
        _data = data;
        _children = [NSMutableArray new];
        _identifier = identifier;
        if (!_identifier) {
            _identifier = [Tree generateId:parent];
        }
    }
    return self;
}

-(id)appendChildWithData:(id)data identifier:(NSString *)identifier
{
    Tree *child = [[Tree alloc] initWithParent:self withData:data withID:identifier];
    [_children addObject:child];
    return self;
}

-(id)appendChildWithData:(id)data
{
    return [self appendChildWithData:data identifier:nil];
}

-(void)traverseDown:(BOOL(^)(Tree *))callback
{
    callback(self);
    if (![self.children count])
        return;
    for (Tree *child in self.children) {
        [child traverseDown:callback];
    }
}


-(NSArray<Tree *> *)leaves
{
    __block NSMutableArray<Tree *> *leaves = [[NSMutableArray alloc] init];
    [self traverseDown:^BOOL(Tree *node) {
        if (node.children.count == 0)
            [leaves addObject:node];
        return YES;
    }];
    return leaves;
}

-(NSString *)description
{
    __block NSMutableArray *lines = [NSMutableArray new];
    [lines addObject:@"\n"];
    [self traverseDown:^BOOL(Tree *node){
        NSString *sep = @"|-";
        NSString *indentation = @"";
        if (node.depth == 0) {
            [lines addObject:[NSString stringWithFormat:@"%@ %@", node.identifier, node.data]];
            return YES;
        }
        for (int i = 0; i < node.depth; i++) {
            indentation = [indentation stringByAppendingString:@" "];
        }
        NSString *item = [NSString stringWithFormat:@"%@%@%@ %@", indentation, sep, node.identifier, node.data];
        [lines addObject: item];
        return YES;
    }];
    return [lines componentsJoinedByString:@"\n"];
}
@end
