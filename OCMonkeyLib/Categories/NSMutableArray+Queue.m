//
//  NSMutableArray+Queue.m
//  OCMonkey
//
//  Created by gogleyin on 17/05/2017.
//
//

#import "NSMutableArray+Queue.h"
#import <objc/runtime.h>
#import "GGLogger.h"

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
        NSLock *arrayLock = [[NSLock alloc] init];
        [arrayLock lock];
        [self removeObjectAtIndex:0];
        [arrayLock unlock];
    }
    return headObject;
}

- (void)enqueue:(id)anObject {
    while ([self count] >= self.maxSize) {
        [self dequeue];
    }
    NSLock *arrayLock = [[NSLock alloc] init];
    [arrayLock lock];
    [self addObject:anObject];
    [arrayLock unlock];
    [GGLogger logFmt:@"Queue enqueued: %@", anObject];
}

@end
