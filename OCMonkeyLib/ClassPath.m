//
//  ClassPath.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "ClassPath.h"

@implementation ClassPath

-(id)init
{
    self = [super init];
    if (self) {
        _pathItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithPathItems:(NSMutableArray *)pathItems
{
    self = [super init];
    if (self) {
        _pathItems = pathItems;
    }
    return self;
}

-(NSString *)description
{
    return [_pathItems componentsJoinedByString:@"//"];
}

@end
