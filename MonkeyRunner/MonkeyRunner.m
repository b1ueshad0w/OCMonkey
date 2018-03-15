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
#import "Monkey+XCUITestPrivate.h"
#import "GGLogger.h"
#import "XCUIElement+GGTyping.h"
#import "GGTestCase.h"

@interface MonkeyRunner : GGTestCase

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
    NSString *account = [[NSProcessInfo processInfo] environment][@"USERNAME"];
    NSString *password = [[NSProcessInfo processInfo] environment][@"PASSWORD"];
    NSString *bundleID = [[NSProcessInfo processInfo] environment][@"BundleID"];
    int steps = [[[NSProcessInfo processInfo] environment][@"STEPS"] intValue];
    if (!bundleID) {
        NSString *testApp = @"com.blueshadow.LibMonkeyExample";
        bundleID = testApp;
    }
    if (!steps) {
        steps = 10000;
    }
    WeightedAlgorithm *algorithm = [[WeightedAlgorithm alloc] init];
    WeightedMonkey *monkey = [[WeightedMonkey alloc] initWithBundleID:bundleID algorithm:algorithm];
    
    // This is an example showing how to register a callback to a ViewController
    [monkey registerAction:^BOOL(ElementTree *tree){
        if (!account) {
            [GGLogger log:@"Please provide account!"];
            return NO;
        }
        if (!password) {
            [GGLogger log:@"Please provide password!"];
            return NO;
        }
        XCUIElement *logInButton2 = monkey.testedApp.buttons[@"Username"];
        if (!monkey.testedApp.textFields.count) {
            [GGLogger log:@"Could not find Username textfield!"];
            return NO;
        }
        if (!monkey.testedApp.secureTextFields.count) {
            [GGLogger log:@"Could not find secure text field!"];
            return NO;
        }
        XCUIElement *logInButton = monkey.testedApp.buttons[@"Log In"];
        if (!logInButton.exists) {
            [GGLogger log:@"Could not find log in buttong!"];
            return NO;
        }
        XCUIElement *usernameTextField = [monkey.testedApp.textFields allElementsBoundByIndex][0];
        XCUIElement *passwordSecureTextField = [monkey.testedApp.secureTextFields allElementsBoundByIndex][0];
        
        [usernameTextField gg_clearTextWithError:nil];
        [usernameTextField typeText:account];
        [passwordSecureTextField gg_clearTextWithError:nil];
        [passwordSecureTextField typeText:password];
        [logInButton tap];
        
        XCTAssert(!logInButton.exists);
        return NO;
    } forVC:@"XXLoginViewController"];
    [monkey run:steps];
}

@end
