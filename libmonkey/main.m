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
#import "Outlet.h"




static __attribute__((constructor)) void onLoad(){
    NSLog(@"%@ monkey dylib is loaded", prefix);
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
    
    swizzleInstanceMethod([UINavigationController class], @selector(initWithRootViewController:), @selector(monkey_initWithRootViewController:));
    swizzleInstanceMethod([UINavigationController class], @selector(initWithNavigationBarClass:toolbarClass:), @selector(monkey_initWithNavigationBarClass:toolbarClass:));
    swizzleInstanceMethod([UINavigationController class], @selector(pushViewController:animated:), @selector(monkey_pushViewController:animated:));
    swizzleInstanceMethod([UINavigationController class], @selector(popViewControllerAnimated:), @selector(monkey_popViewControllerAnimated:));
    swizzleInstanceMethod([UINavigationController class], @selector(popToViewController:animated:), @selector(monkey_popToViewController:animated:));
    swizzleInstanceMethod([UINavigationController class], @selector(popToRootViewControllerAnimated:), @selector(monkey_popToRootViewControllerAnimated:));
    swizzleInstanceMethod([UINavigationController class], @selector(setViewControllers:animated:), @selector(monkey_setViewControllers:animated:));
    
    Outlet *outlet = [Outlet sharedOutlet];
    [outlet start];
}

static __attribute__((destructor)) void onUnload(){
    NSLog(@"%@ monkey dylib is unloaded", prefix);
}
