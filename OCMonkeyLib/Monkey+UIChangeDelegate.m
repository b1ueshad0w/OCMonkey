//
//  Monkey+UIChangeDelegate.m
//  OCMonkey
//
//  Created by gogleyin on 05/05/2017.
//
//

#import "Monkey+UIChangeDelegate.h"
#import "Macros.h"

@implementation Monkey (UIChangeDelegate)

- (void)viewController:(NSString *)vc didAppearAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ viewDidAppear:%@", prefix, vc, animated ? @"Yes" : @"No");
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPushViewController:(NSString *)pushedVC animated:(BOOL)animated
{
    NSLog(@"%@ [%@ pushViewController:%@ animated:%@]", prefix, naviCtrl, pushedVC, animated ? @"Yes" : @"No");
    return YES; // If return NO, the pushedVC will not get pushed into naviCtrl.
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopViewControllerAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ popViewController:%@]", prefix, naviCtrl, animated ? @"Yes" : @"No");
    return YES; // If return NO, the naviCtrl will not perform pop action.
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopToRootViewControllerAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ popToRootViewControllerAnimated:%@]", prefix, naviCtrl, animated ? @"Yes" : @"No");
    return YES;
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopToViewController:(NSString *)toVC animated:(BOOL)animated
{
    NSLog(@"%@ [%@ popToViewController:%@ animated: %@] ==> %@", prefix, naviCtrl, toVC, animated ? @"Yes" : @"No");
    return YES;
}

- (void)naviCtrl:(NSString *)naviCtrl initWithRootViewController:(NSString *)vc
{
    NSLog(@"%@ [%@ initWithRootViewController:%@]", prefix, naviCtrl, vc);
}

- (void)naviCtrl:(NSString *)naviCtrl setViewControllers:(NSArray<NSString *>*)VCs animated:(BOOL)animted
{
    NSLog(@"%@ [%@ setViewControllers:%@]", prefix, naviCtrl, VCs);
}

@end
