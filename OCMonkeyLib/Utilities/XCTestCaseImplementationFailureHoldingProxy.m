//
//  XCTestCaseImplementationFailureHoldingProxy.m
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import "XCTestCaseImplementationFailureHoldingProxy.h"
#import "_XCTestCaseImplementation.h"

@interface XCTestCaseImplementationFailureHoldingProxy ()
@property (nonatomic, strong) _XCTestCaseImplementation *internalImplementation;
@end

@implementation XCTestCaseImplementationFailureHoldingProxy

+ (instancetype)proxyWithXCTestCaseImplementation:(_XCTestCaseImplementation *)internalImplementation
{
    XCTestCaseImplementationFailureHoldingProxy *proxy = [super alloc];
    proxy.internalImplementation = internalImplementation;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.internalImplementation;
}

- (BOOL)shouldHaltWhenReceivesControl
{
    return NO;
}

@end
