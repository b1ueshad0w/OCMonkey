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

-(void)addDefaultXCTestPrivateActions;
-(void)addMonkeyLeafElementAction:(int)weight;
-(void)tap:(CGPoint)location;
-(void)tapElement:(Tree *)element;
+(void)dragFrom:(CGPoint)start to:(CGPoint)end;
+(void)dragFrom:(CGPoint)start to:(CGPoint)end duration:(double)duration velocity:(double)velocity;
+(void)swipeUpFrame:(CGRect)frame;
+(void)swipeDownFrame:(CGRect)frame;
+(void)swipeFrom:(CGPoint)start to:(CGPoint)end;
-(void)goBackByDragFromScreenLeftEdgeToRight;
-(void)goBackByDragFromScreenLeftEdgeToRightForduration:(double)duration velocity:(double)velocity;
-(void)swipeVertically:(BOOL)reversed;
-(void)swipeVertically;
-(void)swipeVerticallyReversed;

@end
