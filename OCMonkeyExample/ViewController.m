//
//  ViewController.m
//  OCMonkeyExample
//
//  Created by gogleyin on 27/03/2017.
//
//

#import "ViewController.h"
#import "Macros.h"
#import "Tree.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _agent = [[AgentForHost alloc] initWithDelegate:self];
    [_agent connectToLocalIPv4AtPort:2345];
    NSDictionary *ui = [_agent jsonAction:@{@"path": @"tree"} timeout:2];
    Tree *tree = [_agent getViewHierarchy];
}


- (void)viewController:(NSString *)vc didAppearAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ viewDidAppear:%@]", prefix, vc, animated ? @"Yes" : @"No");
//    [self.appearedVCs enqueue:vc];
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPushViewController:(NSString *)pushedVC animated:(BOOL)animated
{
    NSLog(@"%@ [%@ pushViewController:%@ animated:%@]", prefix, naviCtrl, pushedVC, animated ? @"Yes" : @"No");
    BOOL ret = YES;
//    if (ret)
//        [self.vcStack push:pushedVC];
    return ret; // If return NO, the pushedVC will not get pushed into naviCtrl.
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopViewControllerAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ popViewController:%@]", prefix, naviCtrl, animated ? @"Yes" : @"No");
    BOOL ret = YES;
//    if (ret)
//        [self.vcStack pop];
    return ret; // If return NO, the naviCtrl will not perform pop action.
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopToRootViewControllerAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ popToRootViewControllerAnimated:%@]", prefix, naviCtrl, animated ? @"Yes" : @"No");
    BOOL ret = YES;
//    if (ret)
//        [self.vcStack popToRoot];
    return ret;
}

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopToViewController:(NSString *)toVC animated:(BOOL)animated
{
    NSLog(@"%@ [%@ popToViewController:%@ animated: %@]", prefix, naviCtrl, toVC, animated ? @"Yes" : @"No");
    BOOL ret = YES;
//    if (ret)
//        [self.vcStack popToNSString:toVC];
    return ret;
}

- (void)naviCtrl:(NSString *)naviCtrl initWithRootViewController:(NSString *)vc
{
    NSLog(@"%@ [%@ initWithRootViewController:%@]", prefix, naviCtrl, vc);
}

- (void)naviCtrl:(NSString *)naviCtrl setViewControllers:(NSArray<NSString *> *)vcs animated:(BOOL)animted
{
    NSLog(@"%@ [%@ setViewControllers:%@ animted:%@]", prefix, naviCtrl, [vcs componentsJoinedByString:@" "], [NSNumber numberWithBool:animted]);
}

- (void)tabCtrl:(NSString *)tabCtrl setViewControllers:(NSArray<NSString *> *)vcs animated:(BOOL)animted
{
    NSLog(@"%@ [%@ setViewControllers:%@ animted:%@]", prefix, tabCtrl, [vcs componentsJoinedByString:@" "], [NSNumber numberWithBool:animted]);
}


@end
