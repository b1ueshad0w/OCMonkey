//
//  RandomAction.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "RandomAction.h"

@implementation RandomAction

-(id)initWithWeight:(double)weight action:(ActionBlock)action
{
    self = [super init];
    if (self) {
        _accumulatedWeight = weight;
        _action = action;
    }
    return self;
}

@end
