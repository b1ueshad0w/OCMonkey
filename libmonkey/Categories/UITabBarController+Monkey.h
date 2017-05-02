//
//  UITabBarController+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Monkey)

- (void)monkey_setViewControllers:(NSArray<__kindof UIViewController *> * __nullable)viewControllers
                         animated:(BOOL)animated;

@end
