//
//  XCTestCaseImplementationFailureHoldingProxy.h
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import <Foundation/Foundation.h>

@class _XCTestCaseImplementation;


@interface XCTestCaseImplementationFailureHoldingProxy : NSProxy

+ (instancetype)proxyWithXCTestCaseImplementation:(_XCTestCaseImplementation *)internalImplementation;

@end
