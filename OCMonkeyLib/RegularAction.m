//
//  RegularAction.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "RegularAction.h"

@implementation RegularAction

-(id)initWithInterval:(int)interval action:(ActionBlock)action
{
    self = [super init];
    if (self) {
        _interval = interval;
        _action = action;
    }
    return self;
}

@end
