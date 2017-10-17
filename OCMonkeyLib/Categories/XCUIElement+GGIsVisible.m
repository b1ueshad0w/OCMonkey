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
#import "APICompatibility.h"
#import "XCElementSnapshot+GGHelpers.h"
#import "XCTestPrivateSymbols.h"
#import "XCElementSnapshot+GGHitPoint.h"

@implementation XCUIElement (GGIsVisible)

- (BOOL)gg_isVisible
{
    return self.lastSnapshot.gg_isVisible;
}

@end


@implementation XCElementSnapshot (GGIsVisble)

- (BOOL)gg_isVisible
{
    CGRect frame = self.frame;
    if (CGRectIsEmpty(frame)) {
        return NO;
    }
    
    if ([MonkeyConfiguration shouldUseTestManagerForVisibilityDetection]) {
        return [(NSNumber *)[self gg_attributeValue:GG_XCAXAIsVisibleAttribute] boolValue];
    }
    
    CGRect appFrame = [self gg_rootElement].frame;
    CGSize screenSize = GGAdjustDimensionsForApplication(appFrame.size, (UIInterfaceOrientation)[XCUIDevice sharedDevice].orientation);
    CGRect screenFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    if (!CGRectIntersectsRect(frame, screenFrame)) {
        return NO;
    }
    if (CGRectContainsPoint(appFrame, self.gg_hitPoint)) {
        return YES;
    }
    for (XCElementSnapshot *elementSnapshot in self._allDescendants.copy) {
        if (CGRectContainsPoint(appFrame, elementSnapshot.gg_hitPoint)) {
            return YES;
        }
    }
    return NO;
}

@end
