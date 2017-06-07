//
//  XCUIElement+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 07/06/2017.
//
//

#import "XCUIElement+GGTyping.h"
#import "XCUIElement.h"
#import "Keyboard.h"

@implementation XCUIElement (Monkey)

- (BOOL)gg_typeText:(NSString *)text error:(NSError **)error
{
    if (!self.hasKeyboardFocus) {
        [self tap];
    }
    if (![Keyboard typeText:text error:error]) {
        return NO;
    }
    return YES;
}

- (BOOL)gg_clearTextWithError:(NSError **)error
{
    NSMutableString *textToType = @"".mutableCopy;
    const NSUInteger textLength = [self.value length];
    for (NSUInteger i = 0 ; i < textLength ; i++) {
        [textToType appendString:@"\b"];
    }
    if (![self gg_typeText:textToType error:error]) {
        return NO;
    }
    return YES;
}

@end
