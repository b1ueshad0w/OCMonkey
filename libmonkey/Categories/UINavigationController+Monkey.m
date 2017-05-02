//
//  UINavigationController+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import "UINavigationController+Monkey.h"
#import "Macros.h"
//#import <objc/runtime.h>

@implementation UINavigationController (Monkey)

#pragma mark Creating Navigation Controllers
- (instancetype)monkey_initWithRootViewController:(UIViewController *)rootViewController
{
    UINavigationController *nc = [self monkey_initWithRootViewController:rootViewController];
    NSLog(@"%@ [%@ initWithRootViewController: %@] ==> (%p)",
          prefix,
          NSStringFromClass([self class]),
          NSStringFromClass([rootViewController class]),
          nc);
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
    NSLog(@"%@ [%@(%p) pushViewController: %@ animated: %@]", prefix, NSStringFromClass([self class]), self, NSStringFromClass([viewController class]), animated ? @"Yes" : @"No");
    return [self monkey_pushViewController:viewController animated:animated];
}

- (UIViewController *)monkey_popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = [self monkey_popViewControllerAnimated:animated];
    NSLog(@"%@ [%@(%p) popViewControllerAnimated: %@] ==> %@", prefix, NSStringFromClass([self class]), self, animated ? @"Yes" : @"No", NSStringFromClass([viewController class]));
    return viewController;
}
- (NSArray<__kindof UIViewController *> *)monkey_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<UIViewController *> *viewControllers = [self monkey_popToRootViewControllerAnimated:animated];
    NSLog(@"%@ [%@(%p) popToRootViewControllerAnimated: %@] ==> %@", prefix, NSStringFromClass([self class]), self, animated ? @"Yes" : @"No", viewControllers);
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)monkey_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray<UIViewController *> *viewControllers = [self monkey_popToViewController:viewController animated:animated];
    NSLog(@"%@ [%@(%p) popToViewController: %@ animated: %@] ==> %@", prefix, NSStringFromClass([self class]), self, NSStringFromClass([viewController class]), animated ? @"Yes" : @"No", viewControllers);
    return viewControllers;
}

- (void)monkey_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated
{
    NSLog(@"%@ [%@(%p) setViewControllers: %@ animated: %@]", prefix, NSStringFromClass([self class]), self, viewControllers, animated ? @"Yes" : @"No");
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
