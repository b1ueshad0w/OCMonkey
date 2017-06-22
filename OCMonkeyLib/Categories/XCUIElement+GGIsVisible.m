//
//  XCUIElement+GGIsVisible.m
//  OCMonkey
//
//  Created by gogleyin on 22/06/2017.
//
//

#import "XCUIElement+GGIsVisible.h"
#import "XCElementSnapshot.h"
#import "MonkeyConfiguration.h"

@implementation XCUIElement (GGIsVisible)

- (BOOL)gg_isVisible
{
    return self.lastSnapshot.gg_isVisible;
}

@end


@implementation XCElementSnapshot (GGIsVisble)

- (BOOL)gg_isVisible
{
    if (CGRectIsEmpty(self.frame)) {
        return NO;
    }
    CGRect visibleFrame = self.visibleFrame;
    if (CGRectIsEmpty(visibleFrame)) {
        return NO;
    }
   
    CGRect appFrame = [self _rootElement].frame;
    CGSize screenSize = appFrame.size;
    CGRect screenFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    if (!CGRectIntersectsRect(visibleFrame, screenFrame)) {
        return NO;
    }
    return CGRectContainsPoint(appFrame, self.hitPoint);
}

@end
