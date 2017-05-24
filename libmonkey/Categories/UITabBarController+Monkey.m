//
//  UITabBarController+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import "UITabBarController+Monkey.h"
#import "Macros.h"
#import "Outlet.h"

#define UITabCtrl @"UITabBarController"

@implementation UITabBarController (Monkey)

- (id)monkey_init
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"init";
    UITabBarController *tabCtrl = [self monkey_init];
    NSArray<NSString *> *args = @[self.description, tabCtrl.description];
    NSDictionary *toSend = @{@"class": UITabCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    [[Outlet sharedOutlet] sendJSON:toSend];
    NSLog(@"%@ [%@ (did)%@] %@", prefix, UITabCtrl, selStr, [args componentsJoinedByString:@" "]);
    return tabCtrl;
}

- (void)monkey_setViewControllers:(NSArray<__kindof UIViewController *> * __nullable)viewControllers
                         animated:(BOOL)animated
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"setViewControllers:animated:";
    NSMutableArray<NSString *> *vcStrs = [[NSMutableArray alloc] init];
    for (UIViewController *vc in viewControllers) {
        [vcStrs addObject:vc.description];
    }
    NSArray<NSString *> *args = @[self.description, vcStrs, [NSNumber numberWithBool:animated], [NSNull null]];
    NSDictionary *toSend = @{@"class": UITabCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    [[Outlet sharedOutlet] sendJSON:toSend];
    [self monkey_setViewControllers:viewControllers animated:animated];
    NSLog(@"%@ [%@ (did)%@] %@", prefix, UITabCtrl, selStr, [args componentsJoinedByString:@" "]);
}


- (void)monkey_setSelectedIndex:(NSUInteger)index
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"setSelectedIndex:";
    NSArray<NSString *> *args = @[self.description, [NSNumber numberWithUnsignedInteger:index], [NSNull null]];
    NSLog(@"%@ [%@ (will)%@] %@", prefix, UITabCtrl, selStr, [args componentsJoinedByString:@" "]);
    
    NSDictionary *toSend = @{@"class": UITabCtrl,
                             @"selector": selStr,
                             @"args": args};
    
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 2 seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        [self monkey_setSelectedIndex:index];
    } else {
        NSLog(@"%@ I am told not to do: %@", prefix, selStr);
    }
    return;
}

@end
