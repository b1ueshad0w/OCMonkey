//
//  UITabBarController+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Monkey)

- (id)monkey_init;

- (void)monkey_setViewControllers:(NSArray<__kindof UIViewController *> * __nullable)viewControllers
                         animated:(BOOL)animated;

- (void)monkey_setSelectedIndex:(NSUInteger)index;

@end
