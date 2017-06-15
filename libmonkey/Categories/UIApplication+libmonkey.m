//
//  UIApplication+libmonkey.m
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import "UIApplication+Monkey.h"
#import "GGLogger.h"

@implementation UIApplication (libmonkey)

-(void)monkey_openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion
{
//    [self monkey_openURL:url options:options completionHandler:completion];
    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *prefix = @"monkey_";
    if ([selStr hasPrefix:prefix]) {
        selStr = [selStr substringFromIndex:prefix.length];
    }
    [GGLogger logFmt:@"[%@ (will not)%@] args: %@ %@", @"UIApplication", selStr, url, options];
}

-(BOOL)monkey_openURL:(NSURL *)url
{
//    [self monkey_openURL:url];
    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *prefix = @"monkey_";
    if ([selStr hasPrefix:prefix]) {
        selStr = [selStr substringFromIndex:prefix.length];
    }
    [GGLogger logFmt:@"[%@ (will not)%@] args: %@", @"UIApplication", selStr, url];
    return NO;
}

@end
