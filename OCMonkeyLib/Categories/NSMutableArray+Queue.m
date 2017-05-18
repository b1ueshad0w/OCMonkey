//
//  NSMutableArray+Queue.m
//  OCMonkey
//
//  Created by gogleyin on 17/05/2017.
//
//

#import "NSMutableArray+Queue.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Queue)

@dynamic maxSize;
static char maxSizeKey;

- (int)maxSize
{
    return [(NSNumber *)objc_getAssociatedObject(self, &maxSizeKey) intValue];
}

- (void)setMaxSize:(int)size
{
    objc_setAssociatedObject(self, &maxSizeKey, @(size), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dequeue {
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

- (void)enqueue:(id)anObject {
    while ([self count] >= self.maxSize) {
        [self dequeue];
    }
    [self addObject:anObject];
    NSLog(@"Queue enqueued: %@", anObject);
}

@end
