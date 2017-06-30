//
//  GGApplication.m
//  OCMonkey
//
//  Created by gogleyin on 28/06/2017.
//
//

#import "GGApplication.h"
#import "XCUIElement.h"
#import "XCAXClient_iOS.h"
#import "XCAccessibilityElement.h"

@implementation GGApplication

-(instancetype)initWithBundleID:(NSString *)bundleID
{
    return [super initPrivateWithPath:nil bundleID:bundleID];
}


-(void)launch
{
    [super launch];
    // Do not uncomment the following, until the app-snapshot-unchanged issue is fixed
//    [self query];
//    [self resolve];
    [GGApplication registerApplcation:self withProcessID:self.processID];
}


+(GGApplication *)activeApplication
{
    int pid = [GGApplication activeAppProcessID];
    if (0 == pid) {
        return nil;
    }
    GGApplication *application = [GGApplication appWithPID:pid];
    [application query];
    [application resolve];
    return application;
}


+(instancetype)appWithPID:(pid_t)processID
{
    GGApplication *app = [self registeredAppWithProcessID:processID];
    if (app) {
        return app;
    }
    app = [super appWithPID:processID];
    [GGApplication registerApplcation:app withProcessID:processID];
    return app;
}


+(int)activeAppProcessID
{
    XCAccessibilityElement *activeApplicationElement = [[[XCAXClient_iOS sharedClient] activeApplications] firstObject];
    if (!activeApplicationElement) {
        return 0;
    }
    return activeApplicationElement.processIdentifier;
}

static NSMutableDictionary *PidToAppMapping;

+(instancetype)registeredAppWithProcessID:(pid_t)processID
{
    return PidToAppMapping[@(processID)];
}


+(void)registerApplcation:(GGApplication *)application withProcessID:(pid_t)processID
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PidToAppMapping = [NSMutableDictionary dictionary];
    });
    PidToAppMapping[@(application.processID)] = application;
}


@end
