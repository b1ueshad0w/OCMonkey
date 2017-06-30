//
//  XCUIDevice+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 29/06/2017.
//
//

#import "XCUIDevice+Monkey.h"

@implementation XCUIDevice (Monkey)

static const NSTimeInterval GGHomeButtonCoolOffTime = 1.;

-(void)pressHome
{
    [self pressButton:XCUIDeviceButtonHome];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:GGHomeButtonCoolOffTime]];
}

@end
