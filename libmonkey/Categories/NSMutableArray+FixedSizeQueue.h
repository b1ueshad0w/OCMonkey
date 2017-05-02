//
//  NSMutableArray+FixedSizeQueue.h
//  libmonkey
//
//  Created by gogleyin on 8/24/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (FixedSizeQueue)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
