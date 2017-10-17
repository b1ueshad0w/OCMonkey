//
//  XCUIElement+Tree.h
//  OCMonkey
//
//  Created by gogleyin on 26/04/2017.
//
//

#import <XCTest/XCTest.h>
#import "ElementTree.h"

@interface XCUIElement (Monkey)


/**
 Just a short version of 'treeDetectVisible:NO'

 @return ElementTree
 */
-(ElementTree *)tree;

/**
 Detecting 'isVisible' property is rather time-consuming.
 The default implementaion (by XCTest) is even more unbearable. (Sometimes it may cost about 1 minute.)
 'gg_isVisible' defined in XCUIElement+GGIsVisible.m is enhanced but still cost 1 or 2 seconds.

 @param detectVisible whether to detect isVisible property or not
 @return ElementTree
 */
-(ElementTree *)treeDetectVisible:(BOOL)detectVisible;
@end
