//
//  XCElementSnapshot+GGHitPoint.h
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import <OCMonkeyLib/OCMonkeyLib.h>

@interface XCElementSnapshot (GGHitPoint)

/**
 Wrapper for Apple's hitpoint, thats resolves few known issues
 
 @return Element's hitpoint if exists {-1, -1} otherwise
 */
- (CGPoint)gg_hitPoint;

@end
