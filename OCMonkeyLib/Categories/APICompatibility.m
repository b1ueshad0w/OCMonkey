//
//  APICompatibility.m
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import "APICompatibility.h"

static BOOL GGShouldUseOldElementRootSelector = NO;
static dispatch_once_t onceRootElementToken;

@implementation XCElementSnapshot (APICompatibility)

- (XCElementSnapshot *)gg_rootElement
{
    dispatch_once(&onceRootElementToken, ^{
        GGShouldUseOldElementRootSelector = [self respondsToSelector:@selector(_rootElement)];
    });
    if (GGShouldUseOldElementRootSelector) {
        return [self _rootElement];
    }
    return [self rootElement];
}

@end
