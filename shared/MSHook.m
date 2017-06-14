//
//  MSHook.m
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import "MSHook.h"
#import <objc/runtime.h>

BOOL MSHookFunction(Class class, SEL original, IMP replacement, IMP* store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}
