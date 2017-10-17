//
//  XCElementSnapshot+GGHitPoint.m
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import "XCElementSnapshot+GGHitPoint.h"

@implementation XCElementSnapshot (GGHitPoint)

- (CGPoint)gg_hitPoint
{
    @try {
        return [self hitPoint];
    } @catch (NSException *e) {
        [GGLogger logFmt:@"Failed to fetch hit point for %@ - %@", self.debugDescription, e.reason];
        return CGPointMake(-1, -1); // Same what XCTest does
    }
}

@end
