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



static __attribute__((constructor)) void onLoad(){
    NSLog(@"%@ monkey dylib is loaded", prefix);
    swizzle_XCTest();
    swizzle_UINavigationController();
    swizzle_UIViewController();
    swizzle_UITabBarController();
    start_socket_communication();
}

static __attribute__((destructor)) void onUnload(){
    NSLog(@"%@ monkey dylib is unloaded", prefix);
}
