//
//  GestureHash.h
//  TestPaws
//
//  Created by gogleyin on 23/03/2017.
//

#import <Foundation/Foundation.h>
#import "Gesture.h"

@interface GestureHash : NSObject
@property NSUInteger hashValue;
@property Gesture *gesture;
-(id)initWithHash:(NSUInteger)hash gesture:(Gesture *)gesture;
@end
