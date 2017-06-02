//
//  MonkeyLogger.h
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import <Foundation/Foundation.h>

@interface MonkeyLogger : NSObject

+ (void)log:(NSString *)message;
+ (void)logFmt:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (void)verboseLog:(NSString *)message;
+ (void)verboseLogFmt:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end
