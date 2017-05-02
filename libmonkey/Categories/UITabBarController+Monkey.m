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

@implementation UITabBarController (Monkey)

- (void)monkey_setViewControllers:(NSArray<__kindof UIViewController *> * __nullable)viewControllers
                         animated:(BOOL)animated
{
    NSLog(@"%@ [%@(%p) setViewControllers: %@ animated: %@]",
          prefix,
          NSStringFromClass([self class]), self,
          viewControllers,
          animated ? @"Yes" : @"No");
    Outlet *outlet = [Outlet sharedOutlet];
    if (!outlet.tabBarController) {
        NSLog(@"%@ TabBarController initialized at: %p", prefix, self);
        outlet.tabBarController = self;
    }
    return [self monkey_setViewControllers:viewControllers animated:animated];
}

@end
