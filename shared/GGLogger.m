//
//  GGLogger.m
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import "GGLogger.h"

NSString *prefix = @"*** blueshadow ";

@implementation GGLogger

+ (void)log:(NSString *)message
{
    NSLog(@"%@%@", prefix, message);
}

+ (void)logFmt:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
//    NSLogv(format, args);
    NSLogv([prefix stringByAppendingString:format], args);
    va_end(args);
}

+ (BOOL)verboseLoggingEnabled
{
    return [NSProcessInfo.processInfo.environment[@"VERBOSE_LOGGING"] boolValue];
}

+ (void)verboseLog:(NSString *)message
{
    if (!GGLogger.verboseLoggingEnabled) {
        return;
    }
    [self log:message];
}

+ (void)verboseLogFmt:(NSString *)format, ...
{
    if (!GGLogger.verboseLoggingEnabled) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}

@end
