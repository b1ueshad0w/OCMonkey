//
//  MonkeyLogger.m
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import "MonkeyLogger.h"
#import "MonkeyConfiguration.h"

@implementation MonkeyLogger

+ (void)log:(NSString *)message
{
  NSLog(@"%@", message);
}

+ (void)logFmt:(NSString *)format, ...
{
  va_list args;
  va_start(args, format);
  NSLogv(format, args);
  va_end(args);
}

+ (void)verboseLog:(NSString *)message
{
  if (!MonkeyConfiguration.verboseLoggingEnabled) {
    return;
  }
  [self log:message];
}

+ (void)verboseLogFmt:(NSString *)format, ...
{
  if (!MonkeyConfiguration.verboseLoggingEnabled) {
    return;
  }
  va_list args;
  va_start(args, format);
  NSLogv(format, args);
  va_end(args);
}

@end
