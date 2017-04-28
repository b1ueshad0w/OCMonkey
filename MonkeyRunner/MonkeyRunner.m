//
//  MonkeyRunner.m
//  MonkeyRunner
//
//  Created by gogleyin on 02/03/2017.
//
//

#import <XCTest/XCTest.h>
#import "Monkey.h"
#import "Monkey+XCUITestPrivate.h"
#import "Monkey+XCUITest.h"

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
    NSString *bundleID = @"com.apple.Health";
    Monkey *monkey = [[Monkey alloc] initWithBundleID:bundleID];
    [monkey addDefaultXCTestPrivateActions];
    [monkey addXCTestTapAlertAction:100];
    [monkey run:100];
}

@end
