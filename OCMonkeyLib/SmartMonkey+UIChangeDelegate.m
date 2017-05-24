//
//  Monkey+UIChangeDelegate.m
//  OCMonkey
//
//  Created by gogleyin on 05/05/2017.
//
//

#import "SmartMonkey+UIChangeDelegate.h"
#import "Macros.h"
#import "NSMutableArray+Queue.h"
#import "NSMutableArray+Stack.h"

@implementation SmartMonkey (UIChangeDelegate)

- (void)viewController:(VCType *)vc didAppearAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ viewDidAppear:%@]", prefix, vc, animated ? @"Yes" : @"No");
    [self.appearedVCs enqueue:vc];
    if ([self.tabCtrls objectForKey:vc]) {
        self.activeTabCtrl = self.tabCtrls[vc];
    }
}

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPushViewController:(VCType *)pushedVC animated:(BOOL)animated
{
    NSLog(@"%@ [%@ pushViewController:%@ animated:%@]", prefix, naviCtrl, pushedVC, animated ? @"Yes" : @"No");
    BOOL ret = YES;
    if (ret) {
        if ([self.naviCtrls objectForKey:naviCtrl]) {
            [self.naviCtrls[naviCtrl] pushVC:pushedVC];
        }
    }
    return ret; // If return NO, the pushedVC will not get pushed into naviCtrl.
}

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopViewControllerAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ popViewController:%@]", prefix, naviCtrl, animated ? @"Yes" : @"No");
    BOOL ret = YES;
    if (ret) {
        if ([self.naviCtrls objectForKey:naviCtrl]) {
            [self.naviCtrls[naviCtrl] pop];
        }
    }
    return ret; // If return NO, the naviCtrl will not perform pop action.
}

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopToRootViewControllerAnimated:(BOOL)animated
{
    NSLog(@"%@ [%@ popToRootViewControllerAnimated:%@]", prefix, naviCtrl, animated ? @"Yes" : @"No");
    BOOL ret = YES;
    if (ret && [self.naviCtrls objectForKey:naviCtrl])
        [self.naviCtrls[naviCtrl] popToRootVC];
    return ret;
}

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopToViewController:(VCType *)toVC animated:(BOOL)animated
{
    NSLog(@"%@ [%@ popToViewController:%@ animated: %@]", prefix, naviCtrl, toVC, animated ? @"Yes" : @"No");
    BOOL ret = YES;
    if (ret && [self.naviCtrls objectForKey:naviCtrl])
        [self.naviCtrls[naviCtrl] popToVC:toVC];
    return ret;
}

- (void)naviCtrl:(VCType *)naviCtrl initWithRootViewController:(VCType *)vc
{
    NSLog(@"%@ [%@ initWithRootViewController:%@]", prefix, naviCtrl, vc);
    if (![self.naviCtrls objectForKey:naviCtrl]) {
        [self.naviCtrls setObject:[[NaviCtrl alloc] initWithRootVC:vc] forKey:naviCtrl];
    }
}

- (void)naviCtrl:(VCType *)naviCtrl setViewControllers:(NSArray<VCType *> *)vcs animated:(BOOL)animted
{
    NSLog(@"%@ [%@ setViewControllers:%@ animted:%@]", prefix, naviCtrl, [vcs componentsJoinedByString:@" "], [NSNumber numberWithBool:animted]);
    if ([self.naviCtrls objectForKey:naviCtrl]) {
        [self.naviCtrls[naviCtrl] setVCs:vcs];
    }
    
}

- (void)tabCtrl:(VCType *)tabCtrl setViewControllers:(NSArray<VCType *> *)vcs animated:(BOOL)animted
{
    NSLog(@"%@ [%@ setViewControllers:%@ animted:%@]", prefix, tabCtrl, [vcs componentsJoinedByString:@" "], [NSNumber numberWithBool:animted]);
    if ([self.tabCtrls objectForKey:tabCtrl]) {
        self.tabCtrls[tabCtrl].tabs = [[NSMutableArray alloc] initWithArray:vcs copyItems:YES];
    } else {
        NSLog(@"%@ [TabBarCtrl setViewControllers:animated:] callback failed. TabBarController not found: %@", prefix, tabCtrl);
    }
    
}

- (void)tabCtrlInit:(VCType *)tabCtrl
{
    NSLog(@"%@ [%@ init]", prefix, tabCtrl);
    if (![self.tabCtrls objectForKey:tabCtrl]) {
        [self.tabCtrls setObject:[[TabBarCtrl alloc] init] forKey:tabCtrl];
    }
}

- (void)tabCtrl:(VCType *)tabCtrl setSelectedIndex:(NSUInteger)index
{
    NSLog(@"%@ [%@ setSelectedIndex: %lu]", prefix, tabCtrl, (unsigned long)index);
    if ([self.tabCtrls objectForKey:tabCtrl]) {
        self.tabCtrls[tabCtrl].selectedIndex = index;
    } else {
        NSLog(@"%@ TabBarController not found: %@", prefix, tabCtrl);
    }
}

@end
