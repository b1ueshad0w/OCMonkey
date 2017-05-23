//
//  MathUtils.h
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#ifndef MathUtils_h
#define MathUtils_h

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

CGPoint getRectCenter(CGRect rect);

/**
 Determine whether a frame's center is inside another frame

 @param guest the previous frame
 @param host the latter frame
 @return BOOL
 */
BOOL isFrameInFrame(CGRect guest, CGRect host);

#endif /* MathUtils_h */
