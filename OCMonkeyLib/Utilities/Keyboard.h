//
//  Keyboard.h
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import <Foundation/Foundation.h>

@interface Keyboard : NSObject

+ (BOOL)typeText:(NSString *)text error:(NSError **)error;

@end
