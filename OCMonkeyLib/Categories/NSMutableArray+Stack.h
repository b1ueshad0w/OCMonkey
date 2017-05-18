//
//  NSMutableArray+Stack.h
//  OCMonkey
//
//  Created by gogleyin on 17/05/2017.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (void)push:(id)item;

- (id)pop;

/**
 Continuely pop the stack until one item left.

 @return array of poped items
 */
- (NSArray *)popToRoot;


/**
 Continuely pop the stack until an item(NSString) is at the top.

 @param string string of the item to be at the top
 @return array of poped items
 */
- (NSArray *)popToNSString:(NSString *)string;
@end
