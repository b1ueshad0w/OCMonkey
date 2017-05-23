//
//  SmartMonkey.h
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "Monkey.h"

/**
 SmartMonkey has the ability to inspect test target's ViewController structure.
 */
@interface SmartMonkey : Monkey

/**
 Queue data structure. The most recent appeared VC is at the end of the array.
 */
@property (atomic, readwrite) NSMutableArray *appearedVCs;

/**
 Stack data structure. The most recent pushed VC is at the end of the array.
 */
@property (atomic, readwrite) NSMutableArray *vcStack;

-(NSString *)getCurrentVC;

@end
