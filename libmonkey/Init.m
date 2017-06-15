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
#import "UIWindow+Monkey.h"
#import "UIApplication+libmonkey.h"
#import "Macros.h"
#import "XCUIApplication.h"
#import "swizzle.h"
#import "Outlet.h"
#import "MSHook.h"
#import "GGLogger.h"

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
    swizzleInstanceMethod(UITabBar, @selector(init), @selector(monkey_init));
    swizzleInstanceMethod(UITabBar, @selector(setViewControllers:animated:), @selector(monkey_setViewControllers:animated:));
    swizzleInstanceMethod(UITabBar, @selector(setSelectedIndex:), @selector(monkey_setSelectedIndex:));
}

void swizzle_UIWindow()
{
    Class UIWin = [UIWindow class];
    swizzleInstanceMethod(UIWin, @selector(setRootViewController:), @selector(monkey_setRootViewController:));
//    swizzleInstanceMethod(UIWin, @selector(rootViewController), @selector(monkey_rootViewController));
    swizzleInstanceMethod(UIWin, @selector(makeKeyWindow), @selector(monkey_makeKeyWindow));
    swizzleInstanceMethod(UIWin, @selector(makeKeyAndVisible), @selector(monkey_makeKeyAndVisible));
    swizzleInstanceMethod(UIWin, @selector(becomeKeyWindow), @selector(monkey_becomeKeyWindow));
}

void swizzle_UIApplication()
{
    Class UIApp = [UIApplication class];
    swizzleInstanceMethod(UIApp, @selector(openURL:options:completionHandler:), @selector(monkey_openURL:options:completionHandler:));
    swizzleInstanceMethod(UIApp, @selector(openURL:), @selector(monkey_openURL:));
}

void start_socket_communication()
{
    Outlet *outlet = [Outlet sharedOutlet];
    [outlet start];
}

/* [MemoryUploadCenter initMemoryWindow] */
void (*origin_initMemoryWindow_MemoryUploadCenter)(id, SEL);
void new_initMemoryWindow_MemoryUploadCenter(id self, SEL _cmd)
{
    [GGLogger logFmt:@"[MemoryUploadCenter(%p) initMemoryWindow]", self];
}

void hookBusinees()
{
    MSHookFunction(objc_getClass("MemoryUploadCenter"), @selector(initMemoryWindow), (IMP)new_initMemoryWindow_MemoryUploadCenter, (IMP)&origin_initMemoryWindow_MemoryUploadCenter);
}
