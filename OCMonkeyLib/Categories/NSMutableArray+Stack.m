//
//  NSMutableArray+Stack.m
//  OCMonkey
//
//  Created by gogleyin on 17/05/2017.
//
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)item
{
    [self addObject:item];
}

- (id)pop
{
    id lastObj = self.lastObject;
    [self removeLastObject];
    return lastObj;
}

- (NSArray *)popToRoot
{
    NSMutableArray *popedItems = [[NSMutableArray alloc] init];
    while (self.count > 1) {
        [popedItems addObject:[self pop]];
    }
    return popedItems;
}

- (NSArray *)popToNSString:(NSString *)string
{
    NSMutableArray *popedItems = [[NSMutableArray alloc] init];
    while (![string isEqualToString:self.lastObject]) {
        [popedItems addObject:[self pop]];
    }
    return popedItems;
}

@end
