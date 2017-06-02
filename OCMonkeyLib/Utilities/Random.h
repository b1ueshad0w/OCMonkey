//
//  Random.h
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import <Foundation/Foundation.h>

@interface Random : NSObject

+ (NSString *)randomString;

+ (NSString *)randomStringWithLength:(NSUInteger)len;

@end
