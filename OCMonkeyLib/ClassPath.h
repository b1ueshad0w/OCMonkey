//
//  ClassPath.h
//  OCMonkey
//
//  Created by gogleyin on 27/04/2017.
//
//

#import <Foundation/Foundation.h>
#import "ClassPathItem.h"


@interface ClassPath : NSObject

@property NSMutableArray<ClassPathItem *> *pathItems;

-(id)initWithPathItems:(NSMutableArray *)pathItems;

@end
