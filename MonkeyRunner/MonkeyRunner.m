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
//    NSString *account = @"2724493214";
//    NSString *password = @"blueshadow2010";
    NSString *account = [[NSProcessInfo processInfo] environment][@"USERNAME"];
    NSString *password = [[NSProcessInfo processInfo] environment][@"PASSWORD"];
    NSString *bundleID = [[NSProcessInfo processInfo] environment][@"BundleID"];
    int steps = [[[NSProcessInfo processInfo] environment][@"STEPS"] intValue];
    if (!bundleID) {
        NSString *testApp = @"com.blueshadow.LibMonkeyExample";
        NSString *catalog = @"com.example.apple-samplecode.UIKitCatalog";
        NSString *qq = @"com.tencent.qq.dailybuild";
        bundleID = qq;
    }
    if (!steps) {
        steps = 10000;
    }
    WeightedAlgorithm *algorithm = [[WeightedAlgorithm alloc] init];
    WeightedMonkey *monkey = [[WeightedMonkey alloc] initWithBundleID:bundleID algorithm:algorithm];
    
    [monkey registerAction:^BOOL(ElementTree *tree){
        if (!account) {
            [GGLogger log:@"Please provide account!"];
        }
        if (!password) {
            [GGLogger log:@"Please provide password!"];
        }
        if (![monkey.testedApp.secureTextFields count]) {
            XCUIElement *logInButton = monkey.testedApp.buttons[@"登录"];
            if (!logInButton.exists) {
                [GGLogger log:@"找不到登录按钮！"];
                return NO;
            }
            [logInButton tap];
        }

        XCUIElement *logInButton2 = monkey.testedApp.buttons[@"登录"];
        if (!monkey.testedApp.textFields.count) {
            [GGLogger log:@"找不到QQ号输入框！"];
            return NO;
        }
        if (!monkey.testedApp.secureTextFields.count) {
            [GGLogger log:@"找不到密码输入框！"];
            return NO;
        }
        if (!logInButton2.exists) {
            [GGLogger log:@"找不到登录按钮！"];
            return NO;
        }
        XCUIElement *usernameTextField = [monkey.testedApp.textFields allElementsBoundByIndex][0];
        XCUIElement *passwordSecureTextField = [monkey.testedApp.secureTextFields allElementsBoundByIndex][0];
        
        [usernameTextField gg_clearTextWithError:nil];
        [usernameTextField typeText:account];
        [passwordSecureTextField gg_clearTextWithError:nil];
        [passwordSecureTextField typeText:password];
        [logInButton2 tap];
        
        XCTAssert(!logInButton2.exists);
        return NO;
    } forVC:@"QQLoginViewController"];
    /*
    [monkey registerAction:^BOOL(ElementTree *tree){
        [monkey tapElement:[monkey getValidElementsFromTree:tree][0]];
        return NO;
    } forVC:@"QQRecentController"];
    [monkey registerAction:^BOOL(ElementTree *tree){
        [monkey tapElement:[monkey getValidElementsFromTree:tree][0]];
        return NO;
    } forVC:@"DrawerContentsViewController"];
    [monkey registerAction:^BOOL(ElementTree *tree){
        [monkey tapElement:[monkey getValidElementsFromTree:tree][5]];  // will go to the PendantStoreViewController
        return NO;
    } forVC:@"UserSummaryViewController"];
     */
    [monkey run:steps];
}

@end
