//
//  MathUtils.m
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#import "MathUtils.h"


CGPoint getRectCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

BOOL isFrameInFrame(CGRect guest, CGRect host)
{
    CGPoint center = getRectCenter(guest);
    return host.origin.x <= center.x && center.x <= host.origin.x + host.size.width &&
            host.origin.y <= center.y && center.y <= host.origin.y + host.size.height;
}
