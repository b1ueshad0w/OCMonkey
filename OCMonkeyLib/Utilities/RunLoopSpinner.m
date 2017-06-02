//
//  RunLoopSpinner.m
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import "RunLoopSpinner.h"
#import <stdatomic.h>

static const NSTimeInterval FBWaitInterval = 0.1;

@interface RunLoopSpinner ()
@property (nonatomic, copy) NSString *timeoutErrorMessage;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) NSTimeInterval interval;
@end

@implementation RunLoopSpinner
+ (void)spinUntilCompletion:(void (^)(void(^completion)()))block
{
  __block volatile atomic_bool didFinish = false;
  block(^{
    atomic_fetch_or(&didFinish, true);
  });
  while (!atomic_fetch_and(&didFinish, false)) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:FBWaitInterval]];
  }
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _interval = FBWaitInterval;
    _timeout = 60;
  }
  return self;
}

- (instancetype)timeoutErrorMessage:(NSString *)timeoutErrorMessage
{
  self.timeoutErrorMessage = timeoutErrorMessage;
  return self;
}

- (instancetype)timeout:(NSTimeInterval)timeout
{
  self.timeout = timeout;
  return self;
}

- (instancetype)interval:(NSTimeInterval)interval
{
  self.interval = interval;
  return self;
}

- (BOOL)spinUntilTrue:(RunLoopSpinnerBlock)untilTrue
{
  return [self spinUntilTrue:untilTrue error:nil];
}

- (BOOL)spinUntilTrue:(RunLoopSpinnerBlock)untilTrue error:(NSError **)error
{
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:self.timeout];
  while (!untilTrue()) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:self.interval]];
    if (timeoutDate.timeIntervalSinceNow < 0) {
        return NO;
//      return
//      [[[FBErrorBuilder builder]
//        withDescription:(self.timeoutErrorMessage ?: @"FBRunLoopSpinner timeout")]
//       buildError:error];
    }
  }
  return YES;
}

- (id)spinUntilNotNil:(RunLoopSpinnerObjectBlock)untilNotNil error:(NSError **)error
{
  __block id object;
  [self spinUntilTrue:^BOOL{
    object = untilNotNil();
    return object != nil;
  } error:error];
  return object;
}

@end
