//
//  _XCInternalTestRun+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import "_XCInternalTestRun+Monkey.h"
#import "Macros.h"

@implementation _XCInternalTestRun (Monkey)

-(void)monkey_start
{
    NSLog(@"%@ [%@(%p) start]", prefix, NSStringFromClass([self class]), self);
    NSLog(@"%@",[NSThread callStackSymbols]);
    [self monkey_start];
}

@end
