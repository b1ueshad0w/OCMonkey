//
//  Monkey+XCUITestPrivate.h
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#import "Monkey.h"
#import "Tree.h"

@interface Monkey (XCUITestPrivate)

/**
 Add a default set of event generation actions using the private XCTest API.
 Use this function if you just want to generate some events, and do not have
 strong requirements on exactly which ones you need.
 */
-(void)addDefaultXCTestPrivateActions;

/**
 Add LeafElementAction (action on leaves - those who have no children)

 @param weight The relative probability of this event being generated. 
 Can be any value larger than zero. Probabilities will be normalised to the sum
 of all relative probabilities.
 */
-(void)addMonkeyLeafElementAction:(int)weight;

/**
 Tap a location by coordinates.

 @param location location to tap.
 */
+(void)tapAtLocation:(CGPoint)location;

/**
 Drag between two points.

 @param start start location
 @param end end location
 */
+(void)dragFrom:(CGPoint)start to:(CGPoint)end;

/**
 Drag between two points.

 @param start start location
 @param end end location
 @param duration duration of pressing at start location
 @param velocity speed of dragging (normal value: 1000, for swipe usage: 2000)
 */
+(void)dragFrom:(CGPoint)start to:(CGPoint)end duration:(double)duration velocity:(double)velocity;

/**
 Swipe up a frame.

 @param frame frame to swipe up
 */
+(void)swipeUpFrame:(CGRect)frame;

/**
 Swipe down a frame.

 @param frame frame to swipe down
 */
+(void)swipeDownFrame:(CGRect)frame;

/**
 Swipe between two points.

 @param start start location
 @param end end location
 */
+(void)swipeFrom:(CGPoint)start to:(CGPoint)end;

/**
 Swipe from a frame's left edge to its right edge.
 This is useful to perform going back with an app's frame is passed in.

 @param frame frame to swipe right through
 */
+(void)swipeRightThroughFrame:(CGRect)frame;

/**
 Swipe from a frame's left edge to its right edge.

 @param frame frame to swipe right through
 @param duration duration of pressing at start location
 @param velocity speed of swiping
 */
+(void)swipeRightThroughFrame:(CGRect)frame forDuration:(double)duration velocity:(double)velocity;

@end
