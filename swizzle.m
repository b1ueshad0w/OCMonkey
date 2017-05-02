//
//  swizzle.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


void swizzleClassMethod(Class class, SEL original, SEL new)
{
    Method originalMethod = class_getClassMethod(class, original);
    Method newMethod = class_getClassMethod(class, new);
    
    if (class_addMethod(class, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, new, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

void swizzleInstanceMethod(Class class, SEL original, SEL new)
{
    Method originalMethod = class_getInstanceMethod(class, original);
    Method newMethod = class_getInstanceMethod(class, new);
    
    if (class_addMethod(class, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, new, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}
