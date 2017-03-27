//
//  UIApplication+Monkey.m
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import "UIApplication+Monkey.h"
#import "MonkeyPaws.h"

@implementation UIApplication (Monkey)

-(void)monkey_sendEvent:(UIEvent*)event
{
    NSMutableArray<MonkeyPaws*> *tracks = [MonkeyPaws tappingTracks];
    for (MonkeyPaws* track in tracks) {
        if (track) {
            [track append:event];
        }
    }
    [self monkey_sendEvent:event];
}

@end
