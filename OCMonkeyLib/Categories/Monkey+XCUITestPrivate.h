//
//  Monkey+XCUITestPrivate.h
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#import "Monkey.h"

@interface Monkey (XCUITestPrivate)

-(void)addDefaultXCTestPrivateActions;
-(void)addMonkeyLeafElementAction:(int)weight;

@end
