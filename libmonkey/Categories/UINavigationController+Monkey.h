//
//  UINavigationController+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Monkey)

#pragma mark Creating Navigation Controllers
- (instancetype _Nonnull)monkey_initWithRootViewController:(UIViewController *_Nonnull)rootViewController;
- (instancetype _Nonnull)monkey_initWithNavigationBarClass:(Class _Nullable )navigationBarClass
                                     toolbarClass:(Class _Nullable)toolbarClass;

#pragma mark Pushing and Popping Stack Items
- (void)monkey_pushViewController:(UIViewController *_Nonnull)viewController
                         animated:(BOOL)animated;
- (nullable UIViewController *)monkey_popViewControllerAnimated:(BOOL)animated;
- (nullable NSArray<__kindof UIViewController *> *)monkey_popToRootViewControllerAnimated:(BOOL)animated;
- (nullable NSArray<__kindof UIViewController *> *)monkey_popToViewController:(UIViewController *_Nonnull)viewController
                                                            animated:(BOOL)animated;

- (void)monkey_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated;

- (void)monkey_showViewController:(UIViewController *)vc
                           sender:(nullable id)sender NS_AVAILABLE_IOS(8_0); // Interpreted as pushViewController:animated:

@end

NS_ASSUME_NONNULL_END
