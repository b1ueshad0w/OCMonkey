//
//  NSMutableArray+FixedSizeQueue.m
//  libmonkey
//
//  Created by gogleyin on 8/24/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import "NSMutableArray+FixedSizeQueue.h"

const int fixedSize = 10;

@implementation NSMutableArray (FixedSizeQueue)
- (id) dequeue {
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

- (void) enqueue:(id)anObject {
    while ([self count] >= fixedSize) {
        [self dequeue];
    }
    [self addObject:anObject];
}
@end
