//
//  Random.m
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import "Random.h"

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation Random

+ (NSString *)randomStringWithLength:(NSUInteger)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:(arc4random() % ([letters length]))]];
    }
    return randomString;
}

+ (NSString *)randomString
{
    int len = arc4random() % 20;
    return [self randomStringWithLength:len];
}

@end
