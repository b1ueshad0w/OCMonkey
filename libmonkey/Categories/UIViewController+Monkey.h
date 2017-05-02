//
//  UIViewController+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (Monkey)

- (void)monkey_viewDidAppear:(BOOL)animated;
- (void)monkey_showViewController:(UIViewController *)vc sender:(nullable id)sender;
- (void)monkey_showDetailViewController:(UIViewController *)vc sender:(nullable id)sender;
- (void)monkey_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

@end
