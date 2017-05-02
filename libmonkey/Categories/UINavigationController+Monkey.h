//
//  UINavigationController+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <UIKit/UIKit.h>


@interface UINavigationController (Monkey)

#pragma mark Creating Navigation Controllers
- (instancetype)monkey_initWithRootViewController:(UIViewController *)rootViewController;
- (instancetype)monkey_initWithNavigationBarClass:(Class)navigationBarClass
                                     toolbarClass:(Class)toolbarClass;

#pragma mark Pushing and Popping Stack Items
- (void)monkey_pushViewController:(UIViewController *)viewController
                         animated:(BOOL)animated;
- (UIViewController *)monkey_popViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)monkey_popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)monkey_popToViewController:(UIViewController *)viewController
                                                            animated:(BOOL)animated;

- (void)monkey_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated;

@end
