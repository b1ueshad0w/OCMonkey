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
#import "GGLogger.h"

@implementation SmartMonkey (UIChangeDelegate)

- (void)viewController:(VCType *)vc didAppearAnimated:(BOOL)animated
{
    [GGLogger logFmt:@"[%@ viewDidAppear:%@]", vc, animated ? @"Yes" : @"No"];
    [self.appearedVCs enqueue:vc];
    if ([self.tabCtrls objectForKey:vc]) {
        self.activeTabCtrl = self.tabCtrls[vc];
    }
}

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPushViewController:(VCType *)pushedVC animated:(BOOL)animated
{
    [GGLogger logFmt:@"[%@ pushViewController:%@ animated:%@]", naviCtrl, pushedVC, animated ? @"Yes" : @"No"];
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
    [GGLogger logFmt:@"[%@ popViewController:%@]", naviCtrl, animated ? @"Yes" : @"No"];
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
    [GGLogger logFmt:@"[%@ popToRootViewControllerAnimated:%@]", naviCtrl, animated ? @"Yes" : @"No"];
    BOOL ret = YES;
    if (ret && [self.naviCtrls objectForKey:naviCtrl])
        [self.naviCtrls[naviCtrl] popToRootVC];
    return ret;
}

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopToViewController:(VCType *)toVC animated:(BOOL)animated
{
    [GGLogger logFmt:@"[%@ popToViewController:%@ animated: %@]", naviCtrl, toVC, animated ? @"Yes" : @"No"];
    BOOL ret = YES;
    if (ret && [self.naviCtrls objectForKey:naviCtrl])
        [self.naviCtrls[naviCtrl] popToVC:toVC];
    return ret;
}

- (void)naviCtrl:(VCType *)naviCtrl initWithRootViewController:(VCType *)vc
{
    [GGLogger logFmt:@"[%@ initWithRootViewController:%@]", naviCtrl, vc];
    if (![self.naviCtrls objectForKey:naviCtrl]) {
        [self.naviCtrls setObject:[[NaviCtrl alloc] initWithRootVC:vc] forKey:naviCtrl];
    }
}

- (void)naviCtrl:(VCType *)naviCtrl setViewControllers:(NSArray<VCType *> *)vcs animated:(BOOL)animted
{
    [GGLogger logFmt:@"[%@ setViewControllers:%@ animted:%@]", naviCtrl, [vcs componentsJoinedByString:@" "], [NSNumber numberWithBool:animted]];
    if ([self.naviCtrls objectForKey:naviCtrl]) {
        [self.naviCtrls[naviCtrl] setVCs:vcs];
    }
    
}

- (void)tabCtrl:(VCType *)tabCtrl setViewControllers:(NSArray<VCType *> *)vcs animated:(BOOL)animted
{
    [GGLogger logFmt:@"[%@ setViewControllers:%@ animted:%@]", tabCtrl, [vcs componentsJoinedByString:@" "], [NSNumber numberWithBool:animted]];
    if ([self.tabCtrls objectForKey:tabCtrl]) {
        self.tabCtrls[tabCtrl].tabs = [[NSMutableArray alloc] initWithArray:vcs copyItems:YES];
    } else {
        [GGLogger logFmt:@"[TabBarCtrl setViewControllers:animated:] callback failed. TabBarController not found: %@", tabCtrl];
    }
    
}

- (void)tabCtrlInit:(VCType *)tabCtrl
{
    [GGLogger logFmt:@"[%@ init]", tabCtrl];
    if (![self.tabCtrls objectForKey:tabCtrl]) {
        [self.tabCtrls setObject:[[TabBarCtrl alloc] init] forKey:tabCtrl];
    }
}

- (void)tabCtrl:(VCType *)tabCtrl setSelectedIndex:(NSUInteger)index
{
    [GGLogger logFmt:@"[%@ setSelectedIndex: %lu]", tabCtrl, (unsigned long)index];
    if ([self.tabCtrls objectForKey:tabCtrl]) {
        self.tabCtrls[tabCtrl].selectedIndex = index;
    } else {
        [GGLogger logFmt:@"TabBarController not found: %@", tabCtrl];
    }
}

@end
