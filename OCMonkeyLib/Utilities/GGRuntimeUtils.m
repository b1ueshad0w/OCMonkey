//
//  GGRuntimeUtils.m
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import "GGRuntimeUtils.h"
#include <dlfcn.h>
#import <objc/runtime.h>

void *GGRetrieveSymbolFromBinary(const char *binary, const char *name)
{
    void *handle = dlopen(binary, RTLD_LAZY);
    NSCAssert(handle, @"%s could not be opened", binary);
    void *pointer = dlsym(handle, name);
    NSCAssert(pointer, @"%s could not be located", name);
    return pointer;
}


NSArray<Class> *GGClassesThatConformsToProtocol(Protocol *protocol)
{
    Class *classes = NULL;
    NSMutableArray *collection = [NSMutableArray array];
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses == 0 ) {
        return @[];
    }
    
    classes = (__unsafe_unretained Class*)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    for (int index = 0; index < numClasses; index++) {
        Class aClass = classes[index];
        if (class_conformsToProtocol(aClass, protocol)) {
            [collection addObject:aClass];
        }
    }
    free(classes);
    return collection.copy;
}
