//
//  RandomAction.h
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import <Foundation/Foundation.h>

typedef void(^ActionBlock)(void);

@interface RandomAction : NSObject

@property (readonly, nonatomic) double accumulatedWeight;

@property (copy, nonatomic) ActionBlock action;

-(id)initWithWeight:(double)weight action:(ActionBlock)action;

@end
