//
//  NSMutableArray+Reverse.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "NSMutableArray+Reverse.h"

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
