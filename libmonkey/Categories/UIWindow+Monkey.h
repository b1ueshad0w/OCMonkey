//
//  UIWindow+Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 24/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface UIWindow (Monkey)

-(UIViewController *)monkey_rootViewController;

-(void)monkey_setRootViewController:(UIViewController *)vc;

-(void)monkey_makeKeyWindow;

-(void)monkey_makeKeyAndVisible;

-(void)monkey_becomeKeyWindow;

@end
