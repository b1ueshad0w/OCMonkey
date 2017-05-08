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
    NSString *health = @"com.apple.Health";
    NSString *qq = @"com.tencent.qq.dailybuild";
    NSString *bundleID3 = @"com.tencent.rosentest";
    NSString *bundleID4 = @"com.blueshadow.LibMonkeyExample";
    Monkey *monkey = [[Monkey alloc] initWithBundleID:bundleID4];
//    [monkey addDefaultXCTestPrivateActions];
    [monkey addMonkeyLeafElementAction:100];
    [monkey addXCTestTapAlertAction:100];
    [monkey run:200];
}

@end
