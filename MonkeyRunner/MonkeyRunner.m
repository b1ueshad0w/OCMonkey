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
#import "SmartMonkey.h"
#import "WeightedMonkey.h"

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
    //NSString *healthApp = @"com.apple.Health";
    NSString *testApp = @"com.blueshadow.LibMonkeyExample";
    Monkey *monkey = [[Monkey alloc] initWithBundleID:testApp];
    [monkey addDefaultXCTestPrivateActions];
    [monkey addXCTestTapAlertAction:100];
    [monkey run:30];
}

- (void)testSmartMonkey {
    NSString *testApp = @"com.blueshadow.LibMonkeyExample";
    SmartMonkey *monkey = [[SmartMonkey alloc] initWithBundleID:testApp];
    [monkey addMonkeyLeafElementAction:100];
    [monkey addXCTestTapAlertAction:100];
    [monkey run:30];
}

- (void)testWeightedMonkey {
    NSString *testApp = @"com.blueshadow.LibMonkeyExample";
    WeightedAlgorithm *algorithm = [[WeightedAlgorithm alloc] init];
    WeightedMonkey *monkey = [[WeightedMonkey alloc] initWithBundleID:testApp algorithm:algorithm];
    [monkey run:30];
}

@end
