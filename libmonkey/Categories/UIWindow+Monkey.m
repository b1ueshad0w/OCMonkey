//
//  UIWindow+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 24/05/2017.
//
//

#import "UIWindow+Monkey.h"
#import "Macros.h"
#import "Outlet.h"
#import "GGLogger.h"


@implementation UIWindow (Monkey)

-(NSString *)shortDescription
{
    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
}

-(UIViewController *)monkey_rootViewController
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"rootViewController";
    UIViewController *rootVC = [self monkey_rootViewController];
    NSArray<NSString *> *args = @[self.shortDescription, rootVC.description];
    [[Outlet sharedOutlet] sendJSON:@{@"class": @"UIWindow",
                                      @"selector": NSStringFromSelector(_cmd),
                                      @"args": args}];
    [GGLogger logFmt:@"[%@ (did)%@] %@", @"UIWindow", selStr, [args componentsJoinedByString:@" "]];
    return rootVC;
}

-(void)monkey_setRootViewController:(UIViewController *)vc
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"setRootViewController:";
    NSArray<NSString *> *args = @[self.shortDescription, vc ? vc.description : [NSNull null]];
    [[Outlet sharedOutlet] sendJSON:@{@"class": @"UIWindow",
                                      @"selector": NSStringFromSelector(_cmd),
                                      @"args": args}];
    [GGLogger logFmt:@"[%@ (did)%@] %@", @"UIWindow", selStr, [args componentsJoinedByString:@" "]];
    [self monkey_setRootViewController:vc];
}

-(void)monkey_makeKeyWindow
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"makeKeyWindow";
    NSArray<NSString *> *args = @[self.shortDescription];
    [[Outlet sharedOutlet] sendJSON:@{@"class": @"UIWindow",
                                      @"selector": NSStringFromSelector(_cmd),
                                      @"args": args}];
    [self monkey_makeKeyWindow];
    [GGLogger logFmt:@"[%@ (did)%@]", @"UIWindow", selStr];
}

-(void)monkey_makeKeyAndVisible
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"makeKeyAndVisible";
    NSArray<NSString *> *args = @[self.shortDescription];
    [[Outlet sharedOutlet] sendJSON:@{@"class": @"UIWindow",
                                      @"selector": NSStringFromSelector(_cmd),
                                      @"args": args}];
    [self monkey_makeKeyAndVisible];
    [GGLogger logFmt:@"[%@ (did)%@]", @"UIWindow", selStr];
}

-(void)monkey_becomeKeyWindow
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"becomeKeyWindow";
    NSArray<NSString *> *args = @[self.shortDescription];
    [[Outlet sharedOutlet] sendJSON:@{@"class": @"UIWindow",
                                      @"selector": NSStringFromSelector(_cmd),
                                      @"args": args}];
    [self monkey_becomeKeyWindow];
    [GGLogger logFmt:@"[%@ (did)%@]", @"UIWindow", selStr];
    
}

@end
