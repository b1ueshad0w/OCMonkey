//
//  XCTestDaemonsProxy.h
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import <Foundation/Foundation.h>

@protocol XCTestManager_ManagerInterface;

@interface XCTestDaemonsProxy : NSObject

+ (id<XCTestManager_ManagerInterface>)testRunnerProxy;

@end
