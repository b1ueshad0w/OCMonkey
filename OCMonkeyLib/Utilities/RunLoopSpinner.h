//
//  RunLoopSpinner.h
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import <Foundation/Foundation.h>

typedef BOOL (^RunLoopSpinnerBlock)();
typedef __nullable id (^RunLoopSpinnerObjectBlock)();

@interface RunLoopSpinner : NSObject

+ (void)spinUntilCompletion:(void (^)(void(^completion)()))block;

- (instancetype)timeoutErrorMessage:(NSString *)timeoutErrorMessage;

- (instancetype)timeout:(NSTimeInterval)timeout;

- (instancetype)interval:(NSTimeInterval)interval;

- (BOOL)spinUntilTrue:(RunLoopSpinnerBlock)untilTrue;

- (BOOL)spinUntilTrue:(RunLoopSpinnerBlock)untilTrue error:(NSError **)error;

- (nullable id)spinUntilNotNil:(RunLoopSpinnerObjectBlock)untilNotNil error:(NSError **)error;
@end
