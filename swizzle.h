//
//  swizzle.h
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#ifndef swizzle_h
#define swizzle_h

#import <objc/runtime.h>

void swizzleClassMethod(Class class, SEL original, SEL new);

void swizzleInstanceMethod(Class class, SEL original, SEL new);

#endif /* swizzle_h */
