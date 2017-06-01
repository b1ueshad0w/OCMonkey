//
//  UIViewTree.m
//  OCMonkey
//
//  Created by gogleyin on 01/06/2017.
//
//

#import "UIViewTree.h"

@implementation UIViewInfo

-(id)initWithClassName:(NSString *)className frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _className = className;
        _frame = frame;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ {{%.1f, %.1f},{%.1f, %.1f}}", _className, _frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height];
}

@end


@implementation UIViewTree

@dynamic data;

@end

