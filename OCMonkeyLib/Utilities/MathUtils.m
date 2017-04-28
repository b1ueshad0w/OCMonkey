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
