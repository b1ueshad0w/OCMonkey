//
//  UINavigationController+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import "UINavigationController+Monkey.h"
#import "Macros.h"
#import "Outlet.h"
#import "GGLogger.h"

#define UINaviCtrl @"UINavigationController"

@implementation UINavigationController (Monkey)

#pragma mark Creating Navigation Controllers
- (instancetype)monkey_initWithRootViewController:(UIViewController *)vc
{
    //NSString *selStr = NSStringFromSelector(_cmd);
    /* Why not use _cmd?
     * Because if this method is hooked more than one place, the _cmd will be unpredictable.
     * For example, anotherCategory_pushViewController also hooks this method, then
     * _cmd may be "anotherCategory_pushViewController", or "pushViewController"
     */
    NSString *selStr = @"initWithRootViewController:";
    UINavigationController *nc = [self monkey_initWithRootViewController:vc];
    NSArray<NSString *> *args = @[self.description, vc.description, nc.description];
    [GGLogger logFmt:@"[UINavigationController (did)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    [[Outlet sharedOutlet] sendJSON:@{@"class": UINaviCtrl,
                                      @"selector": selStr,
                                      @"args": args,}];
    return nc;
}

- (instancetype)monkey_initWithNavigationBarClass:(nullable Class)navigationBarClass
                                     toolbarClass:(nullable Class)toolbarClass
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"initWithNavigationBarClass:toolbarClass:";
    UINavigationController *nc = [self monkey_initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    NSArray<NSString *> *args = @[self.description,
                                  navigationBarClass ? NSStringFromClass(navigationBarClass) : @"nil",
                                  toolbarClass ? NSStringFromClass(toolbarClass) : @"nil",
                                  nc.description];
    [GGLogger logFmt:@"[UINavigationController (did)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    [[Outlet sharedOutlet] sendJSON:@{@"class": UINaviCtrl,
                                      @"selector": selStr,
                                      @"args": args,}];
    return nc;
}

#pragma mark Pushing and Popping Stack Items
- (void)monkey_pushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    NSString *selStr = @"pushViewController:animated:";
    NSArray<NSString *> *args = @[self.description, vc.description, [NSNumber numberWithBool:animated], [NSNull null]];
    [GGLogger logFmt:@"[UINavigationController (will)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    NSDictionary *toSend = @{@"class": UINaviCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    //    [[Outlet sharedOutlet] sendJSON:toSend];
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 2 seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        [self monkey_pushViewController:vc animated:animated];
    } else {
        [GGLogger logFmt:@"I am told not to do: %@", selStr];
    }
    return;
}

- (nullable UIViewController *)monkey_popViewControllerAnimated:(BOOL)animated
{
    NSString *selStr = @"popViewControllerAnimated:";
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSArray<NSString *> *args = @[self.description, [NSNumber numberWithBool:animated], [NSNull null]];
    [GGLogger logFmt:@"[UINavigationController (will)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    NSDictionary *toSend = @{@"class": UINaviCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 1 nano seconds = 1 / (10 ^ 9) seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        return [self monkey_popViewControllerAnimated:animated];
    } else {
        [GGLogger logFmt:@"I am told not to do: %@", selStr];
    }
    return nil;
}


- (nullable NSArray<__kindof UIViewController *> *)monkey_popToRootViewControllerAnimated:(BOOL)animated
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"popToRootViewControllerAnimated:";
    NSArray<NSString *> *args = @[self.description, [NSNumber numberWithBool:animated], [NSNull null]];
    [GGLogger logFmt:@"[UINavigationController (will)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    NSDictionary *toSend = @{@"class": UINaviCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 1 nano seconds = 1 / (10 ^ 9) seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        return [self monkey_popToRootViewControllerAnimated:animated];
    } else {
        [GGLogger logFmt:@"I am told not to do: %@", selStr];
    }
    return nil;
}


- (nullable NSArray<__kindof UIViewController *> *)monkey_popToViewController:(UIViewController *)vc animated:(BOOL)animated
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"popToViewController:animated:";
    NSArray<NSString *> *args = @[self.description, vc.description, [NSNumber numberWithBool:animated], [NSNull null]];
    [GGLogger logFmt:@"[UINavigationController (will)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    NSDictionary *toSend = @{@"class": UINaviCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 1 nano seconds = 1 / (10 ^ 9) seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        return [self monkey_popToViewController:vc animated:animated];
    } else {
        [GGLogger logFmt:@"I am told not to do: %@", selStr];
    }
    return nil;
}

- (void)monkey_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                         animated:(BOOL)animated
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"setViewControllers:animated:";
    NSMutableArray<NSString *> *vcStrs = [[NSMutableArray alloc] init];
    for (UIViewController *vc in viewControllers) {
        [vcStrs addObject:vc.description];
    }
    NSArray<NSString *> *args = @[self.description, vcStrs, [NSNumber numberWithBool:animated], [NSNull null]];
    NSDictionary *toSend = @{@"class": UINaviCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    [[Outlet sharedOutlet] sendJSON:toSend];
    [self monkey_setViewControllers:viewControllers animated:animated];
    [GGLogger logFmt:@"[UINavigationController (did)%@] %@ %@", selStr, [vcStrs componentsJoinedByString:@" "], args[2]];
}

- (void)monkey_showViewController:(UIViewController *)vc sender:(nullable id)sender
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"showViewController:sender:";
    NSArray<NSString *> *args = @[self.description, vc.description, sender, [NSNull null]];
    [GGLogger logFmt:@"[UINavigationController (will)%@] %@", selStr, [args componentsJoinedByString:@" "]];
    NSDictionary *toSend = @{@"class": UINaviCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 1 nano seconds = 1 / (10 ^ 9) seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        return [self monkey_showViewController:vc sender:sender];
    } else {
        [GGLogger logFmt:@"I am told not to do: %@", selStr];
    }
}

@end
