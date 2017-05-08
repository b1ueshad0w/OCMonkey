//
//  Init.m
//  OCMonkey
//
//  Created by gogleyin on 03/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "Init.h"
#import "_XCInternalTestRun+Monkey.h"
#import "UINavigationController+Monkey.h"
#import "UIViewController+Monkey.h"
#import "UITabBarController+Monkey.h"
#import "Macros.h"
#import "XCUIApplication.h"
#import "swizzle.h"
#import "Outlet.h"

void swizzle_XCTest()
{
    /* If you were to hook XCTest, follow these steps:
     *  0. Add XCTest related swizzles files to this target under: $(PROJECT_DIR)/libmonkey/Categories/XCTest
     *  1. Add all .h files under $(PROJECT_DIR)/PrivateHeaders/XCTest into this target
     *  2. Add the following path to target's build setting "Framework Search Paths":
     $(PLATFORM_DIR)/Developer/Library/Frameworks
     *  3. Add "XCTest.framework" into target's Build Phases "Link Binary with Libraries" (Click '+' and should see it under 'Developer Frameworks')
     *  4. Add "XCTest.framework" into target's Build Phases "Copy Frameworks" (Click '+' and then click 'Add other...', Go to the following path and select XCTest.framework:
     $(PLATFORM_DIR)/Developer/Library/Frameworks
     where $(PLATFORM_DIR) maybe like: /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform for Simulator
     * However, for those framework which will be linked to a XCUITest target, only steps 1 and 2 are needed, as the host itself will embed XCTest.framework. OCMonkeyLib is an
     * example.
     */
    // swizzleInstanceMethod([_XCInternalTestRun class], @selector(start), @selector(monkey_start));
}


void swizzle_UINavigationController()
{
    Class UINaviCtl = [UINavigationController class];
    swizzleInstanceMethod(UINaviCtl, @selector(initWithRootViewController:), @selector(monkey_initWithRootViewController:));
    swizzleInstanceMethod(UINaviCtl, @selector(initWithNavigationBarClass:toolbarClass:), @selector(monkey_initWithNavigationBarClass:toolbarClass:));
    swizzleInstanceMethod(UINaviCtl, @selector(pushViewController:animated:), @selector(monkey_pushViewController:animated:));
    swizzleInstanceMethod(UINaviCtl, @selector(popViewControllerAnimated:), @selector(monkey_popViewControllerAnimated:));
    swizzleInstanceMethod(UINaviCtl, @selector(popToViewController:animated:), @selector(monkey_popToViewController:animated:));
    swizzleInstanceMethod(UINaviCtl, @selector(popToRootViewControllerAnimated:), @selector(monkey_popToRootViewControllerAnimated:));
    swizzleInstanceMethod(UINaviCtl, @selector(setViewControllers:animated:), @selector(monkey_setViewControllers:animated:));
}

void swizzle_UIViewController()
{
    Class UIViewCtl = [UIViewController class];
    swizzleInstanceMethod(UIViewCtl, @selector(viewDidAppear:), @selector(monkey_viewDidAppear:));
    swizzleInstanceMethod(UIViewCtl, @selector(showViewController:sender:), @selector(monkey_showViewController:sender:));
    swizzleInstanceMethod(UIViewCtl, @selector(showDetailViewController:sender:), @selector(monkey_showDetailViewController:sender:));
    swizzleInstanceMethod(UIViewCtl, @selector(presentViewController:animated:completion:), @selector(monkey_presentViewController:animated:completion:));
}

void swizzle_UITabBarController()
{
    Class UITabBar = [UITabBarController class];
    swizzleInstanceMethod(UITabBar, @selector(setViewControllers:animated:), @selector(monkey_setViewControllers:animated:));
}

void start_socket_communication()
{
    Outlet *outlet = [Outlet sharedOutlet];
    [outlet start];
}
