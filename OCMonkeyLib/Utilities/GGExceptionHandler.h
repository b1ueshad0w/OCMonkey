//
//  GGExceptionHandler.h
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import <Foundation/Foundation.h>

extern NSString *const GGApplicationDeadlockDetectedException;
extern NSString *const GGApplicationCrashedException;
extern NSString *const GGApplicationNotInstalled;
extern NSString *const GGMonkeyInternalError;

@interface GGExceptionHandler : NSObject

@end
