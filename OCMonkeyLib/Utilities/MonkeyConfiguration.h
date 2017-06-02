//
//  MonkeyConfiguration.h
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import <Foundation/Foundation.h>

@interface MonkeyConfiguration : NSObject

@property (class, nonatomic, assign) NSUInteger maxTypingFrequency;

+ (BOOL)verboseLoggingEnabled;

@end
