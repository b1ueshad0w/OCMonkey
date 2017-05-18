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
    //Monkey *monkey = [[Monkey alloc] initWithBundleID:testApp];
    SmartMonkey *monkey = [[SmartMonkey alloc] initWithBundleID:testApp];
    //[monkey addDefaultXCTestPrivateActions];
    [monkey addMonkeyLeafElementAction:100];
    [monkey addXCTestTapAlertAction:100];
    [monkey run:20];
}

@end
