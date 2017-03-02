//
//  MonkeyRunner.m
//  MonkeyRunner
//
//  Created by gogleyin on 02/03/2017.
//
//

#import <XCTest/XCTest.h>
#import "Monkey.h"

@interface MonkeyRunner : XCTestCase

@end

@implementation MonkeyRunner

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRunner {
    [[[Monkey alloc] initWithBundleID:@"com.apple.Health"] run:100];
}

@end
