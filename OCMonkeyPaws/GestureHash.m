//
//  GestureHash.m
//  TestPaws
//
//  Created by gogleyin on 23/03/2017.
//

#import "GestureHash.h"

@implementation GestureHash
-(id)initWithHash:(NSUInteger)hash gesture:(Gesture *)gesture
{
    self = [super init];
    if (self) {
        self.hashValue = hash;
        self.gesture = gesture;
    }
    return self;
}
@end
