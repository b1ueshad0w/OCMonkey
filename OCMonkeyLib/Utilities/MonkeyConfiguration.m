//
//  MonkeyConfiguration.m
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import "MonkeyConfiguration.h"

static NSUInteger MonkeyMaxTypingFrequency = 60;
static BOOL MonkeyShouldUseTestManagerForVisibilityDetection = NO;

@implementation MonkeyConfiguration

+ (void)setMaxTypingFrequency:(NSUInteger)value
{
    MonkeyMaxTypingFrequency = value;
}

+ (NSUInteger)maxTypingFrequency
{
    return MonkeyMaxTypingFrequency;
}

+ (BOOL)verboseLoggingEnabled
{
  return [NSProcessInfo.processInfo.environment[@"VERBOSE_LOGGING"] boolValue];
}

+ (BOOL)shouldUseTestManagerForVisibilityDetection
{
    return MonkeyShouldUseTestManagerForVisibilityDetection;
}

@end
