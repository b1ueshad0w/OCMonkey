//
//  NSMutableArray+Queue.h
//  OCMonkey
//
//  Created by gogleyin on 17/05/2017.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

@property (nonatomic, assign) int maxSize;

- (void)enqueue:(id)anObject;
- (id)dequeue;
@end
