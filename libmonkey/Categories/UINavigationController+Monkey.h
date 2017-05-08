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
- (instancetype _Nonnull)monkey_initWithRootViewController:(UIViewController *_Nonnull)rootViewController;
- (instancetype _Nonnull)monkey_initWithNavigationBarClass:(Class _Nullable )navigationBarClass
                                     toolbarClass:(Class _Nullable)toolbarClass;

#pragma mark Pushing and Popping Stack Items
- (void)monkey_pushViewController:(UIViewController *_Nonnull)viewController
                         animated:(BOOL)animated;
- (UIViewController *_Nonnull)monkey_popViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *_Nonnull)monkey_popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *_Nonnull)monkey_popToViewController:(UIViewController *_Nonnull)viewController
                                                            animated:(BOOL)animated;

- (void)monkey_setViewControllers:(NSArray<UIViewController *> *_Nonnull)viewControllers
                  animated:(BOOL)animated;

- (void)monkey_showViewController:(UIViewController *_Nonnull)vc
                           sender:(nullable id)sender NS_AVAILABLE_IOS(8_0); // Interpreted as pushViewController:animated:

@end
