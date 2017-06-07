//
//  XCUIElement+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 07/06/2017.
//
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

@interface XCUIElement (Monkey)

- (BOOL)gg_typeText:(NSString *)text error:(NSError **)error;
- (BOOL)gg_clearTextWithError:(NSError **)error;

@end
