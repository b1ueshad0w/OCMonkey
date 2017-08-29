//
//  XCUIElement+GGSwipe.m
//  OCMonkey
//
//  Created by gogleyin on 25/08/2017.
//
//

#import "XCUIElement+GGSwipe.h"
#import "Monkey+XCUITestPrivate.h"
#import "GGLogger.h"

typedef NS_ENUM(NSInteger, XCTestSwipeDirection) {
    XCTestSwipeDirectionUnknown,
    XCTestSwipeDirectionRight,
    XCTestSwipeDirectionLeft,
    XCTestSwipeDirectionDown,
    XCTestSwipeDirectionUp,
};

@implementation XCUIElement (GGSwipe)

-(void)gg_swipeUp
{
    [self _gg_swipe:XCTestSwipeDirectionUp];
}

-(void)gg_swipeDown
{
    [self _gg_swipe:XCTestSwipeDirectionDown];
}

-(void)gg_swipeLeft
{
    [self _gg_swipe:XCTestSwipeDirectionLeft];
}

-(void)gg_swipeRight
{
    [self _gg_swipe:XCTestSwipeDirectionRight];
}

-(void)_gg_swipe:(XCTestSwipeDirection)direction
{
    float duration = 0;
    float velocity = 4000;
    CGRect frame = self.frame;
    
    if (direction == XCTestSwipeDirectionUp || direction == XCTestSwipeDirectionDown) {
        CGFloat half = frame.size.width / 2;
        CGPoint start = CGPointMake(frame.origin.x + half, frame.origin.y + frame.size.height * 0.2);
        CGPoint end = CGPointMake(frame.origin.x + half, frame.origin.y + frame.size.height * 0.8);
        if (direction == XCTestSwipeDirectionUp) {
            [Monkey dragFrom:end to:start duration:duration velocity:velocity];
        } else {
            [Monkey dragFrom:start to:end duration:duration velocity:velocity];
        }
    } else if (direction == XCTestSwipeDirectionRight || direction == XCTestSwipeDirectionLeft) {
        CGFloat half = frame.size.height / 2;
        CGPoint start = CGPointMake(frame.origin.x + frame.size.width * 0.2, frame.origin.y + half);
        CGPoint end = CGPointMake(frame.origin.x + frame.size.width * 0.8, frame.origin.y + half);
        if (direction == XCTestSwipeDirectionRight) {
            [Monkey dragFrom:start to:end duration:duration velocity:velocity];
        } else {
            [Monkey dragFrom:end to:start duration:duration velocity:velocity];
        }
    } else {
        [GGLogger log:@"Invalid swipe command"];
    }
}


@end
