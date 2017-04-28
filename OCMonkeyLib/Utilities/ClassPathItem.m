//
//  ClassPathItem.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "ClassPathItem.h"

@interface ClassPathItem ()

@property (nonatomic, readwrite) int index;
@property (nonatomic, readwrite, strong) NSString *className;

@end

@implementation ClassPathItem

-(id)initWithIndex:(int)index className:(NSString *)className
{
    self = [super init];
    if (self) {
        _index = index;
        _className = className;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@[%d]", _className, _index];
}

@end
