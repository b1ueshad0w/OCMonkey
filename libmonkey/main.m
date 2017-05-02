//
//  main.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "_XCInternalTestRun+Monkey.h"
#import "UINavigationController+Monkey.h"
#import "Macros.h"
#import "XCUIApplication.h"
#import "swizzle.h"




static __attribute__((constructor)) void onLoad(){
    NSLog(@"%@ monkey dylib is loaded", prefix);
    swizzleInstanceMethod([_XCInternalTestRun class], @selector(start), @selector(monkey_start));
    swizzleInstanceMethod([UINavigationController class], @selector(initWithRootViewController:), @selector(monkey_initWithRootViewController:));
    swizzleInstanceMethod([UINavigationController class], @selector(initWithNavigationBarClass:toolbarClass:), @selector(monkey_initWithNavigationBarClass:toolbarClass:));
    swizzleInstanceMethod([UINavigationController class], @selector(pushViewController:animated:), @selector(monkey_pushViewController:animated:));
    swizzleInstanceMethod([UINavigationController class], @selector(popViewControllerAnimated:), @selector(monkey_popViewControllerAnimated:));
    swizzleInstanceMethod([UINavigationController class], @selector(popToViewController:animated:), @selector(monkey_popToViewController:animated:));
    swizzleInstanceMethod([UINavigationController class], @selector(popToRootViewControllerAnimated:), @selector(monkey_popToRootViewControllerAnimated:));
    swizzleInstanceMethod([UINavigationController class], @selector(setViewControllers:animated:), @selector(monkey_setViewControllers:animated:));
}

static __attribute__((destructor)) void onUnload(){
    NSLog(@"%@ monkey dylib is unloaded", prefix);
}
