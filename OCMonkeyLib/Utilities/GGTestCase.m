//
//  GGTestCase.m
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import "GGTestCase.h"
#import "XCTestCaseImplementationFailureHoldingProxy.h"
#import "GGLogger.h"
#import "GGExceptionHandler.h"

@interface GGTestCase ()
@property (nonatomic, assign) BOOL didRegisterAXTestFailure;
@end

@implementation GGTestCase

-(void)setUp
{
    [super setUp];
    self.continueAfterFailure = YES;
    self.internalImplementation = (_XCTestCaseImplementation *)[XCTestCaseImplementationFailureHoldingProxy proxyWithXCTestCaseImplementation:self.internalImplementation];
}

- (void)_enqueueFailureWithDescription:(NSString *)description
                                inFile:(NSString *)filePath
                                atLine:(NSUInteger)lineNumber
                              expected:(BOOL)expected
{
    [GGLogger logFmt:@"Enqueue failure: %@", description];
    const BOOL isPossibleDeadlock = ([description rangeOfString:@"Failed to get refreshed snapshot"].location != NSNotFound) || ([description rangeOfString:@"Failed to get snapshot within"].location != NSNotFound);
    if (!isPossibleDeadlock) {
        self.didRegisterAXTestFailure = YES;
    }
    else if (self.didRegisterAXTestFailure) {
        self.didRegisterAXTestFailure = NO;
        [[NSException exceptionWithName:GGApplicationDeadlockDetectedException
                                reason:@"Cannot communicate with deadlocked application"
                              userInfo:nil]
        raise];
    }
    
    const BOOL isPossibleCrashAtStartUp = ([description rangeOfString:@"Application is not running"].location != NSNotFound);
    const BOOL errorGetMainWindow = ([description rangeOfString:@"Error getting main window"].location != NSNotFound);
    const BOOL isPossibleCrashDuringTest = ([description rangeOfString:@"Failed to copy attributes after 30 retries"].location != NSNotFound);
    if (isPossibleCrashAtStartUp || isPossibleCrashDuringTest || errorGetMainWindow) {
        [[NSException exceptionWithName:GGApplicationCrashedException reason:@"Application is not running, possibly crashed" userInfo:nil] raise];
    }
}

@end
