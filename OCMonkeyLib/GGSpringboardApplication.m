//
//  GGSpringboardApplication.m
//  OCMonkey
//
//  Created by gogleyin on 22/06/2017.
//
//

#import "GGSpringboardApplication.h"
#import "GGLogger.h"
#import "XCUIElement.h"
#import "XCUIElement+GGIsVisible.h"
#import "RunLoopSpinner.h"
#import "MathUtils.h"

@implementation GGSpringboardApplication

+ (instancetype)springboard
{
    static GGSpringboardApplication *_springboardApp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _springboardApp = [[GGSpringboardApplication alloc] initPrivateWithPath:nil bundleID:@"com.apple.springboard"];
    });
    [_springboardApp query];
    [_springboardApp resolve];
    return _springboardApp;
}

- (BOOL)tapApplicationWithIdentifier:(NSString *)identifier error:(NSError **)error
{
    XCUIElementQuery *query = [[self descendantsMatchingType:XCUIElementTypeIcon] matchingIdentifier:identifier];
    NSArray<XCUIElement *> *matches = [query allElementsBoundByIndex];
    if (0 == matches.count) {
        [GGLogger logFmt:@"Could not find icon with identifier %@ on Springboard.", identifier];
        return NO;
    }
    XCUIElement *icon = [matches lastObject];
    BOOL atLeft = icon.frame.origin.x < 0;
    while (!icon.gg_isVisible) {
        CGRect originFrame = icon.frame;
        if (atLeft) {
            [self swipeRight];
        } else {
            [self swipeLeft];
        }
        BOOL isSwipeSuceesful = !isRectEqualToRect(originFrame, icon.frame, GGDefaultFrameFuzzyThreshold);
        if (!isSwipeSuceesful) {
            break;
        }
    }
    if (!icon.gg_isVisible)
          return NO;
    [icon tap];
    return YES;
}

@end
