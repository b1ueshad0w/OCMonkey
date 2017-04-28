//
//  Tree.h
//  tree
//
//  Created by gogleyin on 26/04/2017.
//  Copyright © 2017 blueshadow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tree : NSObject

@property (nonatomic, weak) Tree *parent;
@property (nonatomic, weak) Tree *root;
@property (nonatomic, strong) NSMutableArray<Tree *> *children;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) int depth;

-(id)initWithParent:(Tree *)parent withData:(id)data;
-(id)initWithParent:(Tree *)parent withData:(id)data withID:(NSString *)identifier;
-(id)appendChildWithData:(id)data;
-(void)traverseDown:(BOOL(^)(Tree *))callback;
-(NSArray<Tree *> *)leaves;

@end
