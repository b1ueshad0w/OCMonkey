//
//  MSHook.h
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import <Foundation/Foundation.h>

BOOL MSHookFunction(Class class, SEL original, IMP replacement, IMP* store);
