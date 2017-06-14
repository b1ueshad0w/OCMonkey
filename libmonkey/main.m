//
//  main.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "Init.h"
#import "Macros.h"
#import "GGLogger.h"



static __attribute__((constructor)) void onLoad(){
    [GGLogger log:@"monkey dylib is loaded"];
    swizzle_XCTest();
    swizzle_UINavigationController();
    swizzle_UIViewController();
    swizzle_UITabBarController();
    swizzle_UIWindow();
    start_socket_communication();
    hookBusinees();
    
    NSString *crashDelay = [[NSProcessInfo processInfo] environment][@"MakeAppCrashAfterSeconds"];
    if (crashDelay) {
        [GGLogger logFmt:@"App will crash in %@ seconds.", crashDelay];
        int delayInSeconds = [crashDelay intValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            abort();
        });
    }
}

static __attribute__((destructor)) void onUnload(){
    [GGLogger log:@"monkey dylib is unloaded"];
}
