//
//  GGApplication.h
//  OCMonkey
//
//  Created by gogleyin on 28/06/2017.
//
//

#import "XCUIApplication.h"

@interface GGApplication : XCUIApplication

-(instancetype)initWithBundleID:(NSString *)bundleID;

-(void)launch;

+(GGApplication *)activeApplication;

+(int)activeAppProcessID;

@end
