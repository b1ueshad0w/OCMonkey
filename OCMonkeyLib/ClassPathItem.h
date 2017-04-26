//
//  ClassPathItem.h
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import <Foundation/Foundation.h>

@interface ClassPathItem : NSObject

@property (nonatomic, readonly) int index;
@property (nonatomic, readonly, strong) NSString *className;

-(id)initWithIndex:(int)index className:(NSString *)className;

@end
