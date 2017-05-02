//
//  main.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "_XCInternalTestRun+Monkey.h"
#import "Macros.h"




static __attribute__((constructor)) void onLoad(){
    NSLog(@"%@ monkey dylib is loaded", prefix);
}

static __attribute__((destructor)) void onUnload(){
    NSLog(@"%@ monkey dylib is unloaded", prefix);
}
