//
//  RegularAction.h
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import <Foundation/Foundation.h>
#import "RandomAction.h"

@interface RegularAction : NSObject

@property (readonly, nonatomic) int interval;

@property (copy, nonatomic) ActionBlock action;

-(id)initWithInterval:(int)interval action:(ActionBlock)action;

@end
