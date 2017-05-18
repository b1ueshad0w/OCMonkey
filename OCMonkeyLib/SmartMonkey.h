//
//  SmartMonkey.h
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "Monkey.h"

@interface SmartMonkey : Monkey

@property (atomic, readwrite) NSMutableArray *appearedVCs;
@property (atomic, readwrite) NSMutableArray *vcStack;

@end
