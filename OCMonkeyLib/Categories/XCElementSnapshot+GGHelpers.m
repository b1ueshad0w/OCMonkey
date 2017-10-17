//
//  XCElementSnapshot+GGHelpers.m
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import "XCElementSnapshot+GGHelpers.h"
#import "XCAXClient_iOS.h"

@implementation XCElementSnapshot (GGHelpers)

- (id)gg_attributeValue:(NSNumber *)attribute
{
    NSDictionary *attributesResult = [[XCAXClient_iOS sharedClient] attributesForElementSnapshot:self attributeList:@[attribute]];
    return (id __nonnull)attributesResult[attribute];
}

@end
