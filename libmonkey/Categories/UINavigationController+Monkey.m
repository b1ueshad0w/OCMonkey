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

@implementation UINavigationController (Monkey)

#pragma mark Creating Navigation Controllers
- (instancetype)monkey_initWithRootViewController:(UIViewController *)rootViewController
{
    UINavigationController *nc = [self monkey_initWithRootViewController:rootViewController];
    NSString *rootVC = NSStringFromClass([rootViewController class]);
    NSString *navi = NSStringFromClass([self class]);
    NSLog(@"%@ [%@ initWithRootViewController: %@] ==> (%p)", prefix, navi, rootVC, nc);
    [[Outlet sharedOutlet] sendJSON:@{@"selector": @"initWithRootViewController:",
                                      @"receiver": navi,
                                      @"args": @[rootVC],
                                      @"returned": navi}];
    return nc;
}

- (instancetype)monkey_initWithNavigationBarClass:(Class)navigationBarClass
                                     toolbarClass:(Class)toolbarClass
{
    UINavigationController *nc = [self monkey_initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    NSLog(@"%@ [%@ initWithNavigationBarClass: %@ toolbarClass: %@] ==> (%p)",
          prefix,
          NSStringFromClass([self class]),
          NSStringFromClass([navigationBarClass class]),
          NSStringFromClass([toolbarClass class]),
          nc);
    return nc;
}

#pragma mark Pushing and Popping Stack Items
- (void)monkey_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [self monkey_pushViewController:viewController animated:animated];
    NSString *selectorString = @"pushViewController:animated:";
    NSString *UINaviCtrlClassName = NSStringFromClass([self class]);
    NSString *vcClassName = NSStringFromClass([viewController class]);
    NSLog(@"%@ [%@(%p) (will)pushViewController: %@ animated: %@]",
          prefix,
          UINaviCtrlClassName,
          self,
          vcClassName,
          animated ? @"Yes" : @"No");
    NSDictionary *toSend = @{@"selector": selectorString,
                             @"receiver": UINaviCtrlClassName,
                             @"args": @[vcClassName, [NSNumber numberWithBool:animated]],
                             @"returned": [NSNull null]};
    
//    [[Outlet sharedOutlet] sendJSON:toSend];
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 2 seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        [self monkey_pushViewController:viewController animated:animated];
    } else {
        NSLog(@"%@ I am told not to do: %@", prefix, selectorString);
    }
    return;
}

- (UIViewController *)monkey_popViewControllerAnimated:(BOOL)animated
{
//    UIViewController *viewController = [self monkey_popViewControllerAnimated:animated];
//    NSString *popedVC = NSStringFromClass([viewController class]);
    NSString *selectorString = @"popViewControllerAnimated:";
    NSString *UINaviCtrlClassName = NSStringFromClass([self class]);
    NSLog(@"%@ [%@(%p) popViewControllerAnimated: %@]", prefix, UINaviCtrlClassName, self, animated ? @"Yes" : @"No");
    NSDictionary *toSend = @{@"selector": selectorString,
                             @"receiver": UINaviCtrlClassName,
                             @"args": @[[NSNumber numberWithBool:animated]]};
//    [[Outlet sharedOutlet] sendJSON:toSend];
    NSDictionary *response = [[Outlet sharedOutlet] jsonAction:toSend
                                                       timeout:[Outlet responseTimeout]];  // 1 nano seconds = 1 / (10 ^ 9) seconds
    BOOL shouldDo = YES;
    if (response && response[@"shouldDo"]) {
        shouldDo = [response[@"shouldDo"] boolValue];
    }
    if (shouldDo) {
        [self monkey_popViewControllerAnimated:animated];
    } else {
        NSLog(@"%@ I am told not to do: %@", prefix, selectorString);
    }
    return nil;
    
//    return viewController;
}
- (NSArray<__kindof UIViewController *> *)monkey_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<UIViewController *> *viewControllers = [self monkey_popToRootViewControllerAnimated:animated];
    NSString *UINaviCtrlClassName = NSStringFromClass([self class]);
    NSMutableArray<__kindof NSString *> *popedVCs = [[NSMutableArray alloc] init];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger index, BOOL *stop){
        [popedVCs addObject:NSStringFromClass([vc class])];
    }];
    NSLog(@"%@ [%@(%p) popToRootViewControllerAnimated: %@] ==> %@", prefix, NSStringFromClass([self class]), self, animated ? @"Yes" : @"No", popedVCs);
    [[Outlet sharedOutlet] sendJSON:@{@"selector": @"popToRootViewControllerAnimated:",
                                      @"receiver": UINaviCtrlClassName,
                                      @"args": @[[NSNumber numberWithBool:animated]],
                                      @"returned": popedVCs}];
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)monkey_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray<UIViewController *> *viewControllers = [self monkey_popToViewController:viewController animated:animated];
    NSString *toVC = NSStringFromClass([viewController class]);
    NSString *UINaviCtrlClassName = NSStringFromClass([self class]);
    NSMutableArray<__kindof NSString *> *popedVCs = [[NSMutableArray alloc] init];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger index, BOOL *stop){
        [popedVCs addObject:NSStringFromClass([vc class])];
    }];
    NSLog(@"%@ [%@(%p) popToViewController: %@ animated: %@] ==> %@", prefix, UINaviCtrlClassName, self, toVC, animated ? @"Yes" : @"No", viewControllers);
    [[Outlet sharedOutlet] sendJSON:@{@"selector": @"popToViewController:animated:",
                                      @"receiver": UINaviCtrlClassName,
                                      @"args": @[toVC, [NSNumber numberWithBool:animated]],
                                      @"returned": popedVCs}];
    return viewControllers;
}

- (void)monkey_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated
{
    NSString *UINaviCtrlClassName = NSStringFromClass([self class]);
    NSMutableArray<__kindof NSString *> *VCs = [[NSMutableArray alloc] init];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger index, BOOL *stop){
        [VCs addObject:NSStringFromClass([vc class])];
    }];
    NSLog(@"%@ [%@(%p) setViewControllers: %@ animated: %@]", prefix, UINaviCtrlClassName, self, VCs, animated ? @"Yes" : @"No");
    [[Outlet sharedOutlet] sendJSON:@{@"selector": @"setViewControllers:animated:",
                                      @"receiver": UINaviCtrlClassName,
                                      @"args": @[VCs, [NSNumber numberWithBool:animated]],
                                      @"returned": [NSNull null]}];
    return [self monkey_setViewControllers:viewControllers animated:animated];
}

- (void)monkey_showViewController:(UIViewController *)vc sender:(nullable id)sender
{
    NSLog(@"%@ [%@(%p) showViewController: %@ sender: %@]",
          prefix,
          NSStringFromClass([self class]), self,
          NSStringFromClass([vc class]),
          NSStringFromClass([sender class]));
    return [self monkey_showViewController:vc sender:sender];
}

@end
